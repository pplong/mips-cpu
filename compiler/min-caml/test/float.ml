(* このテストを実行する場合は、Main.file等を呼び出す前に
   Typing.extenvを:=等で書き換えて、あらかじめsinやcosなど
   外部関数tの型を陽に指定する必要があります（そうしないと
   MinCamlでは勝手にint -> intと推論されるため）。 *)
print_int
  (int_of_float
     ((sin (cos (sqrt (fabs (-12.3))))
	 +. 4.5 -. 6.7 *. 8.9 /. 1.23456789)
	*. float_of_int 100))
