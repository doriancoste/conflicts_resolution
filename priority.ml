let get_priority_1 = fun s cost ->
  (*
s : type t; decrit un noeud
cost : int Array ; cost.(i) contient le cout de la manoeuvre i
retour : int; correspond au cout minimun que l'on peut obtenir a partir de s
 *)
  let domain = s.Modele.compatible_maneuvers in
  let size = Array.length domain in
  let priority = ref 0 in
  (for i = 0 to size-1 do
     priority := !priority + cost.(List.hd domain.(i));
   done);
  !priority;;


let find_mij = fun i j d no_conflits cost ->
   (*
  mij = min (c(xi)+c(xj))
         sc pas de conflit entre xi et xj
         xi E Di
         xj E Dj
   *)
  let cost_min = fun a b ->
    if a<=b then b else a in

  let mij = ref max_int in

  let rec find = fun di dj ->
    match di with
      [] -> !mij
    | xi::tail_i ->
      let fonc = fun actual_cost maneuver_j ->
        if no_conflits.(i).(j).(xi).(maneuver_j) then cost_min actual_cost (cost.(xi)+cost.(maneuver_j))
        else actual_cost in

      mij:= cost_min !mij (List.fold_left fonc !mij dj);
      find tail_i dj in

  find d.(i) d.(j)

let build_mij_list = fun navion d no_conflicts cost ->
  let mij_list = ref [] in
  (for i = 0 to navion do
     for j=i+1 to navion-1 do
      mij_list:= (i,j,(find_mij i j d no_conflicts cost))::!mij_list;
    done
  done);
  !mij_list;;

let lower_bound = fun mij_list navion ->
  let tab = Array.init navion (fun _ -> true) in
  let rec glout = fun liste prio ->
    match liste with
      []-> prio
    | hd::tail ->
      let i,j,mij=hd in
      if tab.(i)&&tab.(j) then
        (Array.set tab i false;
         Array.set tab j false;
         glout tail prio+mij)
      else
        glout tail prio in
  glout mij_list 0;;

let get_priority_2 = fun no_conflicts n_avion s cost ->
  let mij_list = build_mij_list n_avion s.Modele.compatible_maneuvers no_conflicts cost in
  lower_bound mij_list n_avion;;
