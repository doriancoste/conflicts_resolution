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


let find_mij = fun i j d_tot no_conflict cost ->
   (**
  cette fonction calcule mij pour i et j fixes
    **)

  (* fonction intermediare permettant de calculer le min de deux valeurs *)
  let cost_min = fun a b ->
    if a<=b then a else b in

  (* on creer une reference vers notre mij potentiel *)
  let mij = ref max_int in

  (* cette fonction prend un domaine di et dj et calcule mij *)
  let rec find = fun di dj ->
    match di with
      (* on boucle jusqu'a epuiser la liste des xi, on renvoie alors le mij trouve *)
      [] -> !mij
    | xi::tail_i ->
      (* cette fonction prend le cout actuel et un xj et renvoie le min du cout actuel et de cout(xi)+cout(xj) *)
      let fonc = fun actual_cost maneuver_j ->
        if no_conflict.(i).(j).(xi).(maneuver_j) then cost_min actual_cost (cost.(xi)+cost.(maneuver_j))
        else actual_cost in

      (* on applique la fonction precedente a partir de xi sur la liste dj avec un fold_left
      et met a jour mij si besoin *)
      mij:= cost_min !mij (List.fold_left fonc !mij dj);
      find tail_i dj in

  (* on applique les elements precedents pour calculer mij *)
  find d_tot.(i) d_tot.(j)

let build_mij_list = fun nb_planes d_tot no_conflict cost ->
  (** cette fonction construit la liste des (i*j*mij) possibles en bouclant i de 0 a nb_planes et j de i+1 a nb_planes-1 pour eviter de calculer mii **)
  let mij_list = ref [] in
  (for i = 0 to nb_planes do
     for j=i+1 to nb_planes-1 do
      mij_list:= (i,j,(find_mij i j d_tot no_conflict cost))::!mij_list;
    done
  done);
  !mij_list;;

let lower_bound = fun mij_list nb_planes ->
  (** cette fonction s'applique a mij_list afin de renvoyer la borne inf = la priorite d'un noeud **)
  let tab = Array.init nb_planes (fun _ -> true) in
  (* on utilise un algorithme glouton pour calculer cette borne *)
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

let get_priority_2 = fun no_conflict nb_planes s cost ->
  (**
  cette fonction utilise les fonctions precedente et renvoie la priorite du noeud s en utilisant le dual du probleme
   **)
  let mij_list = build_mij_list nb_planes s.Modele.compatible_maneuvers no_conflict cost in
  lower_bound mij_list nb_planes;;
