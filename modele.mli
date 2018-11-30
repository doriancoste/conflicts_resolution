type t = { compatible_maneuvers : int list array; planes_left : int list; };
(**Type modèle, associé à une priorité et stocké dans la pqueue*)


exception EmptyCompatibleManeuvers of int
exception EmptyPlanesLeftList

val init: int array -> int -> t
(**Crée le premier problème, avec (int array) les couts (qui donne
   le nombre de manoeuvres et (int) le nombre d'avions. 
   Ca commence à l'indice 0.*)

val make : int list array -> int list -> t
(** Cree le type t à partir de ses deux composantes*)

val get_compatible_maneuvers : t -> int -> int list
(**Choppe le tabelau des maneuvres compatibles restantes
   pour l'avion i : Di *)
 
val head_compatible_maneuvers : t -> int -> int
(**Choppe la première manoeuvre compatible de la liste. Renvoie 
   l'exception EmptyCompatibleManeuvers si liste vide*)

val tail_compatible_maneuvers : t -> int -> int list
 
(**Choppe les  manoeuvres compatible de la liste, avec la 
   première en moins. Renvoie l'exception EmptyCompatibleManeuvers
   si liste vide*)
 
val del_i_planes_left : t -> int -> int list
(**Supprime l'indice i dans la liste planes_left*)

val is_empty_planes_left : t -> bool
(**renvoie true si la liste des avions restants est vide*)

val create_reste : t -> t
(**renvoie le nouveau sous-problème S'*)

val create_prime : t -> t
(**renvoie le nouveau sous-problème Sreste*)

val get_priority : t -> int array -> int
(**Calcule la priorité associée à l'objet t*)
