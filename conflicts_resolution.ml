(* La fonction read ouvre pour l'instant le fichier des conflits et affiche son contenu. Il
   faut la modifier pour qu'elle retourne a terme tableau nécessaire au reste de notre projet.
   Elle gère déjà la fin de fichier et les éventuels problème d'ouverture*)
let load = fun fic_name ->
  let fic = open_in fic_name in
  let nb_planes = ref 0 in
  let nb_man = ref 0 in
  let line_0 = input_line fic in
  (match line_0.[0] with
  'd' ->
      let data = String.split_on_char ' ' line_0 in
      let data = List.tl data in
      Printf.printf "descriptif du fichier: \n";
      Printf.printf "number of aircrafts : %s \n" (List.hd data);
      nb_planes := int_of_string (List.hd data);
      let data = List.tl data in
      Printf.printf "number of maneuver : %s \n" (List.hd data);
      nb_man := int_of_string (List.hd data);
      let data = List.tl data in
      Printf.printf "d0 max : %s \n" (List.hd data);
      let data = List.tl data in
      Printf.printf "d1 max : %s \n" (List.hd data);
      let data = List.tl data in
      Printf.printf "alpha max : %s \n" (List.hd data);
  | lettre -> (Printf.printf "Type de premiere ligne inconnu : commence par %c \n" lettre));
  let cost = Array.make !nb_man 0 in
  let not_ended = ref true in
  (while !not_ended do
      try
        let line = input_line fic in
                (* print_string (String.concat "" [(line); "\n" ]); *)
                (* la commande en commentaire affiche la ligne lue, mais il faudra modifier cette étape afin de traiter chaque ligne en remplissant des tableaux *)
                (* le pattern matching suivant va a terme:
                   - afficher les différentes caractéristiques du fichier
                   - utiliser les données des nogoods pour remplir une matrice
                   - utiliser les données des coût pour remplir un tableau
                   - afficher un message si une ligne n'est pas comprise *)
        match line.[0] with
        'c' -> Printf.printf "nogoods \n";
        | 'm' ->
          Printf.printf "cost of maneuver \n";
          let data = String.split_on_char ' ' line in
          let data = List.tl data in
          let n_man = int_of_string (List.hd data) in
          let data = List.tl data in
          let cost_man = int_of_string (List.hd data)in
          Array.set cost n_man cost_man;
          Printf.printf "cost of maneuver %d: %d \n" n_man cost_man;
        | lettre -> Printf.printf "Type de ligne inconnu : commence par %c \n" lettre;
      with End_of_file -> not_ended:= false;
    done);
  cost

let main () =
  Printf.printf "loading data ...\n";
  let cost = load "conflicts.txt" in
  Printf.printf "data loaded\n cost=[";

  let print = fun i ->
    Printf.printf "%d; " i in
  Array.iter print cost;
  Printf.printf "]\n";;



main ();;

(* a commenter !!!! *)

(* ocamlc conflicts_resolution.ml -o conflicts_resolution dans le répertoire du fichier *)
