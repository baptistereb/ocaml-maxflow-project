open Graph

  (* returns a new graph having the same nodes than gr, but no arc *)
val clone_nodes: 'a graph -> 'b graph
  
  (*  maps all arcs of gr by function f *)
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
  
  (* adds n to the value of the arc between id1 and id2. If the arc does not exist, it is created *)
val add_arc: int graph -> id -> id -> int -> int graph

 (* update_graph g l n : add n to all arcs in l. If an arc does not exist,it means that the arcs is in the otherside and the value is negative
 raise Not_found if the arc does not exist in the graph *)
val update_graph: int graph -> (id*id) list -> int -> int graph