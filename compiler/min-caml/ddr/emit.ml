open Asm

external getbits : float -> int32 = "getbits"

let stackset = ref S.empty (* すでにSaveされた変数の集合 (caml2html: emit_stackset) *)
let stackmap = ref [] (* Saveされた変数の、スタックにおける位置 (caml2html: emit_stackmap) *)
let save x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
let savef x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
let locate x =
  let rec loc = function
    | [] -> []
    | y :: zs when x = y -> 0 :: List.map succ (loc zs)
    | y :: zs -> List.map succ (loc zs) in
  loc !stackmap
let offset x = List.hd (locate x)
let stacksize () = (List.length !stackmap + 1)

let pp_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int i

(* 関数呼び出しのために引数を並べ替える(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys =
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
					 (function
					   | (y', z) when y = y' -> (sw, z)
					   | yz -> yz)
					 xys)
  | xys, acyc -> acyc @ shuffle sw xys

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp) -> g' oc (dest, exp)
  | dest, Let((x, t), exp, e) ->
      g' oc (NonTail(x), exp);
      g oc (dest, e)
and g' oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  | NonTail(_), Nop -> ()
  | NonTail(x), Li(i) -> Printf.fprintf oc "\tli\t%s, %d\n" x i
  | NonTail(x), LiL(Id.L(y)) -> Printf.fprintf oc "\tli\t%s, %s\n" x y
  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> Printf.fprintf oc "\tmove\t%s, %s\n" x y
  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tsub\t%s, r0, %s\n" x y
  | NonTail(x), Add(y, V(z)) -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" x y z
  | NonTail(x), Add(y, C(z)) -> Printf.fprintf oc "\taddi\t%s, %s, %d\n" x y z
  | NonTail(x), Sub(y, V(z)) -> Printf.fprintf oc "\tsub\t%s, %s, %s\n" x y z
  | NonTail(x), Sub(y, C(z)) -> Printf.fprintf oc "\taddi\t%s, %s, %d\n" x y (-z)
  | NonTail(x), SLL(y, V(z)) -> failwith "sll"
  | NonTail(x), SLL(y, C(z)) -> Printf.fprintf oc "\tsll\t%s, %s, %d\n" x y z
  | NonTail(x), Lw(y, V(z)) ->
      Printf.fprintf oc "\tadd\tr1, %s, %s\n" y z;
      Printf.fprintf oc "\tlw\t%s, r1, 0\n" x
  | NonTail(x), Lw(y, C(z)) -> Printf.fprintf oc "\tlw\t%s, %s, %d\n" x y z
  | NonTail(_), Sw(x, y, V(z)) ->
      Printf.fprintf oc "\tadd\tr1, %s, %s\n" y z;
      Printf.fprintf oc "\tsw\t%s, r1, 0\n" x
  | NonTail(_), Sw(x, y, C(z)) -> Printf.fprintf oc "\tsw\t%s, %s, %d\n" x y z
  | NonTail(x), FMovD(y) when x = y -> ()
  | NonTail(x), FMovD(y) ->
      Printf.fprintf oc "\tfmov\t%s, %s\n" x y;
  | NonTail(x), FNegD(y) ->
      Printf.fprintf oc "\tfneg\t%s, %s\n" x y;
  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfadd\t%s, %s, %s\n" x y z
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsub\t%s, %s, %s\n" x y z
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmul\t%s, %s, %s\n" x y z
  | NonTail(x), FDivD(y, z) -> 
      Printf.fprintf oc "\tfinv\tf31, %s\n" z;
      Printf.fprintf oc "\tfmul\t%s, %s, f31\n" x y
  | NonTail(x), Lwcl(y, V(z), false) ->
      Printf.fprintf oc "\tadd\tr1, %s, %s\n" y z;
      Printf.fprintf oc "\tlwcl\t%s, r1, 0\n" x
  | NonTail(x), Lwcl(y, C(z), false) -> Printf.fprintf oc "\tlwcl\t%s, %s, %d\n" x y z
  | NonTail(x), Lwcl(y, V(z), true) -> failwith "Lwcl"
  | NonTail(x), Lwcl(y, C(z), true) -> Printf.fprintf oc "\tlwclc\t%s, %s, %d\n" x y z
  | NonTail(_), Swcl(x, y, V(z)) ->
      Printf.fprintf oc "\tadd\tr1, %s, %s\n" y z;
      Printf.fprintf oc "\tswcl\t%s, r1, 0\n" x
  | NonTail(_), Swcl(x, y, C(z)) -> Printf.fprintf oc "\tswcl\t%s, %s, %d\n" x y z
  | NonTail(_), Comment(s) -> Printf.fprintf oc "\t! %s\n" s
  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) ->
      save y;
      Printf.fprintf oc "\tsw\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tswcl\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); ()
  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs ->
      Printf.fprintf oc "\tlw\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(x), Restore(y) ->
      assert (List.mem x allfregs);
      Printf.fprintf oc "\tlwcl\t%s, %s, %d\n" x reg_sp (offset y)
  (* 末尾だったら計算結果を第一レジスタにセットしてret (caml2html: emit_tailret) *)
  | Tail, (Nop | Sw _ | Swcl _ | Comment _ | Save _ as exp) ->
      g' oc (NonTail(Id.gentmp Type.Unit), exp);
      Printf.fprintf oc "\tjr %s\n" reg_ra
  | Tail, (Li _ | LiL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Lw _ as exp) ->
      g' oc (NonTail(regs.(0)), exp);
      Printf.fprintf oc "\tjr %s\n" reg_ra
  | Tail, (FMovD _ | FNegD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | Lwcl _  as exp) ->
      g' oc (NonTail(fregs.(0)), exp);
      Printf.fprintf oc "\tjr %s\n" reg_ra
  | Tail, (Restore(x) as exp) ->
      (match locate x with
      | [i] -> 
          if List.mem x allregs then g' oc (NonTail(regs.(0)), exp)
          else                       g' oc (NonTail(fregs.(0)), exp) 
      | _ -> assert false);
      Printf.fprintf oc "\tjr %s\n" reg_ra

  | Tail, IfEq(x, V(y), e1, e2) ->
      g'_tail_if oc e1 e2 "beq" "bne" x y
  | Tail, IfEq(x, C(y), e1, e2) ->
      Printf.fprintf oc "\tli\tr1, %d" y;
      g'_tail_if oc e1 e2 "beq" "bne" x "%r1"
  | NonTail(z), IfEq(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "beq" "bne" x y
  | NonTail(z), IfEq(x, C(y), e1, e2) ->
      Printf.fprintf oc "\tli\tr1, %d" y;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "beq" "bne" x "%r1"

  | Tail, IfLE(x, V(y), e1, e2) ->
      g'_tail_if oc e1 e2 "ble" "bgt" x y
  | Tail, IfLE(x, C(y), e1, e2) ->
      Printf.fprintf oc "\tli\tr1, %d" y;
      g'_tail_if oc e1 e2 "ble" "bgt" x "%r1"
  | NonTail(z), IfLE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "ble" "bgt" x y
  | NonTail(z), IfLE(x, C(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "ble" "bgt" x "%r1"

  | Tail, IfGE(x, V(y), e1, e2) ->
      g'_tail_if oc e1 e2 "bge" "blt" x y
  | Tail, IfGE(x, C(y), e1, e2) ->
      Printf.fprintf oc "\tli\tr1, %d" y;
      g'_tail_if oc e1 e2 "bge" "blt" x "%r1"
  | NonTail(z), IfGE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bge" "blt" x y
  | NonTail(z), IfGE(x, C(y), e1, e2) ->
      Printf.fprintf oc "\tli\tr1, %d" y;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bge" "blt" x "%r1"

  | Tail, IfFEq(x, y, e1, e2) ->
      g'_tail_if oc e1 e2 "fbeq" "fbne" x y
  | NonTail(z), IfFEq(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fbeq" "fbne" x y

  | Tail, IfFLE(x, y, e1, e2) ->
      g'_tail_if oc e1 e2 "fble" "fbgt" x y
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fble" "fbgt" x y

  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *)
      g'_args oc [(x, reg_cl)] ys zs;
      Printf.fprintf oc "\tlw\t%s, %s, 0\n" reg_sw reg_cl;
      Printf.fprintf oc "\tjr\t%s\n" reg_sw
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
      g'_args oc [] ys zs;
      Printf.fprintf oc "\tj\t%s\n" x
  | NonTail(a), CallCls(x, ys, zs) ->
      g'_args oc [(x, reg_cl)] ys zs;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s, %s, %d\n" reg_ra reg_sp (ss - 1);
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp ss;
      Printf.fprintf oc "\tlw\t%s, %s, 0\n" reg_sw reg_cl;
      let call = Id.genid "_call" in
      let called = Id.genid "_called" in
      Printf.fprintf oc "\tjal\t%s\n" call;
      Printf.fprintf oc "\tj\t%s\n" called;
      Printf.fprintf oc "%s:\n" call;
      Printf.fprintf oc "\tjr\t%s\n" reg_sw;
      Printf.fprintf oc "%s:\n" called;
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp (-ss);
      Printf.fprintf oc "\tlw\t%s, %s, %d\n" reg_ra reg_sp (ss - 1);
      if List.mem a allregs && a <> regs.(0) then
	Printf.fprintf oc "\tmove\t%s, %s\n" a regs.(0)
      else if List.mem a allfregs && a <> fregs.(0) then
	Printf.fprintf oc "\tfmov\t%s, %s\n" a fregs.(0)
  | NonTail(a), CallDir(Id.L(x), ys, zs) ->
      g'_args oc [] ys zs;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s, %s, %d\n" reg_ra reg_sp (ss - 1);
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp ss;
      Printf.fprintf oc "\tjal\t%s\n" x;
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp (-ss);
      Printf.fprintf oc "\tlw\t%s, %s, %d\n" reg_ra reg_sp (ss - 1);
      if List.mem a allregs && a <> regs.(0) then
  Printf.fprintf oc "\tmove\t%s, %s\n" a regs.(0)
      else if List.mem a allfregs && a <> fregs.(0) then
  Printf.fprintf oc "\tfmov\t%s, %s\n" a fregs.(0)
and g'_tail_if oc e1 e2 b bn r1 r2 =
  let b_else = Id.genid (b ^ "_else") in
  Printf.fprintf oc "\t%s\t%s, %s, %s\n" bn r1 r2 b_else;
  let stackset_back = !stackset in
  g oc (Tail, e1);
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (Tail, e2)
and g'_non_tail_if oc dest e1 e2 b bn r1 r2 =
  let b_else = Id.genid (b ^ "_else") in
  let b_cont = Id.genid (b ^ "_cont") in
  Printf.fprintf oc "\t%s\t%s, %s, %s\n" bn r1 r2 b_else;
  let stackset_back = !stackset in
  g oc (dest, e1);
  let stackset1 = !stackset in
  Printf.fprintf oc "\tj\t%s\n" b_cont;
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (dest, e2);
  Printf.fprintf oc "%s:\n" b_cont;
  let stackset2 = !stackset in
  stackset := S.inter stackset1 stackset2
and g'_args oc x_reg_cl ys zs =
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  List.iter
    (fun (y, r) -> Printf.fprintf oc "\tmove\t%s, %s\n" r y)
    (shuffle reg_sw yrs);
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Printf.fprintf oc "\tfmov\t%s, %s\n" fr z)
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  Printf.fprintf oc "\tli %s, 1\n" reg_hp;
  Printf.fprintf oc "\tsll %s, %s, 18\n" reg_hp reg_hp;
  Printf.fprintf oc "\taddi %s, %s, 8\n" reg_hp reg_hp;
  Printf.fprintf oc "\tlwc r13,r0,min_caml_print_int_0x00040000\n";
  Printf.fprintf oc "\tsw r0,r13,0\n";
  Printf.fprintf oc "\tsw r0,r13,1\n";
  Printf.fprintf oc "\tj min_caml_start\n";
  List.iter
    (fun (Id.L(x), d) ->
      Printf.fprintf oc "%s:\t# %f\n" x d;
      Printf.fprintf oc "\tdata\t0x%lx\n" (getbits d))
    data;
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc "min_caml_start:\n";
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("%r0"), e);
  Printf.fprintf oc "\tj __end\n"
