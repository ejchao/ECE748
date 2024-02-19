// decode in interface (signal bundle)

interface decode_in_if(clk, rst);

    input wire clk;
    input wire rst;
    
    // LC3 design spec document
    bit        clock, reset;
    bit [15:0] instr_dout, npc_in;
    bit [2:0]  psr;
    bit        enable_decode;

    assign clock = clk;
    assign reset = rst;

endinterface
