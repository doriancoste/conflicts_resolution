
(* La fonction read ouvre pour l'instant le fichier des conflits et affiche son contenu. Il
   faut la modifier pour qu'elle retourne a terme tableau nécessaire au reste de notre projet.
 Elle gère déjà la fin de fichier et les éventuels problème d'ouverture*)
let load = fun fic_name ->
  try
    let fic = open_in fic_name in
    try
    while true do
      let line = input_line fic in
      print_string (String.concat "" [(line); "\n" ])
      (* on affiche ici la ligne, mais il faudra modifier cette étape afin de traiter chaque ligne en remplissant des tableaux *)
    done
    with
      End_of_file -> close_in fic
  with
    Sys_error str -> Printf.printf "Erreur lors de l'ouverture: %s \n" str


let main () =
  Printf.printf "loading data ...\n";
  load "conflicts.txt";
  Printf.printf "data loaded\n";
  exit 0;;
main ();;

(* ocamlc conflicts_resolution.ml -o conflicts_resolution dans le répertoire du fichier *)
