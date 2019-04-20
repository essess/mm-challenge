# sources

SRC_DIR = ..
SRC = \
	$(SRC_DIR)/div.vhd\
	$(SRC_DIR)/sdb.vhd\
	$(SRC_DIR)/pd.vhd\
	$(SRC_DIR)/mm.vhd



# testbench sources

TB_TOPMOD ?= mm_tb
TB_DIR = ../tb
TB_SRC = \
	$(TB_DIR)/div_tb.vhd\
	$(TB_DIR)/sdb_tb.vhd\
	$(TB_DIR)/pd_tb.vhd\
	$(TB_DIR)/mm_tb.vhd

GHDL_FLAGS=--std=08 -v --warn-error -fcaret-diagnostics

WAVE_VCD ?= wave.vcd

.DEFAULT_GOAL := help

help:
	@echo "to run a testbench,"
	@echo "   make gui TB_TOPMOD=<<testbench entity>>            # runs testbench and generates waveforms for gtkwave"
	@echo "   make run TB_TOPMOD=<<testbench entity>>            # runs testbench"
	@echo " or,"
	@echo "   make wave.vcd TB_TOPMOD=<<testbench entity>>       # .. and do quick reloads in gtkwave"
	@echo
	@echo "if TB_TOPMOD is not specified, the entity 'tb' is assumed"
	@echo "if WAVE_VCD is not specified, 'wave.vcd' is assumed"
	@echo
	@echo "don't forget,"
	@echo "   make clean"

.PHONY: run compile gui clean help

.PRECIOUS: $(WAVE_VCD)

run: compile
	ghdl --elab-run $(GHDL_FLAGS) $(TB_TOPMOD)

$(WAVE_VCD): compile
	ghdl --elab-run $(GHDL_FLAGS) $(TB_TOPMOD) --vcd=$(WAVE_VCD)

gui: $(WAVE_VCD)
	gtkwave $(WAVE_VCD)

compile: $(SRC) $(TB_SRC)
	ghdl -a $(GHDL_FLAGS) $(SRC) $(TB_SRC)

clean:
	rm -f *.cf
	rm -f $(WAVE_VCD)
	rm -f *.o
	rm -f $(TB_TOPMOD)