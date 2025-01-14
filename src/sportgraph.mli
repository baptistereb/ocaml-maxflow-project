open Graph

(* entrée 2 Listes : Liste1 [int id,String nom, int list [voeux1,voeux2,voeux3]] , Liste2 [int id,String voeux, int capacité] *)
(* build graph from parsed data *)
val build_graph: (int * string * int list) list -> (int * string * int) list -> int graph
