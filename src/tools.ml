open Graph

(* returns a new graph having the same nodes than gr, but no arc *)
let clone_nodes gr = n_fold gr new_node empty_graph

(*  maps all arcs of gr by function f *)
let gmap gr f = e_fold gr (fun gr arc -> new_arc gr {arc with lbl = f arc.lbl}) (clone_nodes gr)

(* adds n to the value of the arc between id1 and id2. If the arc does not exist, it is created *)
let add_arc g id1 id2 n= 
  match find_arc g id1 id2 with
  | Some arc -> let new_lbl = arc.lbl + n in new_arc g {arc with lbl = new_lbl} 
  | None -> let arc = {src = id1; tgt = id2; lbl = n} in new_arc g arc

 (* update_graph g l n : update the gap graph *)
let update_graph graph list value = 
  let rec aux graph list value = 
    match list with
    | [] -> graph
    | (id1, id2)::rest -> 
      let graph = match find_arc graph id1 id2 with
        | None -> raise Not_found
        | Some _ -> let graph = add_arc graph id1 id2 (-value) in
                    add_arc graph id2 id1 value
      in aux graph rest value
  in aux graph list value
