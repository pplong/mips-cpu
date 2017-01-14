#!/bin/zsh
~/codes/cpu/compiler/min-caml/min-caml -inline 10 $1
cat $1.s ~/codes/cpu/compiler/min-caml/libmincaml.S > __tmp.s
python3 ~/codes/cpu/asm/asm.py __tmp.s $1.bin
rm __tmp.s
