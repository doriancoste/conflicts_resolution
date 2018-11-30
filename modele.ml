type t =
    { compatible_maneuvers: int list array; (*les Di*)
      planes_left: int list };;

exception EmptyCompatibleManeuvers of int;;
exception EmptyPlanesLeftList;;

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
  |[] -> raise EmptyPlanesLeftList;;

let empty_planes_left t =
  match t.planes_left with
  |[] -> true
  |a::b -> false;;


let create_reste t =
  (*renvoie le nouveau sous-problème S'*)
  ()
;;

let create_prime t =
  (*renvoie le nouveau sous-problème Sreste*)
  ()
  ;;
    
