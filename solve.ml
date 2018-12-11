let () =
  (* let fichier = Sys.argv.(1) in *)
  (* on charge d'abord le dichier du cluster puis on construit le sommet de l'arbre que l'on insert dans la file a priorite *)
  (* let fichier = "conflicts.txt" in *)
  let fichier = String.concat "" ["./conflicts/";Load_data.select_data_file ()] in
  let cost,no_conflict,nb_avion = Load_data.load fichier in
  let s = Modele.init cost nb_avion in
  let bound = Load_data.select_bound no_conflict nb_avion in
  let prio = bound s cost in
  let q = Pqueue.insert prio s Pqueue.empty in   (* Creer la file initiale *)
  let count = ref 0 in
  let start = Sys.time () in
  (* on utilise une fonction récursive qui va depiler les elements de q jusqu'a trouver une solution, en ajoutant les voisin a q *)
  let rec solve_rec = fun q ->
    count:=!count+1;
    let prio, s, q = Pqueue.extract q in
    match s.Modele.planes_left with
    (* plus d'avions a instancier = sol trouvee *)
      [] -> (s.compatible_maneuvers, prio)
    | _ ->
      (* on recupere l'id de l'avion a instancier *)
      let plane_id = List.hd s.Modele.planes_left in
      let d_tot = s.compatible_maneuvers in

      (* on recupere le numero de manoeuvre que l'on va affecter a plane_id *)
      let maneuver_of_id = List.hd s.compatible_maneuvers.(plane_id) in

      (* liste des maneuvres pour plane_id  si plane_id n'effectue PAS maneuver_of_id *)
      let dr_id = List.tl s.compatible_maneuvers.(plane_id) in
      (* liste des maneuvres restantes si plane_id effectue maneuver_of_id (soit le singleton maneuver_of_id) *)
      let d_id = [maneuver_of_id] in

      (* tableau des domaines de maneuvres compatibles au cas plane_id n'effectue PAS maneuver_of_id *)
      let dr_tot = Array.copy d_tot in
      Array.set dr_tot plane_id dr_id;

      (* tableau des domaines de maneuvres compatibles au cas plane_id effectue maneuver_of_id *)
      let dnew_tot = Array.copy d_tot in
      Array.set d_tot plane_id d_id;

      (* noeud de l'arbre contenant les branches ou plane_id n'effectue PAS maneuver_of_id *)
      let sr = Modele.make dr_tot s.planes_left in

      (* noeud de l'arbre contenant les branches ou plane_id effectue maneuver_of_id *)
      let s_no_filtered = Modele.make dnew_tot (List.tl s.planes_left) in
      let s_new = Modele.filter plane_id maneuver_of_id s_no_filtered no_conflict in

      (* on ajoute sr et s_new a la file q *)
      let new_q = Pqueue.insert (Priority.get_priority_1 sr cost) sr q in
      let new_q = Pqueue.insert (Priority.get_priority_1 s_new cost) s_new new_q in
      solve_rec new_q in

  (* on appelle la fonction précédente pour obtenir la solution puis affichage de la solution et du temps d'execution *)
  let maneuvers_sol,cost_tot = solve_rec q in
  let passed_time = Sys.time () -. start in
  Printf.printf "cout de la solution: %d\nnoeud exploré: %d\n\n" cost_tot !count;
  (for i=0 to nb_avion-1 do
    Printf.printf "L'avion %d effectue la manoeuvre: %d\n" (i+1) (List.hd maneuvers_sol.(i));
  done);
  Printf.printf "\nSolution trouvée en %f seconde(s).\n\n\n" passed_time;;
