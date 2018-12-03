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

  let liste_di_sorted = List.sort (fun i j -> cost.(i)-cost.(j)) liste_di in

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

let filter = fun i manoeuvrei s no_conflict ->
  let rec parcours_compat = fun dj compat j -> (*renvoie un Dj*)
    match compat with
     [] -> dj
    |hd::tl -> if no_conflict.(i).(j).(manoeuvrei).(hd) = true then
        parcours_compat (List.append dj [hd]) tl j
    else parcours_compat dj tl j
  in
  let rec parcours_planes = fun nouveau_tableau_des_Di planes  -> (*donne le tableau des Di*)
    match planes with
    |[] -> nouveau_tableau_des_Di
    |hd::tl -> parcours_planes (Array.append nouveau_tableau_des_Di  [|parcours_compat [] s.compatible_maneuvers.(hd) hd|]) tl
  in
  make (parcours_planes [||] s.planes_left) s.planes_left


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
