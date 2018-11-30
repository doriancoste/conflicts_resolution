val load : string -> int array * bool array array array array
(** La fonction load ouvre le fichier.txt passe en argument de type string decrivant les conflits et renvoie un tuple de 2 elements:
    int array * bool array array array array ou
    -int array = cost est un tableau tel que cost.(mi) soit egal au cout de la manoeuvre i
    -bool array array array array = no_conflict tel que:
    - no_conflict.(i).(j).(mi).m(j) soit égal a true si il n'y a pas de conflits entre l'avion i et j effectuant les
      manoeuvre mi et mj, et false sinon **)


val main : unit -> unit
(** ce main est un test pour la fonction précédente, rien de définitif sur ses valeurs de retour **)