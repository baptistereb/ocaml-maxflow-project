open Graph

(* return the id nodes lists of the child of a node *)
val child_nodes: 'a graph -> id -> id list

(* search path between 2 node and return the path : a list of node *)
val find_path: 'a graph -> id -> id -> ('a arc -> bool) -> id list

(* for example take [1;0;2;4] into [(1,0);(0,2);(2,4)]*)
val path_to_list: int list -> (id * id) list

(* compute the final gap graph *)
val construction_gap_solution : int graph -> id -> id -> int -> (int*int graph)

(* compute the final flow graph  *)
val construct_flow_solution : int graph -> int graph -> int graph