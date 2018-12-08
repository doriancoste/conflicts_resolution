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
  !priority


let glouton1 = fun mij_list navion ->
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
