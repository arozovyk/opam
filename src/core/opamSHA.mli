(**************************************************************************)
(*                                                                        *)
(*    Copyright 2016-2017 OCamlPro                                        *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(** Pure OCaml implementation of SHA256/512 hashing functions. The hash is
    returned as an hex string. *)

(** Computes the SHA1 hash of a file, returns hex string *)
val sha1_file: string -> string

(** Computes the SHA256 hash of a file, returns hex string *)
val sha256_file: string -> string

(** Computes the SHA512 hash of a file, returns hex string *)
val sha512_file: string -> string

(** Computes a hash of a file using the specified algorithm, returns hex string *)
val hash_file: [< `SHA1 | `SHA256 | `SHA512 ] -> string -> string

(** Computes the SHA1 hash of a string, returns hex string *)
val sha1_string: string -> string

(** Computes the SHA256 hash of a string, returns hex string *)
val sha256_string: string -> string

(** Computes the SHA512 hash of a string, returns hex string *)
val sha512_string: string -> string

(** Computes a hash of a string using the specified algorithm, returns hex string *)
val hash_string: [< `SHA1 | `SHA256 | `SHA512 ] -> string -> string
