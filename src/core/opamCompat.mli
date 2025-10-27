(**************************************************************************)
(*                                                                        *)
(*    Copyright 2018-2020 OCamlPro                                        *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

module String : sig
  (** Tests if at least one character satisfies the predicate (OCaml >= 4.13) *)
  val exists: (char -> bool) -> string -> bool

  (** Tests if a string starts with the given prefix (OCaml >= 4.13) *)
  val starts_with: prefix:string -> string -> bool

  (** Tests if a string ends with the given suffix (OCaml >= 4.13) *)
  val ends_with: suffix:string -> string -> bool

  (** Tests if all characters satisfy the predicate (OCaml >= 4.13) *)
  val for_all: (char -> bool) -> string -> bool

  (** Left-associative fold over the characters of a string (OCaml >= 4.13) *)
  val fold_left: ('a -> char -> 'a) -> 'a -> string -> 'a
end

module Seq : sig
  (** Finds the first element of a sequence for which the function returns [Some] (OCaml >= 4.14) *)
  val find_map: ('a -> 'b option) -> 'a Seq.t -> 'b option
end

module Either : sig
  (** Either type for representing a value of one of two possible types (OCaml >= 4.12) *)
  type ('a, 'b) t =
    | Left of 'a
    | Right of 'b
end

module Lazy : sig
  (** Maps a function over a lazy value (OCaml >= 4.13) *)
  val map : ('a -> 'b) -> 'a Lazy.t -> 'b Lazy.t

  (** Maps a function over a lazy value, preserving already-forced status (OCaml >= 4.13) *)
  val map_val: ('a -> 'b) -> 'a Lazy.t -> 'b Lazy.t
end

module Unix : sig
  (** Returns the canonicalized absolute pathname. Uses [realpath] for OCaml >= 4.13.0,
      implementation with double chdir otherwise *)
  val realpath: string -> string
end

module Filename: sig
  (** NOTE: OCaml >= 4.10 *)

  val quote_command :
    string -> ?stdin:string -> ?stdout:string -> ?stderr:string
    -> string list -> string
end

module List : sig
  (** NOTE: OCaml >= 4.11 *)
  val fold_left_map : ('acc -> 'a -> 'acc * 'b) -> 'acc -> 'a list -> 'acc * 'b list

  (** NOTE: OCaml >= 4.12 *)
  val equal : ('a -> 'a -> bool) -> 'a list -> 'a list -> bool
end

module type MAP = sig
  include Stdlib.Map.S

  (** NOTE: OCaml >= 4.11 *)
  val filter_map: (key -> 'a -> 'b option) -> 'a t -> 'b t
end

module Map(Ord : Stdlib.Map.OrderedType) : MAP with type key = Ord.t

module Pair : sig
  (** NOTE: OCaml >= 5.4 *)
  val equal :
    ('a -> 'a -> bool) -> ('b -> 'b -> bool) ->
    ('a * 'b) -> ('a * 'b) -> bool
end
