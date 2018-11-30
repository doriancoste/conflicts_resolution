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

(** Priority queues : elements are inserted in the queue according to their priority. In this implementation, the extraction operation returns the element of lowest numerical value for the priority. A priority queue can be used to store the nodes that remain to be explored, when performing a tree search. *)


(***)
type ('a, 'b) t
(** The priority queue type. A priority queue contains elements of type ['b], inserted into the queue according to its priority. A priority is of type ['a]. *)

exception Empty
(** This exception is raised when trying to extract an element from an empty priority queue. *)

val empty : ('a, 'b) t
(** An empty priority queue. *)

val is_empty : ('a, 'b) t -> bool
(** [is_empty q] returns [true] is [q] is empty, and false otherwise.*)

val cardinal : ('a, 'b) t -> int
(** [cardinal q] returns the number of elements in the priority queue [q]. *)

val insert : ?cmp:('a -> 'a -> int) -> 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
(** [insert cmp prio x q] inserts [x] in the priority queue [q] according to its priority [prio], and returns the resulting updated priority queue. [cmp] is the function comparing two priorities ([cmp] default value is [compare]).*)

val extract : ?cmp:('a -> 'a -> int) -> ('a, 'b) t -> ('a * 'b * ('a, 'b) t)
(** [extract q] returns a tuple [(prio,x,new_q)] where [x] is the element of lower value for [prio] extracted from the priority queue [q], and [new_q] is the priority queue after removal of [x]. *)

val iter : ('a -> 'b -> unit) -> ('a, 'b) t -> unit
(** [iter f q] applies function [f] to the elements of [q], ordered by priority *)

val elements: ?cmp:('a -> 'a -> int) -> ('a, 'b) t -> 'b list
(** [elements q] returns the elements of [q] ordered by priority *)

(***)

    

(*** Interface when using Map

(** NOTE : The current implementation relies on module Map and the priority is of type <float>. For an efficient implementation with a priority of polymorphic type, re-implement using balanced binary trees. *)

type prio= float 

type 'a t
(** The priority queue type. A priority queue contains elements of type ['a], inserted into the queue according to their priority (of type [float]). *)

exception Empty
(** This exception is raised when trying to extract an element from an empty priority queue. *)

val empty : 'a t
(** An empty priority queue. *)

val is_empty : 'a t -> bool
(** [is_empty q] returns [true] is [q] is empty, and false otherwise.*)

val size : 'a t -> int
(** [size q] returns the number of elements in the priority queue [q]. *)

val insert : prio -> 'a -> 'a t -> 'a t
(** [insert prio x q] inserts [x] in the priority queue [q] according to its priority [prio], and returns the resulting updated priority queue.*)

val extract : 'a t -> (prio * 'a * 'a t)
(** [extract q] returns a tuple [(prio,x,new_q)] where [x] is the element of lower value for [prio] extracted from the priority queue [q], and [new_q] is the priority queue after removal of [x]. *)

val iter : ((prio *'a) -> unit) -> 'a t -> unit
(** [iter f q] applies function [f] to the elements of [q], ordered by priority *)

val elements: 'a t -> 'a list
(** [elements q] returns the elements of [q] ordered by priority *)
***)
