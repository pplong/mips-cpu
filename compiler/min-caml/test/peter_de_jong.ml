let param_a = 1.4 in
let param_b = -2.3 in
let param_c = 2.4 in
let param_d = -2.1 in

let param_size = 512 in
let param_sizef = 512.0 in

let map =
  let dummy = Array.create 1 0 in
  Array.create param_size dummy
in

let rec prepare_map _ = 
  let rec prepare i =
    if i = param_size then
      ()
    else
      (map.(i) <- Array.create param_size 0;
      prepare (i + 1))
  in
  prepare 0
in

let next_arr = Array.create 2 0.0 in
let rec peter_de_jong_next x y =
  let xx = sin (param_a *. y) -. cos (param_b *. x) in
  let yy = sin (param_c *. x) -. cos (param_d *. y) in
  next_arr.(0) <- xx;
  next_arr.(1) <- yy
in

let rec int_of_coord x =
  int_of_float (floor ((x +. 2.0) /. 4.0 *. param_sizef))
in

let rec map_max r =
  if r = param_size then
    0
  else
    let rec map_max_row c =
      if c = param_size then
        0
      else
        let v = map.(r).(c) in
        let ma = map_max_row (c + 1) in
        if v > ma then v else ma
    in
    let v = map_max_row 0 in
    let ma = map_max (r + 1) in
    if v > ma then v else ma
in

(* let rec print_byte c = print_char (char_of_int c) in
let rec mul a b = a * b in
 *)
let rgb_arr = Array.create 3 0.0 in
let rec calc_rgb x y c maxc =
  let h = (float_of_int (x + y)) /. (param_sizef *. 2.0 -. 2.0) *. 2.0 in
  let h = if h >= 1.0 then h -. 1.0 else h in
  let pc = 1.0 -. (float_of_int c) /. (float_of_int maxc) in
  let pc = if pc < 0.0 then 0.0 else pc in
  let pc = pc *. pc in
  let pc = pc *. pc in
  let pc = 1.0 -. pc in
  let s = if pc < 0.5 then 1.0 else 1.0 -. (pc -. 0.5) *. 2.0 in
  let v = if pc < 0.5 then pc *. 2.0 else 1.0 in
  if s > 0.0 then
    let hh = h *. 6.0 in
    let i = int_of_float (floor hh) in
    let f = hh -. (floor hh) in
    let s1 = 1.0 -. s in
    let sf = 1.0 -. (s *. f) in
    let sf1 = 1.0 -. (s *. (1.0 -. f)) in
    if i = 0 then
      (rgb_arr.(0) <- v;
      rgb_arr.(1) <- v *. sf1;
      rgb_arr.(2) <- v *. s1)
    else if i = 1 then
      (rgb_arr.(0) <- v *. sf;
      rgb_arr.(1) <- v;
      rgb_arr.(2) <- v *. s1)
    else if i = 2 then
      (rgb_arr.(0) <- v *. s1;
      rgb_arr.(1) <- v;
      rgb_arr.(2) <- v *. sf1)
    else if i = 3 then
      (rgb_arr.(0) <- v *. s1;
      rgb_arr.(1) <- v *. sf;
      rgb_arr.(2) <- v)
    else if i = 4 then
      (rgb_arr.(0) <- v *. sf1;
      rgb_arr.(1) <- v *. s1;
      rgb_arr.(2) <- v)
    else
      (rgb_arr.(0) <- v;
      rgb_arr.(1) <- v *. s1;
      rgb_arr.(2) <- v *. sf)
  else
    (rgb_arr.(0) <- v; rgb_arr.(1) <- v; rgb_arr.(2) <- v)
in

let rec print_floatpixel f =
  let i = int_of_float (floor (f *. 255.0)) in
  let i =
    if i < 0 then 0 else if i > 255 then 255 else i
  in
  print_byte i
in

let rec peter_de_jong _ =
  (* Print PPM Image header. *)
  print_byte 80; (* 'P' *)
  print_byte (48 + 6); (* '6' *)
  print_byte 32; (* ' ' *)
  print_int param_size;
  print_byte 32;
  print_int param_size;
  print_byte 32;
  print_byte (48 + 2);
  print_byte (48 + 5);
  print_byte (48 + 5);
  print_byte 10; (* '\n' *)
  prepare_map ();
  let lim = mul 1000 1000 in
  let lim_m = 100 in
  let rec loop x y n =
    if n = lim then
      ()
    else
      (let ix = int_of_coord x in
      let iy = int_of_coord y in
      if map.(ix).(iy) < lim_m then
        map.(ix).(iy) <- map.(ix).(iy) + 1
      else ();
      peter_de_jong_next x y;
      loop (next_arr.(0)) (next_arr.(1)) (n + 1))
  in
  loop 0.0 0.0 0;
  let maxv = map_max 0 in
  let rec print_loop r =
    if r = param_size then
      ()
    else
      let rec print_loop_row c =
        if c = param_size then
          ()
        else
          let v = map.(c).(r) in
          (calc_rgb c r v maxv;
          print_floatpixel rgb_arr.(0);
          print_floatpixel rgb_arr.(1);
          print_floatpixel rgb_arr.(2);
          print_loop_row (c + 1))
      in
      (print_loop_row 0;
      print_loop (r + 1))
  in
  print_loop 0
in
peter_de_jong ()
