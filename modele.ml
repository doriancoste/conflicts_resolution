type t =
    { compatible_maneuvers: int list array; (*les Di*)
      planes_left: int list };;

exception EmptyCompatibleManeuvers of int;;
exception EmptyPlanesLeftList;;

let create_list n f =
  let rec creat_rec nombre list =
    if (nombre = -1) then list else
    creat_rec (nombre - 1) ((f nombre) :: list)
  in
  creat_rec (n-1) [];;


let init cost n =
  let nombre_de_manoeuvres = Array.length cost in
  let liste_di = create_list nombre_de_manoeuvres (fun i -> i) in

  let liste_di_sorted = List.sort (fun i j -> cost.(i)-cost.(j)) liste_di in (*Tri des manoeuvres, la moins chère d'abord*)

  let a = Array.init n (fun _ -> liste_di_sorted) in
  let b = create_list n (fun i -> i) in
  {compatible_maneuvers= a;
   planes_left = b };;

let make = fun d_tot planes_left ->
  (*
d_tot : int list array; d_tot.(i) contient la liste des maneuvres possibles au noeud s pour l'avion i
planes_left : int list; planes_left contient les numeros d'avion qui n'ont pas encore eu de maneuvre attribuees
retour : type t; represente un noeud
*)
  {compatible_maneuvers = d_tot; planes_left = planes_left};;



let get_compatible_maneuvers t i =
  t.compatible_maneuvers.(i);;

let head_compatible_maneuvers t i =
  match t.compatible_maneuvers.(i) with
  |a::b -> a
  |[] -> raise (EmptyCompatibleManeuvers i)
;;


let tail_compatible_maneuvers t i =
  match t.compatible_maneuvers.(i) with
  |a::b -> b
  |[] -> raise (EmptyCompatibleManeuvers i)
;;

let pop_planes_left t =
  match t.planes_left with
   a::b -> b
  |[] -> raise EmptyPlanesLeftList
;;

let is_empty_planes_left t =
  match t.planes_left with
   [] -> true
  |a::b -> false
;;

let filter = fun i maneuveri s no_conflict ->
  (* on creer une fonction qui a partir de i, de j, de maneuveri, de la matrice des conflits et de la liste
des manoeuvres possibes pour dj, renvoie la liste des maneuvre possible pour dj sachant que xi=maneuveri *)

  (* cette fonction batie la nouvelle liste dj a partir de la precedente en enlevant les manoeuvres incompatible avec maneuver_i *)
  let rec dj_to_newdj = fun j dj_list new_dj_list ->
    match dj_list with
      [] -> List.rev new_dj_list
    | hd::tl ->
      if no_conflict.(i).(j).(maneuveri).(hd) then
        let new_dj_list = hd::new_dj_list in
        dj_to_newdj j tl new_dj_list
      else
        dj_to_newdj j tl new_dj_list in

  (* cette fonction parcours le tableau d et applique filter sur chacun de ses elements correspondant a un avion restant,
     elle renvoie le d mis a jour ainsi que la liste des avion restant *)
  let rec browse_D = fun planes_left d_array new_planes_left ->
    match planes_left with
      [] -> (d_array, List.rev new_planes_left)
    | hd::tl ->
      Array.set d_array hd (dj_to_newdj hd d_array.(hd) []);
      let new_planes_left = hd::new_planes_left in
      browse_D tl d_array new_planes_left in
  
  (* on renvoie le noeud s apres y avoir applique le filtre *)
  let darray,p_left = browse_D s.planes_left s.compatible_maneuvers [] in
  make darray p_left;;

  let ac3 = fun i j maneuver_i s no_conflict ->
    let c_maneuvers = s.compatible_maneuvers in
    let rec xi_match_rec = fun list_j result->
      match list_j with
        [] -> result
      | maneuver_j::tail ->
          if no_conflict.(i).(j).(maneuver_i).(maneuver_j) then
            xi_match_rec tail (maneuver_j::result)
          else
            xi_match_rec tail result
    in
    Array.set c_maneuvers j (xi_match_rec c_maneuvers.(j) []);
    make c_maneuvers s.planes_left;;

let filter_ac3 = fun i maneuveri s no_conflict ->
  let n = Array.length s.compatible_maneuvers in (* n planes in total*)
  let result = ref s in
  for j=0 to n-1 do
    begin
      if j !=i then
        result := ac3 i j maneuveri !result no_conflict;
    end
  done;
  s;;
