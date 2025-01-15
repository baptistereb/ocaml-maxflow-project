open Graph
open Tools

(* prend la liste les fils de a dans le graphes : out_arcs prend les arcs sortants et le map permet de regarder le noeuf du noeud sortant *)
let child_nodes (gr : 'a graph) (a: id) = List.map (fun x -> x.tgt) (out_arcs gr a)

let find_path (gr: 'a graph) (begin_node: id) (end_node: id) (filter: 'a arc -> bool) = 
  let rec find_way s acu =
    let s_child = child_nodes gr s in

    let arc x1 x2 = 
      match find_arc gr x1 x2 with
      | Some x -> x
      | None -> raise Not_found
    in
    if s = end_node then
      acu
    else
      let next_nodes = List.filter (fun x -> not (List.mem x acu)) s_child in
      let rec explore_children = function
        | [] -> raise Not_found
        | x :: rest ->
          if filter (arc s x) then
            try
              find_way x (acu @ [x])
            with Not_found -> explore_children rest
          else
            explore_children rest
      in
      explore_children next_nodes
  in
  try
    find_way begin_node [begin_node]
  with
  | Not_found -> []

let path_to_list numbers =
  let rec build_pairs = function
    | x :: (y :: _ as rest) -> (x, y) :: build_pairs rest
    | _ -> []
  in
  build_pairs numbers

let rec construction_gap_solution graph p1 p2 fl =
  let id_list = path_to_list (find_path graph p1 p2 (fun arc -> arc.lbl > 0)) in
  match id_list with
  | [] -> (fl, graph)
  | _ ->
    let min = take_min graph id_list max_int in
    let graph = update_graph graph id_list min in
    construction_gap_solution graph p1 p2 (fl + min)

let construct_flow_solution graph_dep graph_end =
  let return_graph = clone_nodes graph_dep in
  let dep_arc = list_arc graph_dep in
  let rec iter_on_arc graph = function
    | [] -> graph
    | arc :: rest ->
      let rev_arc = find_arc graph_end arc.tgt arc.src in
      match rev_arc with
      | None -> iter_on_arc (add_arc graph arc.src arc.tgt 0) rest
      | Some x -> iter_on_arc (add_arc graph arc.src arc.tgt x.lbl) rest
  in
  iter_on_arc return_graph dep_arc
