(* fonction qui permet de parser les élément venant du fichier*)
val from_preferences_file: string ->  ((int * string * int list) list * (int * string * int) list)
