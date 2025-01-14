open Graph

let build_graph peoples services =
  let graph = empty_graph in
  let source_id = 0 in
  let sink_id = 1 in
  let graph = new_node graph source_id in
  let graph = new_node graph sink_id in
  (*add nodes*)
  let graph = List.fold_left (fun graph (student_id, _, _) -> new_node graph student_id) graph peoples in
  let graph = List.fold_left (fun graph (wish_id,_, _) -> new_node graph wish_id) graph services in
  (*arc between student and source + between wish and sink *)
  let graph = List.fold_left (fun graph (student_id, _, _) -> new_arc graph {src = source_id; tgt = student_id; lbl = 1}) graph peoples in
  let graph = List.fold_left (fun graph (wish_id, _, capacity) -> new_arc graph {src = wish_id; tgt = sink_id; lbl = capacity }) graph  services in
  (*arc between strudent and wishes*)
  let graph = List.fold_left (fun graph (student_id, _, wishes) ->
      List.fold_left (fun graph wish_id -> new_arc graph {src = student_id; tgt = wish_id; lbl = 1}) graph wishes
    ) graph peoples in
  graph


let results_to_list_peoples graphfinal peoples services = 
  let rec aux graphfinal peoples services = 
    (*Parcours la liste des gens et créé une liste d'association personne-sport*)
    match peoples with
    | [] -> []
    | (student_id, student_name, wishes)::rest -> 
      let wish_id = List.fold_left (fun acu wish_id -> 
          let arc = find_arc graphfinal student_id wish_id in
          match arc with
          | None -> acu
          | Some arc -> if arc.lbl = 1 then wish_id else acu
        ) (-1) wishes in
      let wish_name = List.fold_left (fun acu (id, name, _) -> if id = wish_id then name else acu) "Aucune affectation" services in
      (student_name, wish_name)::(aux graphfinal rest services)
  in aux graphfinal peoples services

let results_to_list_sport graphfinal peoples services = 
  let rec aux graphfinal peoples services = 
    (* Parcours la liste des sports et créé une liste d'association sport-[Liste personnes] *)
    match services with
    | [] -> []
    | (wish_id, wish_name, _) :: rest -> 
      let students = List.fold_left (fun acu (student_id, student_name, _) -> 
          let arc = find_arc graphfinal student_id wish_id in
          match arc with
          | None -> acu
          | Some arc -> if arc.lbl = 1 then student_name :: acu else acu
        ) [] peoples in
      (wish_name, students) :: (aux graphfinal peoples rest)
  in

  let sports_results = aux graphfinal peoples services in

  let assigned_students = List.fold_left (fun acu (_, students) -> acu @ students) [] sports_results in

  let not_found_students = List.fold_left (fun acu (_, student_name, _) ->
      if List.mem student_name assigned_students then acu
      else student_name :: acu
    ) [] peoples in

  (* Retourne la liste des sports avec la catégorie "Aucune Affectation" ajoutée *)
  ("Aucune Affectation", not_found_students) :: sports_results



let debug_print_list_peoples l = 
  Printf.printf "Liste des résultats :\n";
  List.iter (fun (name, wish) -> Printf.printf "La personne %s est affecté au voeux %s\n" name wish) l

let debug_print_list_sport l =
  Printf.printf "Liste des résultats :\n";
  List.iter (fun (wish, students) -> Printf.printf "Le voeux %s est affecté aux personnes %s\n" wish (String.concat ", " students)) l

let export_all_to_txt path list_peoples list_sports = 
  let ff = open_out path in
  List.iter (fun (name, wish) -> Printf.fprintf ff "%s est affecté au voeux %s\n" name wish) list_peoples;
  Printf.fprintf ff "\n\n";
  List.iter (fun (wish, students) -> 
      Printf.fprintf ff "##################################\n";
      Printf.fprintf ff "#####   %s\n" wish;
      Printf.fprintf ff "- %s\n" (String.concat "\n- " students);
      Printf.fprintf ff "##################################\n\n";
    ) list_sports;

  close_out ff

