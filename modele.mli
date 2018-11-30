type t = { compatible_maneuvers : int list array; planes_left : int list; };
(*Type modèle, associé à une priorité et stocké dans la pqueue*)


exception EmptyCompatibleManeuvers of int;
exception EmptyPlanesLeftList;

val get_compatible_maneuvers : t -> int -> int list;


val head_compatible_maneuvers : t -> int -> int;

val tail_compatible_maneuvers : t -> int -> int list;

val pop_planes_left : t -> int list;

val is_empty_planes_left : t -> bool;

val create_reste : t -> t;
  (*renvoie le nouveau sous-problème S'*)

val create_prime : t -> t;
  (*renvoie le nouveau sous-problème Sreste*)
