open Graph

let child_nodes (gr : 'a graph) (a: id) = List.map (fun x -> x.tgt) (out_arcs gr a)
  
let find_path (gr: 'a graph) (begin_node: id) (end_node: id) (filter: 'a arc -> bool)= 
  let rec find_way s acu =
    let s_child = child_nodes gr s in

    let arc x1 x2 = 
      match find_arc gr x1 x2 with
      | Some x -> x
      | None -> raise Not_found
    in

    if s == end_node then
      acu
    else
      let next_rec = List.filter (fun x -> not (List.mem x acu)) s_child in
      let rec fp list =
        match list with
        | [] -> raise Not_found
        | x::rest -> 
          try
            if (filter (arc s x)) then
              find_way x (acu@[x])
            else
              fp rest
          with 
          | Not_found -> fp rest
      in fp next_rec
  in 
    try
      find_way begin_node [begin_node]
    with
    | Not_found -> [];
