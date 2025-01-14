open Gfile
open Tools
open Findpath
open Sportgraph
open Parsing_preferences

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        (
          "    🟄  infile  : input file containing a list of choices and applicants\n" ^
          "    🟄  outfile : output file in which there is the result of the algorithm.\n" ^
          "    🟄  begin_graph \n" ^
          "    🟄  final_graph \n\n"
        ) ;
      exit 0
    end ;

  let start_time = Unix.gettimeofday () in
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(2)
  and begin_graph = Sys.argv.(3)
  and final_graph = Sys.argv.(4)
  in let (preferences,capacities) = from_preferences_file infile in 
  (* let ()= debug_lire_choices capacities in
     let ()= debug_lire_peoples preferences in *)
  let graph = build_graph preferences capacities in
  let sgraph = gmap graph (fun x -> (string_of_int x)) in
  let () = export begin_graph sgraph in
  let (fl2,fgraph)= construction_gap_solution graph 0 1 0 in
  let graph = construct_flow_solution graph fgraph in
  let list_peoples = results_to_list_peoples graph preferences capacities in
  let list_sport = results_to_list_sport graph preferences capacities in
  let graph = gmap graph (fun x -> (string_of_int x)) in
  let () = export_all_to_txt outfile list_peoples list_sport in
  let () = export final_graph graph in
  let () = Printf.printf "Le flot max = %d\n" fl2 in
  let end_time = Unix.gettimeofday () in
  let delta_time = end_time -. start_time in
  Printf.printf "Temps d'execution du programme = %.4f secondes\n" delta_time ; ()