(**************************************************************************)
(*                                                                        *)
(*    Copyright 2019 OCamlPro                                             *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(** System package *)
type t
include OpamStd.ABSTRACT with type t := t

(** Converts a set of strings to a set of system packages *)
val raw_set: OpamStd.String.Set.t -> Set.t

(** System packages status *)
type status =
  {
    s_available : Set.t;
    (** Package available but not installed *)

    s_not_found : Set.t;
    (** Package unavailable on this system *)
  }

(** Empty status record with no packages *)
val status_empty: status

(** Converts a status record to a human-readable string *)
val string_of_status: status -> string

(** System packages to install. We need to split per purpose as some
    distribution need to keep up-to-date already installed system packages. See
    {!OpamSysInteract.install_packages_commands_t}. *)
type to_install =
  {
    ti_new : Set.t;
    (** Package to install required by new opam packages *)

    ti_required : Set.t
    (** Package to install required by already install opam packages *)
  }

(** Empty to_install record with no packages *)
val to_install_empty: to_install

(** Converts a to_install record to a human-readable string *)
val string_of_to_install: to_install -> string
