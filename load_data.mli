val load : string -> int array * bool array array array array * int
(**
   prend en arguments
   -fic_name : string -> nom du fichier

   -retour: int array * bool array array array array * int -> cost*no_cnflicts*nb_planes



   La fonction load ouvre le fichier.txt passe en argument de type string decrivant les conflits et renvoie un tuple de 2 elements:
    int array * bool array array array array ou
    -int array = cost est un tableau tel que cost.(mi) soit egal au cout de la manoeuvre i
    -bool array array array array = no_conflict tel que: no_conflict.(i).(j).(mi).m(j) soit égal a true si il n'y a pas de conflits entre l'avion i et j effectuant les
      manoeuvre mi et mj, et false sinon
   -int = nb_planes qui est le nombre d'avion

 **)

val select_bound : string -> bool array array array array -> int -> (Modele.t -> int array -> int)
(**
   prend en arguments
   -bound_name : string -> nom de la borne
   -cost: int array -> cost.(mi) contient le cout de la manoeuvre mi
   -no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles

   -retour: (Modele.t -> int array -> int) -> fonction correspondant a la borne utilisee
 **)

val select_filter : string -> (int -> Modele.t -> bool array array array array -> Modele.t)
(**
   prend en argument
   -method_name : string -> nom de la methodes

   -retour: (int -> Modele.t -> bool array array array array -> Modele.t) -> fonction filter a utiliser, elle correspond a la mthode choisie
 **)

val init_s : bool -> int array -> int -> bool array array array array -> Modele.t
(**
   prend en arguments
   -fiter_init : bool -> true si on applique un filtre initial
   -cost: int array -> cost.(mi) contient le cout de la manoeuvre mi
   nb_planes : int -> le nombre d'avions
   -no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles


   -retour : modele.t -> noeud de depart
 **)
