val get_priority_1 : Modele.t -> int array -> int
(**Calcule la priorite associee à l'objet t a partir de la liste des couts
   noeud s : type t
   liste des couts cost : int array
   valeur de retour : priorité: int

   Dans cette fonction, la priorite est definie comme etant la somme des min(xi), xi appartement a compatibles_maneuvers.(i)
 **)


val find_mij : int -> int -> int array array -> bool array array array array -> int array -> int
(**
   calcule mij = min (cout(xi)+cout(xj))
       sc pas de conflit entre xi et xj
       xi E Di
       xj E Dj
 **)

val build_mij_list : int -> int list array -> bool array array array array -> int array -> int list
(**
   prend en argument
   navion : int -> le nombre d'avions
   d: int list array -> tableau contenant en i la liste des maneuvres possibles pour l'avion i
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles
   cost: int array -> cost.(mi) contient le cout de la manoeuvre mi

   retour : int list -> construit la liste des mij grâce à find_mij
 **)

val lower_bound : int list -> int -> int
(**
   prend en argument
   mij_list: int list -> voir le retour de la fonction ci-dessus
   navion: int -> nombre d'avions

   retour: int -> le minimum des mij recouvrant tout les avions
 **)
