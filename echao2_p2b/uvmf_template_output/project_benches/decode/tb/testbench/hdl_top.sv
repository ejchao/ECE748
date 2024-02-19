// hdl_top need not import the interface packages. 
// hdl_top instantiates the BFM's which are not in a package because static elements can't be in a package. 
// The only content from uvm_pkg that is necessary in hdl_top is the uvm_config_db so that it can be used to pass the virtual interface handle to the hvl side. 
// This can be imported using 'import uvm_pkg::uvm_config_db;

//import uvm_pkg::uvm_config_db;

import uvmf_base_pkg::*;
import uvmf_base_pkg_hdl::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
import decode_out_pkg::*;
import decode_test_pkg::*;

module hdl_top();

    bit clk = 1'b0;
    initial forever #5ns clk = ~clk;

    bit rst = 1'b1; // active high reset
    initial #22ns rst = ~rst;

    // port signals
    tri        enable_decode;
    tri [15:0] dout;
    tri [15:0] npc_in;
    tri [15:0] IR;
    tri [15:0] npc_out;
    tri [5:0]  E_Control;
    tri [1:0]  W_Control;
    tri        Mem_Control;

    Decode DUT (
        .clock(clk),
        .reset(rst),
        .enable_decode(enable_decode),
        .dout(dout),
        .npc_in(npc_in),
        .IR(IR),
        .npc_out(npc_out),
        .E_Control(E_Control),
        .W_Control(W_Control),
        .Mem_Control(Mem_Control)
    );

    // decode_in

    decode_in_if d_in_if(clk, rst, enable_decode, dout, npc_in);
    initial uvm_config_db#(virtual decode_in_if)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in", d_in_if);

    decode_in_monitor_bfm d_in_monitor_bfm(d_in_if);
    initial uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in", d_in_monitor_bfm);
    
    decode_in_driver_bfm d_in_driver_bfm(d_in_if);
    initial uvm_config_db#(virtual decode_in_driver_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in", d_in_driver_bfm);

    // decode_out

    decode_out_if d_out_if(clk, rst, IR, npc_out, E_Control, W_Control, Mem_Control);
    initial uvm_config_db#(virtual decode_out_if)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out", d_out_if);

    decode_out_monitor_bfm d_out_monitor_bfm(d_out_if);
    initial uvm_config_db#(virtual decode_out_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out", d_out_monitor_bfm);
    
    decode_out_driver_bfm d_out_driver_bfm(d_out_if);
    initial uvm_config_db#(virtual decode_out_driver_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out", d_out_driver_bfm);

endmodule
