open Graph
(* entrée 2 Listes : Liste1 [int id,String nom, int list [voeux1,voeux2,voeux3]] , Liste2 [int id,String voeux, int capacité] *)

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