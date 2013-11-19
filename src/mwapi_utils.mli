(* Copyright (C) 2013  Petter Urkedal <paurkedal@gmail.com>
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version, with the OCaml static compilation exception.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *)

module String_map : Prime_map.S with type key = string

val failwith_f : ('a, unit, string, 'b) format4 -> 'a

val pair : 'a -> 'b -> 'a * 'b

type params = (string * string) list

val pass : ('a -> string) -> string -> 'a -> params -> params
val pass_opt : ('a -> string) -> string -> 'a option -> params -> params
val pass_list : ('a -> string) -> string -> 'a list -> params -> params
val pass_if : string -> bool -> params -> params

module K_repair : sig
  open Kojson
  val int : jin -> int
end