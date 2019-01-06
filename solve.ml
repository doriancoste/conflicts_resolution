let () =

  (** options par defaut **)
  let n = ref 5 in
  let e = ref 1 in
  let r = ref 0 in
  let bound = ref "naive" in
  let filt = ref "naive" in
  let init_filter = ref true in

  (** fonction pour parametrer les options **)
  let set_n = fun nb -> n:=nb in
  let set_e = fun nb -> e:=nb in
  let set_r = fun nb -> r:=nb in
  let set_bound = fun bound_name -> bound:=bound_name in
  let set_filter = fun filter_name -> filt:=filter_name in

  (** definition des options **)
  let speclist = [("-n", Arg.Int (set_n), "nombre d'avion (defaut:5)");
                  ("-e", Arg.Int (set_e), "nombre d'erreur (defaut:1)");
                  ("-r", Arg.Int (set_r), "graine (defaut:0)");
                  ("-b", Arg.String (set_bound), "borne ('naive'(defaut) ou 'mij')");
                  ("-f", Arg.String (set_filter), "filtre ('naive'(defaut) ou 'ac3')");
                  ("-if", Arg.Clear init_filter, "desactive le filtre initial (present par defaut)");
                 ] in
  Arg.parse speclist print_endline "Erreur dans le passage des arguments";

  (* on recupere le fichier du cluster a utiliser grace aux options *)
  let file = "conflicts/cluster_"^(string_of_int !n)^"ac_"^(string_of_int !e)^"err_"^(string_of_int !r)^".txt" in
  (* on charge d'abord le dichier du cluster puis on construit le sommet de l'arbre que l'on insert dans la file a priorite *)

  let cost,no_conflict,nb_planes = Load_data.load file in

  (* on creer le sommet de l'arbre *)
  let s=Load_data.init_s !init_filter cost nb_planes no_conflict in

  (* attribution de la borne et du filtre *)
  let bound = Load_data.select_bound !bound no_conflict nb_planes in
  let filter = Load_data.select_filter !filt in

  (* Creer la file initiale *)
  let priority = bound s cost in
  let q = Pqueue.insert priority s Pqueue.empty in
  let count = ref 0 in
  (* on utilise une fonction récursive qui va depiler les elements de q jusqu'a trouver une solution, en ajoutant les voisin a q *)
  let rec solve_rec = fun q ->
    count:=!count+1;
    let priority, s, q = Pqueue.extract q in
    match s.Modele.planes_left with
    (* plus d'avions a instancier => sol trouvee *)
      [] -> (s.compatible_maneuvers, priority)
    | _ ->
      (* on recupere l'id de l'avion a instancier *)

      (* let plane_id = List.hd s.Modele.planes_left in *)
      (*******************   integrer choose plane to instanciate   ************************)
      let plane_id = Modele.choose_plane_to_instantiate s in
      let d_tot = s.compatible_maneuvers in

      (* on recupere le numero de manoeuvre que l'on va affecter a plane_id *)
      let maneuver_id = List.hd s.compatible_maneuvers.(plane_id) in

      (* liste des maneuvres pour plane_id  si plane_id n'effectue PAS maneuver_id *)
      let dr_id = List.tl s.compatible_maneuvers.(plane_id) in
      (* liste des maneuvres restantes si plane_id effectue maneuver_id (soit le singleton maneuver_id) *)
      let d_id = [maneuver_id] in

      (* tableau des domaines de maneuvres compatibles au cas plane_id n'effectue PAS maneuver_id *)
      let dr_tot = Array.copy d_tot in
      Array.set dr_tot plane_id dr_id;

      (* tableau des domaines de maneuvres compatibles au cas plane_id effectue maneuver_id *)
      let dnew_tot = Array.copy d_tot in
      Array.set dnew_tot plane_id d_id;

      (* noeud de l'arbre contenant les branches ou plane_id n'effectue PAS maneuver_id *)
      let sr = Modele.make dr_tot s.planes_left in

      (* noeud de l'arbre contenant les branches ou plane_id effectue maneuver_id *)
      (* let s_no_filtered = Modele.make dnew_tot (List.tl s.planes_left) in *)
      (*******************   enlever l'avion choisis par choose_plane_to_instanciate   ************************)
      let s_no_filtered = Modele.make dnew_tot (List.filter (fun i -> i!=plane_id) s.planes_left) in
      let s_new = filter plane_id s_no_filtered no_conflict in

      (* on teste que sr et snew n'ai pas de domaine vide, donc qu'ils soient realisables puis on ajoute sr et s_new a la file q si besoin *)
      let add_to_q = fun q not_empty s cost ->
        if not_empty then
          Pqueue.insert (bound s cost) s q
        else
          q in

      let new_q = add_to_q q (Modele.no_empty_domain sr) sr cost in
      let new_q = add_to_q new_q (Modele.no_empty_domain s_new) s_new cost in


      (* on rapelle solve *)
      solve_rec new_q in

  (* on appelle la fonction précédente pour obtenir la solution puis affichage de la solution et du temps d'execution *)
  let start = Sys.time () in
  let maneuvers_sol,cost_tot = solve_rec q in
  let passed_time = Sys.time () -. start in
  (* la ligne ci dessous affiche le cout de la solution*)
  Printf.printf "cout de la solution: %d\nnombre de noeuds explorés: %d\n\n" cost_tot !count;

  (*  les lignes ci dessous affiche la maneuvre de chaque avion *)
  (*
  (for i=0 to nb_planes-1 do
    Printf.printf "L'avion %d effectue la manoeuvre: %d\n" (i+1) (List.hd maneuvers_sol.(i));
    done);
*)
  Printf.printf "\nSolution trouvée en %f seconde(s).\n\n\n" passed_time;;
