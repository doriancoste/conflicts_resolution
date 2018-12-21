type t =
    { compatible_maneuvers: int list array; (*les Di*)
      planes_left: int list };;

exception EmptyCompatibleManeuvers of int;;




let make = fun d_tot planes_left ->
  (*
d_tot : int list array; d_tot.(i) contient la liste des maneuvres possibles au noeud s pour l'avion i
planes_left : int list; planes_left contient les numeros d'avion qui n'ont pas encore eu de maneuvre attribuees
retour : type t; represente un noeud
*)
  {compatible_maneuvers = d_tot; planes_left = planes_left};;
;;


let init = fun cost nb_planes ->
	(**initialiser un noeud s de type t*)
  let nombre_de_manoeuvres = Array.length cost in
  let liste_di = List.init nombre_de_manoeuvres (fun i -> i) in
  let liste_di_sorted = List.sort (fun i j -> cost.(i)-cost.(j)) liste_di in (*Tri des manoeuvres, la moins chère d'abord*)
  let d_tot = Array.init nb_planes (fun _ -> liste_di_sorted) in
  let planes_left = List.init nb_planes (fun i -> i) in
  make d_tot planes_left
;;


let get_compatible_maneuvers = fun s i ->
	(** Choppe le tableau des maneuvres compatibles restantes pour l'avion i : Di *)
  s.compatible_maneuvers.(i)
;;

let head_compatible_maneuvers = fun s i ->
	(** Choppe la première manoeuvre compatible de la liste. Renvoie l'exception EmptyCompatibleManeuvers si liste vide*)
  match s.compatible_maneuvers.(i) with
  |a::b -> a
  |[] -> raise (EmptyCompatibleManeuvers i)
;;

let tail_compatible_maneuvers = fun s i ->
	(** Choppe les manoeuvres compatible de la liste, avec la première en moins. 
	Renvoie l'exception EmptyCompatibleManeuvers si liste vide*)
  match s.compatible_maneuvers.(i) with
  |a::b -> b
  |[] -> raise (EmptyCompatibleManeuvers i)
;;


let is_empty_planes_left = fun s ->
	(** renvoie true si la liste des avions restants est vide*)
  match s.planes_left with
   [] -> true
  |a::b -> false
;;


let choose_plane_to_instantiate = fun s -> (*2ième essaie*)
	(**
	Choisi l'avion à instancier. Ce sera celui ayant le moins de manoeuvres possibles.
 	Pars d'un noeud s de type t et renvoie l'identifiant int de l'avion à instancier.
	*)
 	let rec cpti_aux  = fun l chosen_plane  domain_size_chosen_plane i ->
  	match l with  
   	[] -> chosen_plane
   	| hd::tl -> 
   		if (List.length s.compatible_maneuvers.(i)) < domain_size_chosen_plane 
   		then cpti_aux tl hd (List.length s.compatible_maneuvers.(i)) (i+1)  				
   		else cpti_aux tl chosen_plane domain_size_chosen_plane (i+1) 
 	in
 	cpti_aux s.planes_left (-1) max_int 0 (*  *)
;;


let filter = fun i s no_conflict ->
	(**Enlève les manoeuvres imcompatibles pour tous les avions dans t.compatible_maneuvers en utilisant le tableau des conflits*)
  let predicate = fun j maneuver_j ->
  	(* cette fonction sera notre prédicat applique aux dj pour les filter. 
  	Elle renvoie vrai si les maneuvres sont compatible et non sinon *)
    List.exists (fun maneuver_i -> no_conflict.(i).(j).(maneuver_i).(maneuver_j)) s.compatible_maneuvers.(i) in
    
  let iter_on_planes_left = fun j ->
  	(* cette fonction sera appliquee aux avions restants pour réduire leurs domaines 
  	en fonctions de la compatibilité avec variable instanciee*)
    Array.set s.compatible_maneuvers j (List.filter (predicate j) s.compatible_maneuvers.(j)) in
    
  List.iter iter_on_planes_left s.planes_left;
  s
;;


let rec union_list = fun list_1 list_2 ->
	(**combiner deux lists et assurer l'unicité des éléments*)
	match list_1 with
	  [] -> list_2
	| hd::tl ->if List.mem hd list_2 then union_list tl list_2 else union_list tl (hd::list_2)
;;


let consistency = fun i j s no_conflict ->
	(**choisit des manoeuvres Dj de l'avion j qui sont compatible avec au moins 1 manoeuvre de l'avion i 
	et indicat si des manoeuvres Dj de l'avion j evolve *)
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
  (** Enleve les manoeuvres imcompatibles pour tous les avions dans t.compatible_maneuvers en utilisant ac3*)
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
	(*A tester ! Je ne peux pas tester la fonction List.init*)
  let couple_list = fun filter_nb_planes ->
    let size = filter_nb_planes*(nb_planes-1) in (*taille de la liste*)
    List.init size (fun j -> if (j/nb_planes-1)>(j mod (nb_planes-1)) then j/(nb_planes-1) ,(j mod (nb_planes-1)) else j/(nb_planes-1),(j mod (nb_planes-1))+1) in

	(*On effectue un filtrage récursif avec consistency*)	
	(*Je n'ai pas pris la fonction list_explore car askip elle ne fonctionne pas**)
	(*La fonction utilisée ici n'est pas AC3 : elle explore naivement les couples qu'on lui donne*)
  let rec filter_couple_list = fun s list_to_explore ->
    match list_to_explore with
    |[] -> s
    |hd::tl ->
        let k,l = hd in
        let evolve, new_s = consistency k l s no_conflict in
        filter_couple_list new_s tl in
  filter_couple_list s (couple_list filter_nb_planes)

let no_empty_domain = fun s ->
  (** cette fonction regarde si un domaine du noeud s est vide, car si c'est le cas, la solution est non realisable **)
  let no_empty = ref true in
  let f = fun di ->
    if di = [] then no_empty:=false in
  Array.iter f s.compatible_maneuvers;
  !no_empty
