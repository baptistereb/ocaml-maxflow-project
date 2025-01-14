open Graph

let build_graph preferences capacities =
  let graph = empty_graph in
  let source_id = 0 in
  let sink_id = 1 in
  let graph = new_node graph source_id in
  let graph = new_node graph sink_id in
  (*add nodes*)
  let graph = List.fold_left (fun graph (student_id, _, _) -> new_node graph student_id) graph preferences in
  let graph = List.fold_left (fun graph (wish_id,_, _) -> new_node graph wish_id) graph capacities in
  (*arc between student and source + between wish and sink *)
  let graph = List.fold_left (fun graph (student_id, _, _) -> new_arc graph {src = source_id; tgt = student_id; lbl = 1}) graph preferences in
  let graph = List.fold_left (fun graph (wish_id, _, capacity) -> new_arc graph {src = wish_id; tgt = sink_id; lbl = capacity }) graph  capacities in
  (*arc between strudent and wishes*)
  let graph = List.fold_left (fun graph (student_id, _, wishes) ->
      List.fold_left (fun graph wish_id -> new_arc graph {src = student_id; tgt = wish_id; lbl = 1}) graph wishes
    ) graph preferences in
  graph


let results_to_list_peoples graphfinal preferences capacities = 
  let rec aux graphfinal preferences capacities = 
    (*Parcours la liste des gens et créé une liste d'association personne-sport*)
    match preferences with
    | [] -> []
    | (student_id, student_name, wishes)::rest -> 
      let wish_id = List.fold_left (fun acu wish_id -> 
          let arc = find_arc graphfinal student_id wish_id in
          match arc with
          | None -> acu
          | Some arc -> if arc.lbl = 1 then wish_id else acu
        ) (-1) wishes in
      let wish_name = List.fold_left (fun acu (id, name, _) -> if id = wish_id then name else acu) "Aucune affectation" capacities in
      (student_name, wish_name)::(aux graphfinal rest capacities)
  in aux graphfinal preferences capacities

let results_to_list_sport graphfinal preferences capacities = 
  let rec aux graphfinal preferences capacities = 
    (*Parcours la liste des sports et créé une liste d'association sport-[Liste personnes]*)
    match capacities with
    | [] -> []
    | (wish_id, wish_name, _)::rest -> 
      let students = List.fold_left (fun acu (student_id, student_name, _) -> 
          let arc = find_arc graphfinal student_id wish_id in
          match arc with
          | None -> acu
          | Some arc -> if arc.lbl = 1 then student_name::acu else acu
        ) [] preferences in
      (wish_name, students)::(aux graphfinal preferences rest)
  in

  let sports_results = aux graphfinal preferences capacities in

  (* Ajouter une catégorie "Not Found" pour les étudiants non affectés *)
  let not_found_students = List.fold_left (fun acu (student_id, student_name, wishes) ->
      let has_assignment = List.exists (fun wish_id ->
          match find_arc graphfinal student_id wish_id with
          | Some arc -> arc.lbl = 1
          | None -> false
        ) wishes in
      if not has_assignment then student_name::acu else acu
    ) [] preferences in

  if not_found_students = [] then
    sports_results
  else
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

