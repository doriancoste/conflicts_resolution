val get_priority_1 : Modele.t -> int array -> int
(**
   prend en arguments
   s : type t -> noeud a traiter
   cost: int array -> cost.(mi) contient le cout de la manoeuvre mi

   valeur de retour :int -> priorite definie comme etant la somme des min(xi), xi appartement a compatibles_maneuvers.(i)
 **)


val find_mij : int -> int -> int list array -> bool array array array array -> int array -> int
(**
   prend en arguments
   i: int -> indice ieme avion
   j: int -> indice du jieme avion
   d_tot: int list array -> tableau contenant en i la liste des maneuvres possibles pour l'avion i
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles
   cost: int array -> cost.(mi) contient le cout de la manoeuvre mi

   retour: int -> mij = min (cout(xi)+cout(xj))
                        sc pas de conflit entre xi et xj
                        xi E Di
                        xj E Dj
 **)

val build_mij_list : int -> int list array -> bool array array array array -> int array -> (int*int*int) list
(**
   prend en arguments
   nb_planes : int -> le nombre d'avions
   d_tot: int list array -> tableau contenant en i la liste des maneuvres possibles pour l'avion i
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles
   cost: int array -> cost.(mi) contient le cout de la manoeuvre mi

   retour : int list -> construit la liste des mij grâce à find_mij
 **)

val lower_bound : (int*int*int) list -> int -> int
(**
   prend en arguments
   mij_list: int list -> voir le retour de la fonction ci-dessus
   nb_planes: int -> nombre d'avions

   retour: int -> le minimum des mij recouvrant tout les avions
 **)

val get_priority_2 : bool array array array array -> int -> Modele.t -> int array ->int
  (**
     prend en arguments
     s : Modele.t -> noeud s
     no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles
     cost: int array -> cost.(mi) contient le cout de la manoeuvre mi
     nb_planes: int -> nombre d'avion

     retour: int -> renvoie une borne min du noeud s qui sera sa priorite : elle est calculée a partir du dual de notre probleme
   **)
