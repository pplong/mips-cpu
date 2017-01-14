type t = (* MinCamlの型を表現するデータ型 (caml2html: type_t) *)
  | Unit
  | Bool
  | Int
  | Float
  | Fun of t list * t (* arguments are uncurried *)
  | Tuple of t list
  | Array of t
  | Var of t option ref

let gentyp () = Var(ref None) (* 新しい型変数を作る *)

let rec to_string = function
  | Unit -> "unit"
  | Bool -> "bool"
  | Int -> "int"
  | Float -> "float"
  | Fun (args, ret) ->
    let args_t = String.concat ", " (List.map to_string args) in
    let ret_t = to_string ret in
    "fun[(" ^ args_t ^ ") -> " ^ ret_t ^ "]"
  | Tuple ts ->
    let ts_t = String.concat ", " (List.map to_string ts) in
    "tuple(" ^ ts_t ^ ")"
  | Array t -> "array(" ^ (to_string t) ^ ")"
  | Var tt -> begin match !tt with
      | None -> "[typevar]"
      | Some t -> "[var:" ^ (to_string t) ^ "]"
    end
