let () =
  let fichier = "conflicts.txt" in
  let cost,no_conflict,nb_avion = Load_data.load fichier in
  let s = Modele.init cost nb_avion in
  let prio = Modele.get_priority s in
  let q = Pqueue.insert prio s Pqueue.empty in   (* Creer la file initiale *)

  let rec solve_rec = fun q ->
    let (prio, s, q) = Pqueue.extract q in
    match s.planes_left with
      [] -> (s.compatible_maneuvers, prio) (* plus d'avions a indenter = sol trouvee *)
    | _ ->
      let plane_id = List.hd s.planes_left in
      let d_tot = s.compitable_maneuver in

      let maneuver_of_id = List.hd s.compatible_maneuver.(plane_id) in

      let dr_id = List.tl s.compatible_maneuver.(plane_id) in
      let d_id = [maneuver_of_id] in

      let dr_tot = Array.set d_tot plane_id dr_id in
      let dnew_tot = Array.set d_tot plane_id d_id in  (* dnew_tot contient les maneuvre compatible après avoir indenté plane_id *)

      let sr = Modele.make dr_tot s.planes_left in
      let s_no_filtered = Modele.make dnew_tot maneuvers_of_id in

      let s_new = Modele.filter plane_id s_no_filter no_conflict in

      let new_q = Pqueue.insert (Modele.get_priority sr) sr q in
      let new_q = Pqueue.insert (Modele.get_priority s_new) s_new new_q in
      solve_rec new_q in

  solve_rec q;;
