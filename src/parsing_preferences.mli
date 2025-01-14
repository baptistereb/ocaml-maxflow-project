(* fonction qui permet de parser les élément venant du fichier*)
val from_preferences_file: string ->  ((int * string * int list) list * (int * string * int) list)

(* fonction qui permet de print un choix *)
val debug_lire_choices: (int * string * int) list -> unit

(* fonction qui permet de print une personne et ses choix *)
val debug_lire_peoples: (int * string * int list) list -> unit
