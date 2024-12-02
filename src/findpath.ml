open Graph

let child_nodes (gr : 'a graph) (a: id) = List.map (fun x -> x.tgt) (out_arcs gr a)
  
let find_path (gr: 'a graph) (begin_node: id) (end_node: id) = 
  let rec find_way s acu =
    let s_child = child_nodes gr s in

    if s == end_node then
      acu
    else
      let next_rec = List.filter (fun x -> not (List.mem x acu)) s_child in
      let rec fp list =
        match list with
        | [] -> raise Not_found
        | x::rest -> 
          try
            find_way x (acu@[x])
          with 
          | Not_found -> fp rest
      in fp next_rec
  in 
    try
      find_way begin_node [begin_node]
    with
    | Not_found -> [];
