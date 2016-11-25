(**************************************************************************)
(*                                                                        *)
(*    Copyright 2015 OCamlPro                                             *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

open OpamTypes

type update =
  | Update_full of dirname
  | Update_patch of filename
  | Update_empty
  | Update_err of exn

module type S = sig
  val name: OpamUrl.backend
  val pull_url: dirname -> OpamHash.t option -> url ->
    generic_file download OpamProcess.job
  val fetch_repo_update:
    repository_name -> dirname -> url -> update OpamProcess.job
  val revision: dirname -> version option OpamProcess.job
end

let compare r1 r2 = compare r1.repo_name r2.repo_name

let to_string r =
  Printf.sprintf "%s (%s)"
    (OpamRepositoryName.to_string r.repo_name)
    (OpamUrl.to_string r.repo_url)

let local dirname = {
  repo_name     = OpamRepositoryName.of_string "local";
  repo_root     = dirname;
  repo_url      = OpamUrl.empty;
  repo_trust    = None;
}

let to_json r =
  `O  [ ("name", OpamRepositoryName.to_json r.repo_name);
        ("kind", `String (OpamUrl.string_of_backend r.repo_url.OpamUrl.backend));
      ]

let check_digest filename = function
  | Some expected
    when OpamRepositoryConfig.(!r.force_checksums) <> Some false ->
    (match OpamHash.mismatch (OpamFilename.to_string filename) expected with
     | None -> true
     | Some bad_hash ->
       OpamConsole.error
         "Bad checksum for %s: expected %s\n\
         \                     got      %s\n\
          Metadata might be out of date, in this case run `opam update`."
         (OpamFilename.to_string filename)
         (OpamHash.to_string expected)
         (OpamHash.to_string bad_hash);
       false)
  | _ -> true

open OpamProcess.Job.Op

let job_text name label =
  OpamProcess.Job.with_text
    (Printf.sprintf "[%s: %s]"
       (OpamConsole.colorise `green (OpamRepositoryName.to_string name))
       label)

let get_diff parent_dir dir1 dir2 =
  let patch = OpamSystem.temp_file "patch" in
  let patch_file = OpamFilename.of_string patch in
  let finalise () = OpamFilename.remove patch_file in
  OpamProcess.Job.catch (fun e -> finalise (); raise e) @@ fun () ->
  OpamSystem.make_command
    ~verbose:OpamCoreConfig.(!r.verbose_level >= 2)
    ~dir:(OpamFilename.Dir.to_string parent_dir) ~stdout:patch
    "diff"
    [ "-ruN";
      OpamFilename.Base.to_string dir1;
      OpamFilename.Base.to_string dir2; ]
  @@> function
  | { OpamProcess.r_code = 0; _ } -> finalise(); Done None
  | { OpamProcess.r_code = 1; _ } -> Done (Some patch_file)
  | _ -> failwith "diff failed. Binary files around ?"
