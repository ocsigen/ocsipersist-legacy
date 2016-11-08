(* Ocsigen
 * http://www.ocsigen.org
 * Module ocsipersist.mli
 * Copyright (C) 2016 Vasilis Papavasileiou
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

type 'a wrap = 'a

let storage () =
  Js.Optdef.case (Dom_html.window##localStorage)
    (fun () -> failwith "Browser storage not supported")
    (fun v -> v)

type 'a t = Js.js_string Js.t

let make_id ~store ~name : 'a t =
  Js.string (Printf.sprintf "__ocsipersist_%s_%s" store name)

type store = string

let open_store s = Lwt.return s

let set id v =
  (storage ())##setItem(id, Json.output v)

let make_persistent_lazy ~store ~name ~default =
  let id = make_id ~store ~name in
  let x = (storage ())##getItem(id)
  and f _ = id
  and g () = set id (default ()); id in
  Js.Opt.case x g f

let make_persistent_lazy_lwt = make_persistent_lazy

let make_persistent ~store ~name ~default =
  let default () = default in
  make_persistent_lazy ~store ~name ~default

let get id =
  let x = (storage ())##getItem(id)
  and f = Json.unsafe_input
  and g () =
    (* this is not supposed to fail, beause the reference must have
       been initialized via make_persistent* *)
    failwith "get"
  in
  Js.Opt.case x g f
