#/bin/sh

CFLAGS=-I../fpu/fadd/FADD/
# FPUS=../fpu/fadd/FADD/fadd.c ../fpu/FMUL/fmul-c/fmul.c ../fpu/FINV/finv.c ../fpu/trig/fsin.c ../fpu/trig/fcos.c ../fpu/trig/fatan.c ../fpu/trig/kernel.c ../fpu/trig/reduction.c ../fpu/fsqrt/fsqrt.c
FPUS=fadd.c fmul.c finv.c ../fpu/trig/fsin.c ../fpu/trig/fcos.c ../fpu/trig/fatan.c ../fpu/trig/kernel.c ../fpu/trig/reduction.c ../fpu/fsqrt/fsqrt.c

all:
	gcc -O2 $(CFLAGS) $(FPUS) execline.c dassline.c sim.c -o sim
	gcc -O2 $(CFLAGS) $(FPUS) execline.c dassline.c fsim.c -o fsim
	gcc -O2 $(CFLAGS) $(FPUS) execline.c dassline.c asim.c -o asim
	gcc -O2 finvt.c -o finvt -lm
	./finvt

clean:
	rm sim
	rm fsim
	rm asim
