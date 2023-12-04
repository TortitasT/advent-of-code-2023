let () = 
  let reader = open_in "../input.txt" in
  let lines = In_channel.input_all reader in
  let lines = String.split_on_char '\n' lines in
  let lines = List.filter (fun x -> x <> "") lines in
  List.iter (fun x -> 
    x ^ " " ^ (String.length x |> string_of_int) |> print_endline
  ) lines
