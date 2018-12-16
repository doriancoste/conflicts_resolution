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


let init cost nb_planes =
  let nombre_de_manoeuvres = Array.length cost in
  let liste_di = create_list nombre_de_manoeuvres (fun i -> i) in

  let liste_di_sorted = List.sort (fun i j -> cost.(i)-cost.(j)) liste_di in (*Tri des manoeuvres, la moins chère d'abord*)

  let a = Array.init nb_planes (fun _ -> liste_di_sorted) in
  let b = create_list nb_planes (fun i -> i) in
  {compatible_maneuvers= a;
   planes_left = b };;

let make = fun d_tot planes_left ->
  (*
d_tot : int list array; d_tot.(i) contient la liste des maneuvres possibles au noeud s pour l'avion i
planes_left : int list; planes_left contient les numeros d'avion qui n'ont pas encore eu de maneuvre attribuees
retour : type t; represente un noeud
*)
  {compatible_maneuvers = d_tot; planes_left = planes_left};;



let get_compatible_maneuvers s i =
  s.compatible_maneuvers.(i);;

let head_compatible_maneuvers s i =
  match s.compatible_maneuvers.(i) with
  |a::b -> a
  |[] -> raise (EmptyCompatibleManeuvers i)
;;


let tail_compatible_maneuvers s i =
  match s.compatible_maneuvers.(i) with
  |a::b -> b
  |[] -> raise (EmptyCompatibleManeuvers i)
;;

let pop_planes_left s =
  match s.planes_left with
   a::b -> b
  |[] -> raise EmptyPlanesLeftList
;;

let is_empty_planes_left s =
  match s.planes_left with
   [] -> true
  |a::b -> false
;;

let filter = fun i s no_conflict ->
  (* on creer une fonction qui a partir de i, de j, de maneuveri, de la matrice des conflits et de la liste
     des manoeuvres possibes pour dj, renvoie la liste des maneuvre possible pour dj sachant que xi=maneuveri *)

  (* cette fonction sera notre prédicat applique aux dj pour les filter. Elle renvoie vrai si les maneuvres sont
  compatible et non sinon *)
  let predicate = fun j maneuver_j ->
    List.exists (fun maneuver_i -> no_conflict.(i).(j).(maneuver_i).(maneuver_j)) s.compatible_maneuvers.(i) in

  (* cette fonction sera appliquee aux avions restants pour réduire leurs domaines en fonctions de la compatibilité avec
    variable instanciee*)
  let iter_on_planes_left = fun j ->
    Array.set s.compatible_maneuvers j (List.filter (predicate j) s.compatible_maneuvers.(j)) in

  (* on iter notre fonction sur les avions non instancies et on renvoie s *)
  List.iter iter_on_planes_left s.planes_left;
  s;;

let rec union_list = fun list_1 list_2 ->
	match list_1 with
	  [] -> list_2
	| hd::tl ->if List.mem hd list_2 then union_list tl list_2 else union_list tl (hd::list_2)	

let consistency = fun i j s no_conflict ->
	let di = s.compatible_maneuvers.(i) in
	let dj = s.compatible_maneuvers.(j) in
	let evolve = ref false in
	let rec consistency_rec = fun new_dj dj_left ->
   match dj_left with
     [] -> new_dj
   |hd_j::tl_j ->
     let rec browse_di = fun di_left ->
       match di_left with
         [] -> false
       |hd_i::tl_i -> if no_conflict.(i).(j).(hd_i).(hd_j) then true else browse_di tl_i
     in
     if browse_di di then consistency_rec (hd_j::new_dj) tl_j
     else (evolve := true; consistency_rec new_dj tl_j)
  in
  let new_dj = List.rev (consistency_rec [] dj) in
  Array.set s.compatible_maneuvers j new_dj;
  !evolve, s

let filter_ac3 = fun i s no_conflict ->
  let nb_planes = Array.length s.compatible_maneuvers in
  let couple_list = fun i ->
    List.init (nb_planes-1) (fun j -> if i>j then i,j else i,j+1) in
  let rec list_explore = fun s list_to_explore ->
    match list_to_explore with
    [] -> s
    |hd::tl ->
      let k,l = hd in
      let evolve, new_s = consistency k l s no_conflict in
      if evolve then list_explore new_s (union_list (couple_list l) tl)
      else list_explore new_s tl
  in
  list_explore s (couple_list i)


(***
    
let filter_init = fun s no_conflict filter_type ->
  (*on applique le filtre initial
filter_type = 0 : le filtre parcourt toute la liste
filter_type = n > 0 : on filtre uniquement sur les n premiers avions*)
  
  let nb_planes = Array.length s.compatible_maneuvers in  

(*on va effectuer le filtrage initial selon les filter_nb_planes premiers avions.
  si on a rentré 0 dans filter_type, on filtre selon tous les avions*)
  
  let filter_nb_planes = if filter_type=0 then nb_planes
  else if filter_type > nb_planes then nb_planes else filter_type in

(*on initialise la liste des couples d'avions à filtrer.
  il y a (filter_nb_planes-1) * nb_planes couples à traiter :
exemple : si il y a 20 avions et filter_nb_planes = 1, il y a 19 couples
  si filter_nb_planes = 2, il y en a 19 + 19, en fait 19 pour chaque avion selon lequel on filtre*)
(*La liste, dans le 2e exemple, est : (1,2) (1,3) ... (1,20) (2,1) (2,3) (2,4) ... (2,20)*)
(**A tester ! Je ne peux pas tester la fonction List.init*)

  let couple_list = fun filter_nb_planes ->
    let size = filter_nb_planes*(nb_planes-1) in (*taille de la liste*)
    List.init size (fun j -> if (j/nb_planes-1)>j%(nb_planes-1) then j/(nb_planes-1),j%(nb_planes-1) else j/(nb_planes-1),(j%(nb_planes-1))+1) in

(*On effectue un filtrage récursif avec consistency*)
(**Je n'ai pas pris la fonction list_explore car askip elle ne fonctionne pas**)
(**La fonction utilisée ici n'est pas AC3 : elle explore naivement les couples qu'on lui donne*)
  let rec filter_couple_list s list_to_explore ->
    match list_to_explore with
    |[] -> s
    |hd::tl ->
        let k,l = hd in
        let evolve, new_s = consistency k l s no_conflict in
        filter_couple_list new_s tl
  in

  filter_couple_list s (couple_list filter_nb_planes)
  
***)
        
    
    
  

  
