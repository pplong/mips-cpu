TESTBENCH = top_tb
OBJECTS = types.o alu.o alu_control.o block_ram.o decode.o pc.o regs.o fregs.o \
				  rs232c/rs232c_read.o rs232c/rs232c_write.o sim/sram.o top.o top_tb.o

GHDLC = ghdl
GHDLFLAGS = -fexplicit --ieee=synopsys
GHDL_SIM_OPT = --stop-time=1us --ieee-asserts=disable

.PHONY: clean
all: $(TESTBENCH)

$(OBJECTS): %.o: %.vhd
	$(GHDLC) -a $(GHDLFLAGS) $^

$(TESTBENCH): $(OBJECTS)
	$(GHDLC) -e $(GHDLFLAGS) $@
	$(GHDLC) -r $(GHDLFLAGS) $@ $(GHDL_SIM_OPT) --vcd=$@.vcd

clean:
	$(GHDLC) --clean
	rm *.vcd work-obj93.cf
