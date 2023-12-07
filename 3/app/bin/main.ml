let () = 
  let go_through_grid grid width height callback =
    for y = 0 to height - 1 do
      for x = 0 to width - 1 do
        callback x y grid.(x).(y)
      done;
    done in

  let get_in_grid grid width height x y =
    if x < 0 || x >= width || y < 0 || y >= height then
      ' '
    else
      grid.(x).(y) in

  let get_adjacent grid width height x y =
    let adjacent = ref [] in

    let add_adjacent x y =
      let c = get_in_grid grid width height x y in
      if c <> ' ' then
      adjacent := c :: !adjacent in

    add_adjacent (x - 1) y;
    add_adjacent (x + 1) y;
    add_adjacent x (y - 1);
    add_adjacent x (y + 1);

    add_adjacent (x - 1) (y - 1);
    add_adjacent (x + 1) (y - 1);
    add_adjacent (x - 1) (y + 1);
    add_adjacent (x + 1) (y + 1);

    !adjacent in

  let print_grid grid width height =
    go_through_grid grid width height (fun _x _y c ->
        print_char c;
        if _x = width - 1 then
          print_newline ()
      ) in

  let is_digit c =
    Char.code c >= Char.code '0' && Char.code c <= Char.code '9' in

  let is_symbol c =
    c <> '.' && not (is_digit c) in

  let reader = open_in "input.txt" in
  let text = In_channel.input_all reader in

  let width = String.split_on_char '\n' text |> List.hd |> String.length in
  let height = String.split_on_char '\n' text |> List.length |> fun x -> x - 1 in

  let grid = Array.make_matrix width height ' ' in

  let rec fill_grid x y =
    if x = width then
      fill_grid 0 (y + 1)
    else if y = height then
      ()
    else
      let c = String.get text (y * (width + 1) + x) in
      grid.(x).(y) <- c;
      fill_grid (x + 1) y in

  fill_grid 0 0;

  let numbers = ref [] in
  let current_number = ref "" in
  let current_number_x = ref 0 in
  let current_number_y = ref 0 in

  go_through_grid grid width height (fun x y c ->
      if !current_number_y <> y then
        begin
          if !current_number <> "" then
              numbers := (
                int_of_string !current_number, 
                !current_number_x - String.length(!current_number), 
                !current_number_y
              ) :: !numbers;

          current_number_y := y;
          current_number := ""
        end;

      if is_digit c then
        begin
          current_number := !current_number ^ (String.make 1 c);
          current_number_x := x
        end
      else if !current_number <> "" then
        begin
          numbers := (
            int_of_string !current_number, 
            x - String.length(!current_number), 
            y
          ) :: !numbers;
          current_number := ""
        end
    );
    
  (* print_grid grid width height; *)
  (* exit 0; *)

  let valid_numbers = !numbers
  (* |> List.rev *)
  |> List.filter (fun (number, x, y) -> 
      let length = String.length (string_of_int number) in
      let valid = ref false in

      for i = 0 to length - 1 do
        let adjacent = get_adjacent grid width height (x + i) y
        |> List.filter is_symbol in

        if List.length adjacent > 0 then
          valid := true
      done;

      print_endline (string_of_int number ^ " " ^ string_of_int x ^ " " ^ string_of_int y ^ " " ^ string_of_bool !valid);

      !valid 
      ) in

  let valid_numbers_sum = valid_numbers
  |> List.map (fun (number, _x, _y) -> number)
  |> List.fold_left (+) 0 in

  print_endline (string_of_int valid_numbers_sum);
