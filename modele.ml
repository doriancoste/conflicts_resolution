type t =
    { Compatible_maneuvers : int list array; (*les Di*)
      Planes_left : int list; };;

exception EmptyCompatibleManeuvers(i)

let head t i =
  match t.Compatible_maneuvers.(i) with
  |a::b -> a
  |[] -> raise EmptyCompatibleManeuvers(i);;

let tail t i =
  match t.Compatible_maneuvers.(i) with
  |a::b -> b
  |[] -> raise EmptyCompatibleManeuvers(i);;

let create_reste t =
  (*renvoie le nouveau sous-problème S'*)
;;

let create_prime t =
  (*renvoie le nouveau sous-problème Sreste*)
  ;;
    
