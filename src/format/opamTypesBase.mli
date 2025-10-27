(**************************************************************************)
(*                                                                        *)
(*    Copyright 2012-2018 OCamlPro                                        *)
(*    Copyright 2012 INRIA                                                *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(** Helper functions on the base types (from [OpamTypes]) *)

(** This module contains basic utility functions and stringifiers for the
    basic OPAM types present in OpamTypes.ml *)

open OpamParserTypes.FullPos
open OpamTypes

(** Converts a standard installation path to its string representation *)
val string_of_std_path: std_path -> string

(** Parses a string into a standard installation path *)
val std_path_of_string: string -> std_path

(** Returns a list of all available standard installation paths *)
val all_std_paths: std_path list

(** Compares two package actions for equality using a custom equality function *)
val action_equal : ('a -> 'a -> bool) -> 'a action -> 'a action -> bool

(** Extract a package from a package action. *)
val action_contents: [< 'a action ] -> 'a list

(** Maps a function over the package in an atomic action (Remove, Install) *)
val map_atomic_action: ('a -> 'b) -> 'a atomic_action -> 'b atomic_action

(** Maps a function over the packages in a highlevel action (includes Change, Reinstall, plus atomic actions) *)
val map_highlevel_action: ('a -> 'b) -> 'a highlevel_action -> 'b highlevel_action

(** Maps a function over the packages in a concrete action (Build, Fetch, plus atomic actions) *)
val map_concrete_action: ('a -> 'b) -> 'a concrete_action -> 'b concrete_action

(** Maps a function over the packages in any action type *)
val map_action: ('a -> 'b) -> 'a action -> 'b action

(** Extract a packages from a package action. This returns all concerned
    packages, including the old version for an up/down-grade. *)
val full_action_contents: 'a action -> 'a list

(** Pretty-prints the cause of an action *)
val string_of_cause: ('pkg -> string) -> 'pkg cause -> string

(** Pretty-print *)
val string_of_shell: shell -> string

(** The empty file position *)
val pos_null: pos

(** Wraps a value with an empty position *)
val nullify_pos : 'a -> 'a with_pos

(** Maps a function over a positioned value and returns it with an empty position *)
val nullify_pos_map : ('a -> 'b) -> 'a with_pos -> 'b with_pos

(** Recursively removes position information from a value *)
val nullify_pos_value : value -> value

(** [pos_best pos1 pos2] returns the most detailed position between [pos1] and
    [pos2] (defaulting to [pos1]) *)
val pos_best: pos -> pos -> pos

(** Position in the given file, with unspecified line and column *)
val pos_file: filename -> pos

(** Prints a file position *)
val string_of_pos: pos -> string

(** Converts a user action to its string representation *)
val string_of_user_action: user_action -> string

(** Makes sure to keep only the last binding for a given variable; doesn't
    preserve order *)
val env_array: env -> string array

exception Parse_variable of string * string

(** Parses the data suitable for a filter.FIdent from a string. A
    self-reference [_] parses to [None].
    @raise Failure on bad package names.*)
val filter_ident_of_string:
  string -> name option list * variable * (string * string) option

(** Like {!filter_ident_of_string} but parses also [%{?pkg+:var:}%] syntax for
    variables with package name that contains a [+].

    @raise {!Parse_variable} [(pkg,var)] if [accept] is [false] when several
    [+] are encountered in package name, i.e. [pkg++:var]. *)
val filter_ident_of_string_interp:
  ?accept:bool -> string
  -> name option list * variable * (string * string) option

(** Converts a filter identifier to its string representation *)
val string_of_filter_ident:
  name option list * variable * (string * string) option -> string

(** Compares two package flags for equality *)
val pkg_flag_equal: package_flag -> package_flag -> bool

(** Parses a string into a package flag *)
val pkg_flag_of_string: string -> package_flag

(** Converts a package flag to its string representation *)
val string_of_pkg_flag: package_flag -> string

(** Returns a list of all available package flags *)
val all_package_flags: package_flag list

(** Map on a solver result *)
val map_success: ('a -> 'b) -> ('a,'fail) result -> ('b,'fail) result

(** Applies a function to the success value in a result, if present *)
val iter_success: ('a -> unit) -> ('a, 'b) result -> unit

(** Environment update helpers *)

(** Builds an environment update with the specified parameters *)
val env_update:
  ?comment:string -> rewrite:'a separator_path_format option
  -> string -> 'b env_update_op_kind -> string
  -> ('a, 'b) env_update

(** Builds a resolved environment update (paths already processed) *)
val env_update_resolved:
  ?comment:string -> ?rewrite:spf_resolved separator_path_format option
  -> string -> 'a env_update_op_kind -> string
  -> (spf_resolved, 'a) env_update

(** Builds an unresolved environment update (paths with variables) *)
val env_update_unresolved:
  ?comment:string -> ?rewrite:spf_unresolved separator_path_format option
  -> string -> 'a env_update_op_kind -> string
  -> (spf_unresolved, 'a) env_update

(** Converts a raw environment update operation to a writeable operation kind *)
val op_of_raw: OpamParserTypes.FullPos.env_update_op_kind -> euok_writeable env_update_op_kind

(** Converts a writeable environment update operation to raw format *)
val raw_of_op: euok_writeable env_update_op_kind -> OpamParserTypes.FullPos.env_update_op_kind

(** Path transformers & separator functions *)

(** Converts a path format to its string representation *)
val string_of_path_format: path_format -> string

(** Converts a separator type to its character representation *)
val char_of_separator: separator -> char

(** Comparators **)

(** Compares two switch selections *)
val switch_selections_compare : switch_selections -> switch_selections -> int

(** Tests if two switch selections are equal *)
val switch_selections_equal : switch_selections -> switch_selections -> bool

(** Tests equality of two simple arguments *)
val simple_arg_equal : simple_arg -> simple_arg -> bool

(** Tests equality of two arguments *)
val arg_equal : arg -> arg -> bool

(** Tests equality of two filters *)
val filter_equal : filter -> filter -> bool

(** Tests equality of two commands *)
val command_equal : command -> command -> bool
