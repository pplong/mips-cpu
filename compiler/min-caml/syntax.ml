type t = (* MinCamlの構文を表現するデータ型 (caml2html: syntax_t) *)
  | Unit
  | Bool of bool
  | Int of int
  | Float of float
  | Not of t
  | Neg of t
  | Add of t * t
  | Sub of t * t
  | FNeg of t
  | FAdd of t * t
  | FSub of t * t
  | FMul of t * t
  | FDiv of t * t
  | Eq of t * t
  | LE of t * t
  | If of t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of t * t list
  | Tuple of t list
  | LetTuple of (Id.t * Type.t) list * t * t
  | Array of t * t
  | Get of t * t
  | Put of t * t * t
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let rec print indent s =
  print_string indent;
  let next_indent = "  " ^ indent in
  let print_onebody p e =
    print_string p; print_string "\n";
    print next_indent e;
  in
  let print_twobodies p e1 e2 =
    print_string p; print_string "(\n";
    print next_indent e1; print_string ",\n";
    print next_indent e2; print_string ")"
  in
  match s with
  | Unit -> print_string "UNIT"
  | Bool b -> print_string (if b then "TRUE" else "FALSE")
  | Int n -> print_string "INT("; print_int n; print_string ")"
  | Float f -> print_string "FLOAT("; print_float f; print_string ")"
  | Not e -> print_onebody "NOT" e
  | Neg e -> print_onebody "NEG" e
  | Add (e1, e2) -> print_twobodies "ADD" e1 e2
  | Sub (e1, e2) -> print_twobodies "SUB" e1 e2
  | FNeg e -> print_onebody "FNEG" e
  | FAdd (e1, e2) -> print_twobodies "FADD" e1 e2
  | FSub (e1, e2) -> print_twobodies "FSUB" e1 e2
  | FMul (e1, e2) -> print_twobodies "FMUL" e1 e2
  | FDiv (e1, e2) -> print_twobodies "FDIV" e1 e2
  | Eq (e1, e2) -> print_twobodies "EQ" e1 e2
  | LE (e1, e2) -> print_twobodies "LE" e1 e2
  | If (cond, th, el) ->
    print_string "IF\n";
    print next_indent cond;
    print_string ("\n" ^ indent ^ "THEN\n");
    print next_indent th;
    print_string ("\n" ^ indent ^ "ELSE\n");
    print next_indent el;
  | Let ((nm, ty), e1, e2) ->
    print_string ("LET " ^ (Id.to_string nm) ^ ":" ^ (Type.to_string ty) ^ " = \n");
    print next_indent e1;
    print_string ("\n" ^ indent ^ "IN\n");
    print indent e2
  | Var nm -> print_string ("VAR(" ^ (Id.to_string nm) ^ ")")
  | LetRec (f, e) ->
    let fname, ftype = f.name in
    print_string ("LETREC " ^ (Id.to_string fname) ^ ":" ^ (Type.to_string ftype) ^ "\n");
    print_string (indent ^ "ARGS: " ^ (String.concat ", " (List.map (fun (nm, ty) ->
      (Id.to_string nm) ^ "(" ^ (Type.to_string ty) ^ ")") f.args)) ^ "\n");
    print_string (indent ^ "BODY\n");
    print next_indent f.body;
    print_string ("\n" ^ indent ^ "IN\n");
    print indent e
  | App (f, args) ->
    print_string "APP\n";
    print next_indent f;
    print_string ("\n" ^ indent ^ "APP_ARGS [\n");
    List.iter (fun a -> print next_indent a; print_string ";\n") args;
    print_string (indent ^ "]")
  | Tuple es ->
    print_string "TUPLE(\n";
    List.iter (fun e -> print next_indent e; print_string ",\n") es;
    print_string (indent ^ ")")
  | LetTuple (vs, e1, e2) ->
    print_string "LETTUPLE (";
    print_string (String.concat ", " (List.map (fun (nm, ty) ->
      (Id.to_string nm) ^ ":" ^ (Type.to_string ty)) vs));
    print_string ") = \n";
    print next_indent e1;
    print_string ("\n" ^ indent ^ "IN\n");
    print indent e2
  | Array (enum, eelm) ->
    print_twobodies "ARRAY" enum eelm
  | Get (ary, idx) ->
    print_twobodies "ARY_GET" ary idx
  | Put (ary, idx, va) ->
    print_string "ARY_PUT\n";
    print next_indent ary;
    print_string " (\n";
    print next_indent idx;
    print_string ("\n" ^ indent ^ ") <- \n");
    print next_indent va
