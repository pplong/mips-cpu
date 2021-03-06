let rec mandelbrot_at a b =
  let rec loop cnt x y =
    if cnt <= 0 then
      255
    else if (x *. x) +. (y *. y) >= 4.0 then
      0
    else
      loop (cnt - 1) ((x *. x) -. (y *. y) +. a) (2.0 *. x *. y +. b)
  in
  loop 200 0.0 0.0
in
let rec mandelbrot _ =
  print_byte 80; (* 'P' *)
  print_byte (48 + 6); (* '6' *)
  print_byte 32; (* ' ' *)
  print_byte (48 + 9);
  print_byte (48 + 6);
  print_byte 32;
  print_byte (48 + 6);
  print_byte (48 + 4);
  print_byte 32;
  print_byte (48 + 2);
  print_byte (48 + 5);
  print_byte (48 + 5);
  print_byte 10; (* '\n' *)
  let rec loop1 b =
    let rec loop2 a =
      if a >= 1.0 then
        ()
      else (
        let x = mandelbrot_at a b in
        print_byte x;
        print_byte x;
        print_byte x;
        loop2 (a +. 0.03125)
      )
    in
    if b >= 1.0 then
      ()
    else (
      loop2 (-2.0);
      loop1 (b +. 0.03125)
    )
  in
  loop1 (-1.0)
in
mandelbrot ()
