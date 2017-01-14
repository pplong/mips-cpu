ASM=~/codes/cpu/asm/asm.py

min-rt.bin: min-rt.s ../libmincaml.S
	cat min-rt.s ../libmincaml.S > __tmp.s
	python3 $(ASM) __tmp.s min-rt.bin
	rm __tmp.s

min-rt.s: min-rt.ml
	../min-caml -inline 100 min-rt


