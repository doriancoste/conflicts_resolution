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
  let rec fm_aux_k = fun mk k l ->
   (*
     renvoie mij pour une manoeuvre k de l'avion i : mk
     cad on trouve la manoeuvre de l'avion j qui a le plus petit cout et qui est compatible avec la manoeuvre k pour l'avion i
   *)
    let xi = d.(i).(k) in
    let xj = d.(j).(l) in
    if Array.length d.(j) < l then
      begin
        let xjj = d.(j).(l+1) in
        match no_conflits.(i).(j).(xi).(xj) with
          true -> if (cost.(xi) + cost.(xj) < mk) then fm_aux_k (cost.(xi) + cost.(xj)) xi xjj else fm_aux_k mk xi xjj
        | false -> fm_aux_k mk xi xjj
      end
    else mk in
  let rec fm_list = fun k acc ->
   (*
     renvoie la liste des mij pour l'avion i pour chaque manoeuvre k
   *)
    let len = Array.length d.(i) in
    if k < len then fm_list (k+1) ((fm_aux_k max_int k 0)::acc) else acc in
   (*
     on trie par ordre croissant et on prends le premier element
   *)
  List.hd (List.fast_sort (fun a b -> a - b) (fm_list 0 []));;

let build_mij_list = fun navion d no_conflicts cost ->
  let mij_list = ref [] in
  (for i = 0 to navion do
    for j=i+1 to navion do
      mij_list:= (find_mij i j d no_conflicts cost)::!mij_list;
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
