(***********************************************************************)
(*                                                                     *)
(*                     Astar (A* algorithm)                            *)
(*                                                                     *)
(*         David Gianazza, Ecole Nationale de l'Aviation Civile        *)
(*                                                                     *)
(*  Copyright 2017 Ecole Nationale de l'Aviation Civile.               *)
(*  All rights reserved.  This file is distributed under the terms of  *)
(*  the GNU Library General Public License.                            *)
(*                                                                     *)
(***********************************************************************)

(*------------------*)
(* File de priorité *)

(*------------------------------------------------*)
(* Implantation efficace, avec un maximier (heap) *)

type ('a,'b) t =
    Node of ('a,'b) node
  | Nil

and ('a,'b) node = {
    key: 'a;
    data: 'b;
    left: ('a,'b) t;
    right: ('a,'b) t}
;;

exception Empty;;

let empty = Nil;;
let is_empty t = t=Nil;;

let make k d l r = Node {key= k; data= d; left= l; right= r};;

let rec insert ?(cmp = compare) x v t =
  match t with
    Nil -> Node {key=x; data=v; left=Nil; right=Nil}
  | Node {key= y; data=d; left=l; right=r} ->
      let c= cmp x y in
      if c<=0 then (* Insert (y,d) in right branch and swap right and left. *)
        make x v (insert ~cmp y d r) l
      else (* Insert (x,v) in right branch and swap right and left. *)
        make y d (insert ~cmp x v r) l
;;

let root t =
  match t with
    Nil -> raise Empty
  | Node {key= k; data=d; left=l; right=r} -> (k,d)

let rec remove ?(cmp = compare) t =
  match t with
    Nil -> raise Empty
  | Node {left=Nil; right=r} -> r
  | Node {left=l; right=Nil} -> l
  | Node {left=l; right=r} ->
      let (x,v)= root l and (y,w)= root r in
      if cmp x y <0 then  make x v (remove ~cmp l) r
      else make y w l (remove ~cmp r)

let extract ?(cmp = compare) t =
  let (prio,x)= root t in
  (prio, x, remove ~cmp t);;

let rec elements ?(cmp = compare) q =
  if is_empty q then []
  else
    let (_,x,new_q)= extract ~cmp q in
    x:: elements ~cmp new_q;;

let rec cardinal = function
    Nil -> 0
  | Node {left= l; right= r} -> cardinal l + 1 + cardinal r;;

let rec iter f = function
    Nil -> ()
  | Node {key=k; data=d; left=l; right=r} ->
    iter f l; f k d; iter f r;;
