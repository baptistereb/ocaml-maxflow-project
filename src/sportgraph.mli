open Graph

(* entrée 2 Listes : Liste1 [int id,String nom, int list [voeux1,voeux2,voeux3]] , Liste2 [int id,String voeux, int capacité] *)
(* build graph from parsed data *)
val build_graph: (int * string * int list) list -> (int * string * int) list -> int graph

(*return the list of (people, affected wish)*)
val results_to_list_peoples: int graph -> (int * string * int list) list -> (int * string * int) list -> (string * string) list

(*print the list above*)
val debug_print_list_peoples: (string * string) list -> unit

(*return the list of (sport, list of people affected in)*)
val results_to_list_sport: int graph -> (int * string * int list) list -> (int * string * int) list -> (string * string list) list

(*print the list above*)
val debug_print_list_sport: (string * string list) list -> unit

(*export the lists into a txt*)
val export_all_to_txt: string -> (string * string) list -> (string * string list) list -> unit
