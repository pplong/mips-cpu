let rec xor x y = if x then not y else y in
let x = xor true false in
let rec func x y = ext x y in
ext2 (func 0 1)
