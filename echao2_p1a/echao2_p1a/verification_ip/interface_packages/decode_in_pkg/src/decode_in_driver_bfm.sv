import decode_in_pkg::*;

interface decode_in_driver_bfm(decode_in_if bus);

    task initiate_and_get_response( input bit [15:0] npc_in, 
                                    input bit [15:0] instr_dout, 
                                    input bit [2:0] psr, 
                                    input bit enable_decode );
        @(posedge bus.clock);
        bus.npc_in = npc_in;
        bus.instr_dout = instr_dout;
        bus.psr = psr;
        bus.enable_decode = enable_decode;
    endtask

endinterface