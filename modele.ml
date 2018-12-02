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
  creat_rec n [];;


let init cost n =
  let nombre_de_manoeuvres = Array.length cost in
  let liste_di = List.init nombre_de_manoeuvres (fun i -> i) in

  let liste_di_sorted = List.sort (fun i j -> cost.(i)-cost.(j)) liste_di in

  let a = Array.init n (fun _ -> liste_di_sorted) in
  let b = List.init n (fun i -> i) in
  {compatible_maneuvers= a;
   planes_left = b };;



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
  |a::b -> b
  |[] -> raise EmptyPlanesLeftList
;;

let is_empty_planes_left t =
  match t.planes_left with
  |[] -> true
  |a::b -> false
;;

let filter = fun i s m->
  (*
     m : bool array array array array
     s : type t {compatible_maneuvers: int list array; planes_left: int list}
     i : ième avion (int)
   *)
  let c_maneuvers = s.compatible_maneuvers in
  let p_left = s.planes_left in
  let n = Array.length c_maneuvers in (* n planes in total*)
  let n_left = List.length p_left in
  let n_comp = n - n_left in (*nombre of planes compatible*)

  (*jeme plane, maneuvres of jeme plane, one maneuvre of ieme plane, compatible or not, return compatible or not with j*)
  (*If there is no conflit, return true*)
  let rec j_match_rec = fun j list_j xi result->
    match list_j with
      [] -> result
    | xj::tail ->
      let no_conflit = m.(i).(j).(xi).(xj) in
      let result = (no_conflit && result) in
      if (result = true) then
        j_match_rec j tail xi result
      else
        result
  in

  (*one maneuvre of ieme plane, return compatible or not with all j in c_maneuvers *)
  (*If there is no conflit, return true*)
  let rec match_rec = fun xi->
    let result  = ref true in
    for j=0 to n_comp -1 do
      result := !result && (j_match_rec j c_maneuvers.(j) xi true)
    done;
    !result
  in

  (*maneuvres of ieme plane, maneuvres compatible of ieme plane*)
  let rec filtre_rec = fun list_i result->
    match list_i with
      [] -> result
    | xi::tail ->
        if (match_rec xi) then
          filtre_rec tail (xi::result)
        else
          filtre_rec tail result
  in
  (* filtre_rec c_maneuvers.(i) [] *)

(* Je met une valeur de retour bidon pour pouvoir compiler *)
s

let make = fun d_tot planes_left ->
  (*
d_tot : int list array; d_tot.(i) contient la liste des maneuvres possibles au noeud s pour l'avion i
planes_left : int list; planes_left contient les numeros d'avion qui n'ont pas encore eu de maneuvre attribuees
retour : type t; represente un noeud
*)
  {compatible_maneuvers = d_tot; planes_left = planes_left};;

let get_priority = fun s cost ->
  (*
s : type t; decrit un noeud
cost : int Array ; cost.(i) contient le cout de la manoeuvre i
retour : int; correspond au cout minimun que l'on peut obtenir a partir de s
 *)
  let domain = s.compatible_maneuvers in
  let size = Array.length domain in
  let priority = ref 0 in
  (for i = 0 to size-1 do
     priority := !priority + cost.(List.hd domain.(i));
   done);
  !priority
