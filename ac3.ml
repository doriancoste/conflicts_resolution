type t =
    { compatible_maneuvers: int list array; (*les Di*)
      planes_left: int list };;


let make = fun d_tot planes_left ->
  {compatible_maneuvers = d_tot; planes_left = planes_left};;


let ac3= fun s m->
  (*
     m : bool array array array array
     s : type t {compatible_maneuvers: int list array; planes_left: int list}
   *)
  let c_maneuvers = s.compatible_maneuvers in
  let p_left = s.planes_left in
  let n = Array.length c_maneuvers in (* n planes in total*)
  (*jeme plane, maneuvres of jeme plane, ieme plane, one maneuvre of ieme plane, bool, return compatible or not between xi and all xj of jeme plane*)
  (*If there is no conflit, return true*)
  let rec xi_match_rec = fun j list_j i xi result->
    match list_j with
      [] -> result
    | xj::tail ->
      let no_conflit = m.(i).(j).(xi).(xj) in
      let result = (no_conflit && result) in
      if (result = true) then
        xi_match_rec j tail i xi result
      else
        result
  in
  (*jeme plane, maneuvres of jeme plane, ieme plane,  maneuvres of ieme plane, list, return all xi compatible with all xj of jeme plane*)
  let rec i_match_rec = fun j list_j i list_i result->
    match list_i with
    	[] -> result
		| xi::tail -> 
			if xi_match_rec j list_j i xi true = true then
				i_match_rec j list_j i tail (xi::result)
			else
				i_match_rec j list_j i tail result
	in
	for i=0 to n -1 do
		for j = i+1 to n-1 do
			c_maneuvers.(i) <- i_match_rec j c_maneuvers.(j) i c_maneuvers.(i) [];
		done;
	done;
	make c_maneuvers  p_left
  
  
  
  
  
  
  
