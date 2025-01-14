let from_preferences_file path =
  let infile = open_in path in

  (* Read all lines from the file *)
  let rec read_lines acc =
    try
      let line = input_line infile in
      read_lines (line :: acc)
    with End_of_file -> List.rev acc
  in

  let lines = read_lines [] in

  (* notre fichier d'entrée y'a les choix puis les gens et c'est séparé par une ligne vide donc faut différencier ces 2 parties du fichier *)
  let split_on_empty_line lines =
    let rec aux before after = function
      | [] -> (List.rev before, after) (* Retourne les deux parties une fois la liste terminée *)
      | "" :: rest -> (List.rev before, rest) (* Ligne vide trouvée, on sépare ici *)
      | line :: rest -> aux (line :: before) after rest
    in
    aux [] [] lines
  in

  let (choices, peoples) = split_on_empty_line lines in

  (* ici on construit la liste des choix*)
  let rec read_choices lines acu =
    let id = List.length acu + 2 in
    match lines with
    | [] -> List.rev acu
    | line :: rest ->
      (try
         Scanf.sscanf line "%s@;%d;" (fun name capacite -> let new_tuple = (id, name, capacite) in read_choices rest (new_tuple :: acu))
       with e ->
         Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line;
         failwith "from_file")
  in

  let choices_final_list = read_choices choices [] in

  let rec get_choices_id choices search =
    match choices with
    | [] -> 0
    | (id, name, _)::rest -> if (name=search) then id else (get_choices_id rest search)  
  in

  (* ici on construit la liste des candidats *)
  let rec read_peoples lines acu =
    let id = (List.length acu) + 2 + (List.length choices_final_list) in
    match lines with
    | [] -> List.rev acu
    | line :: rest ->
      (try
         let parts = String.split_on_char ';' line in
         match parts with
         | [] -> failwith "Empty line"
         | name :: rest_values ->
           let values_list = List.map (fun x -> get_choices_id choices_final_list x) rest_values in (* des 0 sont ajoutés si aucun choix n'est trouvé (pour pas raise d'erreur) *)
           let values_list_filtered = List.filter (fun x -> x>0) values_list in (* on retire les 0 si jamais on a pas de correspondance avec un choix cf ligne du dessus *)
           let new_tuple = (id, name, values_list_filtered) in
           read_peoples rest (new_tuple :: acu)
       with e ->
         Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line;
         failwith "from_file")
  
  in

  let people_final_list = read_peoples peoples [] in
  
  close_in infile;
  (people_final_list, choices_final_list) (* ce que retourne from_preferences_file *)






let rec debug_lire_choices choices = 
  match choices with
  | [] -> ()
  | a::rest -> (
    let (id, choices, capacity) = a in  
    let () = Printf.printf "choice = %d %s %d\n" id choices capacity in
    debug_lire_choices rest
  )

let rec debug_lire_peoples peoples = 
  match peoples with
  | [] -> ()
  | a::rest ->
    let (id, name, voeux) = a in
    let rec lire_voeux l acu =
      match l with
      | [] -> acu
      | a::rest -> (lire_voeux rest (acu^" "^(string_of_int a)))
    in let choices = (lire_voeux voeux "")
    in let () = Printf.printf "people = %d %s %s\n" id name choices
    in debug_lire_peoples rest