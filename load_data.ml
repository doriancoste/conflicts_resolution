let load = fun fic_name ->
  (** La fonction load ouvre le fichier.txt passe en argument de type string decrivant les conflits et renvoie un tuple de 2 elements:
      int array * bool array array array array ou
     -int array = cost est un tableau tel que cost.(mi) soit egal au cout de la manoeuvre i
     -bool array array array array = no_conflict tel que:
     - no_conflict.(i).(j).(mi).m(j) soit égal a true si il n'y a pas de conflits entre l'avion i et j effectuant les
       manoeuvre mi et mj, et false sinon **)
  (*
     La fonction affiche egalement les dimensions du probleme
     Quelques details sur les differentes etapes de l'algo sont a suivre
  *)

  (* cette partie ouvre le fichier texte donné en argument et creer les differentes reference dont on aura besoin,
     qui correspondent au carateristique du fichier de conflits  *)
  let fic = open_in fic_name in
  let nb_planes = ref 0 in
  let nb_man = ref 0 in

  (* on analyse ensuite la premiere ligne afin d'attribuer les valeurs aux variable decrites avant *)
  let line_0 = input_line fic in
  (match line_0.[0] with
  'd' ->
      let data = String.split_on_char ' ' line_0 in
      let data = List.tl data in
      (* ces lignes en commentaires affiches les caractéristiques du fichier *)
      (*
      Printf.printf "\ndescriptif du fichier: \n";
      Printf.printf "Nombre d'avion : %s \n" (List.hd data);
      *)
      nb_planes := int_of_string (List.hd data);
      let data = List.tl data in
      (* ces lignes en commentaires affiches les caractéristiques du fichier *)
      (*Printf.printf "Nombre de manoeuvre : %s \n" (List.hd data);*)
      nb_man := int_of_string (List.hd data);
      (* ces lignes en commentaires affiches les caractéristiques du fichier *)
      (* let data = List.tl data in
      Printf.printf "d0 max : %s \n" (List.hd data);
      let data = List.tl data in
      Printf.printf "d1 max : %s \n" (List.hd data);
      let data = List.tl data in
      Printf.printf "alpha max : %s \n" (List.hd data);*)

  | lettre -> (Printf.printf "Type de premiere ligne inconnu : commence par %c \n" lettre));

  (* nous avons maintenant les dimension du probleme, on peut creer les elements cost et no_conflict que nous allons retourner *)
  let cost = Array.init !nb_man (fun _ -> 0) in
  let no_conflict = Array.init !nb_planes (fun _ -> Array.init !nb_planes (fun _ -> Array.init !nb_man (fun _ -> Array.init !nb_man (fun _ -> true)))) in

  (* on parcourt ensuite le reste du fichier jusqu'a sa fin en remplissant les deux élement crée si dessus *)
  let not_ended = ref true in
  (while !not_ended do
      try
        let line = input_line fic in
                (* pour chaque ligne, on regarde la premiere lettre qui va determiner si cette ligne remplie cost ou no_conflict *)
        match line.[0] with
        'c' ->
          (* dans le cas ou elle commence par c, on remplie no_conflict avec les booleens adequats *)
          let data = String.split_on_char ' ' line in
          let data = List.tl data in
          let i = int_of_string (List.hd data) in
          let data = List.tl data in
          let j = int_of_string (List.hd data) in
          let data = List.tl data in
          let mi = int_of_string (List.hd data) in
          let data = List.tl data in
          let build_conf_array = fun mj ->
            Array.set no_conflict.(i).(j).(mi) (int_of_string mj) false;
            Array.set no_conflict.(j).(i).(int_of_string mj) (mi) false in
          List.iter build_conf_array data
        | 'm' ->
          (* dans le cas ou elle commence par c, on remplie cost avec les int adequats *)
          let data = String.split_on_char ' ' line in
          let data = List.tl data in
          let n_man = int_of_string (List.hd data) in
          let data = List.tl data in
          let cost_man = int_of_string (List.hd data)in
          Array.set cost n_man cost_man;
        | lettre -> Printf.printf "Type de ligne inconnu : commence par %c \n" lettre;
      with End_of_file -> not_ended:= false;
    done);
  Printf.printf "\n";
  flush Pervasives.stdout;
  (cost,no_conflict,!nb_planes);;

let select_bound = fun bound_name no_conflict nb_planes->
  (* selection de la borne *)
  if (String.equal bound_name "naive") then
    (Printf.printf "borne: naive\n";
     Priority.get_priority_1)
  else
    (if (String.equal bound_name "mij") then
       (Printf.printf "borne: mij\n";
        Priority.get_priority_2 no_conflict nb_planes)
     else
       failwith "unknown bound");;

let select_filter = fun filter_name ->
  (* selection de la filtre *)
  if (String.equal filter_name "naive") then
    (Printf.printf "filter: naive\n";
     Modele.filter)
  else
    (if (String.equal filter_name "ac3") then
       (Printf.printf "filter: ac3\n";
        Modele.filter_ac3)
     else
       failwith "unknown filter");;

let init_s = fun init_filter cost nb_planes no_conflict ->
  if init_filter then
    (Printf.printf "filtrage initial: true\n";
       Modele.filter_init (Modele.init cost nb_planes) no_conflict 0)
  else
    (Printf.printf "filtrage initial: true\n\n";
      Modele.init cost nb_planes);;
