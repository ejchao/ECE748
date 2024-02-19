# Makefile for use with ECE748 Project 1A
#
comp_decode_in_pkg:
	vlog -sv +incdir+../../../verification_ip/interface_packages/decode_in_pkg \
../../../verification_ip/interface_packages/decode_in_pkg/decode_in_pkg.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_if.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_driver_bfm.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_monitor_bfm.sv 

comp_decode_test_pkg:
	vlog -sv +incdir+../tb/tests ../tb/tests/decode_test_pkg/decode_test_pkg.sv

comp_test_bench:
	vlog -sv ../tb/testbench/hdl_top.sv ../tb/testbench/hvl_top.sv 

comp_opt:
	vopt hdl_top hvl_top -o hvl_top_opt +designfile=design.bin -debug,livesim

clean:
	rm -rf work
	rm -rf *.xml
	rm -rf *.ucdb
	rm design.bin
	rm qwave.db
	rm *.log

p1_debug:comp_decode_in_pkg comp_decode_test_pkg comp_test_bench comp_opt
	     vsim hvl_top_opt -sv_seed 1 +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH +notimingchecks -suppress 8887 -visualizer=design.bin -qwavedb=+signal+memory+class+transaction -classdebug -uvmcontrol=all -do "set NoQuitOnFinish 1;onbreak {resume}; run -all; do wave.do; coverage save test_top.ucdb;"  

