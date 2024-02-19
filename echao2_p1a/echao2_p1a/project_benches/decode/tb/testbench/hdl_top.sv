// hdl_top need not import the interface packages. 
// hdl_top instantiates the BFM's which are not in a package because static elements can't be in a package. 
// The only content from uvm_pkg that is necessary in hdl_top is the uvm_config_db so that it can be used to pass the virtual interface handle to the hvl side. 
// This can be imported using 'import uvm_pkg::uvm_config_db;

//import uvm_pkg::uvm_config_db;

import uvm_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
import decode_test_pkg::*;

module hdl_top();

    bit clk = 1'b0;
    initial forever #5ns clk = ~clk;

    bit rst = 1'b1; // active high reset
    initial #22ns rst = ~rst;

    decode_in_if if_inst(clk, rst);
    initial uvm_config_db#(virtual decode_in_if)::set(null, "*", "decode_in_if", if_inst);

    decode_in_monitor_bfm monitor_bfm(if_inst);
    initial uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, "*", "decode_in_monitor_bfm", monitor_bfm);
    
    decode_in_driver_bfm driver_bfm(if_inst);
    initial uvm_config_db#(virtual decode_in_driver_bfm)::set(null, "*", "decode_in_driver_bfm", driver_bfm);

endmodule
