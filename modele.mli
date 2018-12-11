type t = { compatible_maneuvers : int list array; planes_left : int list}
(** Type modèle, associé à une priorité et stocké dans la pqueue **)


exception EmptyCompatibleManeuvers of int
exception EmptyPlanesLeftList

val init: int array -> int -> t
(** Cree le premier problème, avec (int array) les couts (qui donne
   le nombre de manoeuvres et (int) le nombre d'avions.
   Ca commence à l'indice 0. *)

val make : int list array -> int list -> t
(*
d_tot -> int list array; d_tot.(i) contient la liste des maneuvres possibles au noeud s pour l'avion i
planes_left -> int list; planes_left contient les numeros d'avion qui n'ont pas encore eu de maneuvre attribuees

retour : type t -> represente un noeud
*)

val get_compatible_maneuvers : t -> int -> int list
(** Choppe le tableau des maneuvres compatibles restantes
   pour l'avion i : Di *)

val head_compatible_maneuvers : t -> int -> int
(** Choppe la première manoeuvre compatible de la liste. Renvoie
   l'exception EmptyCompatibleManeuvers si liste vide*)

val tail_compatible_maneuvers : t -> int -> int list

(** Choppe les  manoeuvres compatible de la liste, avec la
   première en moins. Renvoie l'exception EmptyCompatibleManeuvers
   si liste vide*)

val is_empty_planes_left : t -> bool
(** renvoie true si la liste des avions restants est vide*)


val filter : int -> int -> t -> bool array array array array -> t
(** Enlève les manoeuvres imcompatibles pour tous les avions dans t.compatible_maneuvers en ayant donné : l'avion i (premier int) effectue la manoeuvre k (deuxième int). On teste grâce à no_conflict. *)

val ac3 : int -> int -> int -> t -> bool array array array array -> t
(**

 **)

val filter_ac3 : int -> int -> t -> bool array array array array -> t
