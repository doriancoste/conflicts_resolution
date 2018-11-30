let () =
  let fichier = "conflicts.txt" in
  let cost,no_conflict,nb_avion = Load_data.load fichier in
  let s = Modele.init cost nb_avion in
  let prio = Modele.get_priority s cost in
  let q = Pqueue.insert prio s Pqueue.empty in   (* Creer la file initiale *)


  let rec solve_rec = fun q ->
    let prio, s, q = Pqueue.extract q in
    match s.Modele.planes_left with
      [] -> (s.compatible_maneuvers, prio) (* plus d'avions a indenter = sol trouvee *)
    | _ ->
      let plane_id = List.hd s.Modele.planes_left in
      let d_tot = s.compatible_maneuvers in

      let maneuver_of_id = List.hd s.compatible_maneuvers.(plane_id) in

      let dr_id = List.tl s.compatible_maneuvers.(plane_id) in
      let d_id = [maneuver_of_id] in

      let dr_tot = d_tot in
      Array.set dr_tot plane_id dr_id;

      let dnew_tot = d_tot in
      Array.set d_tot plane_id d_id;  (* dnew_tot contient les maneuvre compatible après avoir indenté plane_id *)

      let sr = Modele.make dr_tot s.planes_left in
      let s_no_filtered = Modele.make dnew_tot (List.tl s.planes_left) in

      let s_new = Modele.filter plane_id s_no_filtered no_conflict in

      let new_q = Pqueue.insert (Modele.get_priority sr cost) sr q in
      let new_q = Pqueue.insert (Modele.get_priority s_new cost) s_new new_q in
      solve_rec new_q in

  let maneuvers_sol,cost_tot = solve_rec q in
  Printf.printf "cout de la solution: %d\n" cost_tot;
  for i=0 to nb_avion do
    Printf.printf "L'avion %d effectue la manoeuvre %d\n" i (List.hd maneuvers_sol.(i));
  done;;
