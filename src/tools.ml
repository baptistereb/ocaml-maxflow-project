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


  (* Tools to do :
  - Update graph :  take a list and a value -> add this value to all arc in the list
  we must do a find_arc and if it doesn't find we try to do the arc in the other side with the value in negative
    -Find path : find a patch and return a list of arc and a value : the max of increase *)