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


val filter : int -> t -> bool array array array array -> t
(**
   i : int -> indice de l'avion instancie
   s : type t -> noeud a developper
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles

   retour: type t -> noeud filtre

   Enlève les manoeuvres imcompatibles pour tous les avions dans t.compatible_maneuvers en utilisant le tableau des conflits
**)

val consistency : int -> int -> t -> bool array array array array -> bool*t
(**

   i : int -> indice de l'avion instancie
   j : int -> indice de l'avion pour lequel on va trier les manoeuvres
   s : type t -> noeud a filter
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles

   retour : bool*t -> booleen a true si une modification a ete effectue dans dj dans le type t renvoye

 **)

val filter_ac3 : int -> t -> bool array array array array -> t
(**
   i : int -> indice de l'avion instancie
   s : type t -> noeud a developper
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles

   retour: type t -> noeud filtre

   Enleve les manoeuvres imcompatibles pour tous les avions dans t.compatible_maneuvers en utilisant ac3
 **)

val no_empty_domain : t -> bool
(**
   prend en argument
   s : type t -> noeud initial

   retour: bool -> true si le domaine ne contient pas d'ensemble vide et false sinon
 **)
