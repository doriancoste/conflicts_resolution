val load : string -> int array * bool array array array array * int
(** La fonction load ouvre le fichier.txt passe en argument de type string decrivant les conflits et renvoie un tuple de 2 elements:
    int array * bool array array array array ou
    -int array = cost est un tableau tel que cost.(mi) soit egal au cout de la manoeuvre i
    -bool array array array array = no_conflict tel que: no_conflict.(i).(j).(mi).m(j) soit égal a true si il n'y a pas de conflits entre l'avion i et j effectuant les
      manoeuvre mi et mj, et false sinon **)

val select_bound : string -> bool array array array array -> int -> (Modele.t -> int array -> int)
(**
   prend en argument
   -bound_name : string -> nom de la borne
   cost: int array -> cost.(mi) contient le cout de la manoeuvre mi
   no_conflict: bool array array array array -> no_conflict.(i).(j).(mi).(mj) est true si la manoeuvre mi de l'avion i et mj de l'avion j sont compatibles

   -retour: (Modele.t -> int array -> int) -> fonction correspondant a la borne utilisee
 **)

val select_method : string -> (int -> Modele.t -> bool array array array array -> Modele.t)
(**
   prend en argument
   -method_name : string -> nom de la methodes

   -retour: (int -> Modele.t -> bool array array array array -> Modele.t) -> fonction filter a utiliser, elle correspond a la mthode choisie
 **)
