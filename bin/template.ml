(* Copyright (C) 2013--2019  Petter A. Urkedal <paurkedal@gmail.com>
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

open Mwapi_common
open Printf
open Unprime_list
open Unprime_string

type frag =
  | Text of string
  | Stencil of string * string option
and t = frag list

let subst f =
  List.flatten_map
    (function
     | Text _ as frag -> [frag]
     | Stencil (x, _) as frag ->
        (match f x with
         | None -> [frag]
         | Some templ -> templ))

let subst_map m =
  subst (fun x -> try Some (String_map.find x m) with Not_found -> None)

let stencil_re = Re.compile
  Re.(seq [str "{{STENCIL|"; group (rep1 (compl [set "{}"])); str "}}"])

let of_string txt =
  let trn = function
   | `Text s -> Some (Text s)
   | `Delim g ->
      let s = Re.Group.get g 1 in
      Some (match String.cut_affix "|" s with
            | None -> Stencil (s, None)
            | Some (x, s') -> Stencil (x, Some s'))
  in
  List.filter_map trn (Re.split_full stencil_re txt)

let bprint buf =
  List.iter
    (function
      | Text s -> Buffer.add_string buf s
      | Stencil (x, None) -> bprintf buf "{{STENCIL|%s}}" x
      | Stencil (x, Some s) -> bprintf buf "{{STENCIL|%s|%s}}" x s)

let to_string frags =
  let buf = Buffer.create 1024 in
  bprint buf frags;
  Buffer.contents buf
