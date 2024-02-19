import decode_in_pkg::*;

interface decode_in_monitor_bfm(decode_in_if bus);

    // monitor handle
    decode_in_monitor proxy;

    initial begin
        while(bus.reset == 1'b1);
        repeat(7) @(posedge bus.clock); // guess and check
        forever begin
            bit [15:0] npc_in_bfm;
            bit [15:0] instr_dout_bfm;
            bit [2:0]  psr_bfm;
            bit        enable_decode_bfm;
            @(posedge bus.clock);
            do_monitor(
                npc_in_bfm,
                instr_dout_bfm,
                psr_bfm,
                enable_decode_bfm
            );
            proxy.notify_transaction(
                npc_in_bfm,
                instr_dout_bfm,
                psr_bfm,
                enable_decode_bfm
            );
        end
    end

    task do_monitor(output bit [15:0] npc_in, 
                    output bit [15:0] instr_dout, 
                    output bit [2:0] psr, 
                    output bit enable_decode);
                    
        npc_in = bus.npc_in;
        instr_dout = bus.instr_dout;
        psr = bus.psr;
        enable_decode = bus.enable_decode;
    endtask
    
endinterface