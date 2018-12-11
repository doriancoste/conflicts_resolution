let ac3 = fun i j maneuveri s no_conflict ->
  let c_maneuvers = s.compatible_maneuvers in
  let rec xi_match_rec = fun list_j result->
    match list_j with
      [] -> result
    | manoeuvej::tail ->
        let no_conflit = no_conflict.(i).(j).(maneuveri).(manoeuvej) in
        if (no_conflit = true) then
          xi_match_rec tail (manoeuvej::result)
      else
          xi_match_rec tail result
  in
  c_maneuvers.(j) <- xi_match_rec c_maneuvers.(j) [];
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
  s
