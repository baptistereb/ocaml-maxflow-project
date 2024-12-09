open Gfile
open Tools
open Findpath
let rec mainloop graph p1 p2 fl=
  let id_list =path_to_list (find_path graph p1 p2 (fun arc -> arc.lbl > 0)) in
  match id_list with
  |[] -> (fl,graph) 
  |_ -> let min = take_min graph id_list max_int in
  let graph = update_graph graph id_list min in
  mainloop graph p1 p2 (fl+min)

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n" ^
         "    🟄  outfile2 : second output file.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  and outfile2 = Sys.argv.(5)
  
  (* These command-line arguments are not used for the moment. *)
  and source = int_of_string Sys.argv.(2)
  and sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in
  let () =export outfile2 graph in 
  (*let () = export outfile graph in *)
  let graph = gmap graph (fun x -> (int_of_string x)) in

  (*let id_list =path_to_list (find_path graph 0 5 (fun arc -> arc.lbl > 0)) in
  let min = take_min graph id_list max_int in
  let graph = update_graph graph id_list min in*)
  (*List.iter (fun x -> Printf.printf "%d " x) id_list; Printf.printf "\n\n%d " min*)
  let (fl,graph)= mainloop graph source sink 0 in
  let graph = gmap graph (fun x -> (string_of_int x)) in
  let () =export outfile graph in 
  Printf.printf "Le flot max = %d\n" fl ; ()