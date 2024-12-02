open Graph

(* return the id nodes lists of the child of a node *)
val child_nodes: 'a graph -> id -> id list

(* search path between 2 node and return the path : a list of node *)
val find_path: 'a graph -> id -> id -> id list