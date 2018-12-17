let () =

  (** options par defaut **)
  let n = ref 5 in
  let e = ref 1 in
  let r = ref 0 in
  let bound = ref "naive" in
  let meth = ref "bandb" in

  (** fonction pour parametrer les options **)
  let set_n = fun nb -> n:=nb in
  let set_e = fun nb -> e:=nb in
  let set_r = fun nb -> r:=nb in
  let set_bound = fun bound_name -> bound:=bound_name in
  let set_method = fun method_name -> meth:=method_name in

  (** definition des options **)
  let speclist = [("-n", Arg.Int (set_n), "nombre d'avion (defaut:5)");
                  ("-e", Arg.Int (set_e), "nombre d'erreur (defaut:1)");
                  ("-r", Arg.Int (set_r), "graine (defaut:0)");
                  ("-b", Arg.String (set_bound), "borne ('naive'(defaut) ou 'mij')");
                  ("-m", Arg.String (set_method), "methode ('bandb'(defaut) ou 'ac3')");
                 ] in
  Arg.parse speclist print_endline "Erreur dans le passage des arguments";

  (* on recupere le fichier du cluster a utiliser grace aux options *)
  let file = "conflicts/cluster_"^(string_of_int !n)^"ac_"^(string_of_int !e)^"err_"^(string_of_int !r)^".txt" in
  (* on charge d'abord le dichier du cluster puis on construit le sommet de l'arbre que l'on insert dans la file a priorite *)

  let cost,no_conflict,nb_planes = Load_data.load file in
  let s(**s0*) = Modele.init cost nb_planes in
  (** let s = Modele.filter_init s0 no_conflict filter_type *)

(**on applique le filtre initial
filter_type = 0 : le filtre parcourt toute la liste
filter_type = n > 0 : on filtre uniquement sur les n premiers avions

note : filter_type à rajouter dans les arguments de lancement de l'algo (en rajoutant un test qui vérifie que c'est un entier positif)

note : quand on aura implémenté le tri des avions (le plus contraint en premier), le filtrage selon les premiers avions sera celui qui éliminera le plus de solutions*)


  (* attribution de la borne et de la methode *)
  let bound = Load_data.select_bound !bound no_conflict nb_planes in
  let filter = Load_data.select_method !meth in

  let priority = bound s cost in
  let q = Pqueue.insert priority s Pqueue.empty in   (* Creer la file initiale *)
  let count = ref 0 in
  let start = Sys.time () in
  (* on utilise une fonction récursive qui va depiler les elements de q jusqu'a trouver une solution, en ajoutant les voisin a q *)
  let rec solve_rec = fun q ->
    count:=!count+1;
    let priority, s, q = Pqueue.extract q in
    match s.Modele.planes_left with
    (* plus d'avions a instancier = sol trouvee *)
      [] -> (s.compatible_maneuvers, priority)
    | _ ->
      (* on recupere l'id de l'avion a instancier *)
      let plane_id = List.hd s.Modele.planes_left in
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
      let s_no_filtered = Modele.make dnew_tot (List.tl s.planes_left) in
      let s_new = filter plane_id s_no_filtered no_conflict in

      (* on ajoute sr et s_new a la file q *)
      let new_q = Pqueue.insert (bound sr cost) sr q in
      let new_q = Pqueue.insert (bound s_new cost) s_new new_q in
      solve_rec new_q in

  (* on appelle la fonction précédente pour obtenir la solution puis affichage de la solution et du temps d'execution *)
  let maneuvers_sol,cost_tot = solve_rec q in
  let passed_time = Sys.time () -. start in
  Printf.printf "cout de la solution: %d\nnombre de noeuds explorés: %d\n\n" cost_tot !count;
  (for i=0 to nb_planes-1 do
    Printf.printf "L'avion %d effectue la manoeuvre: %d\n" (i+1) (List.hd maneuvers_sol.(i));
  done);
  Printf.printf "\nSolution trouvée en %f seconde(s).\n\n\n" passed_time;;
