let () = 
  let reader = open_in "../input.txt" in
  let lines = In_channel.input_all reader in
  let lines = String.split_on_char '\n' lines in
  let lines = List.filter (fun x -> x <> "") lines in
  let numbers = List.map (fun x -> 
    let ints = x 
    |> String.to_seq 
    |> List.of_seq 
    |> List.map (fun x -> Char.escaped x) 
    |> List.map int_of_string_opt
    |> List.filter (fun x -> x <> None)
    |> List.map Option.get
    |> List.map string_of_int in

    let first = List.hd ints in
    let last = List.nth ints ((List.length ints) - 1) in

    first ^ last
  ) lines in

  let sum = List.fold_left (fun acc x -> acc + int_of_string x) 0 numbers in
  print_endline (string_of_int sum)
