class decode_in_transaction extends uvm_sequence_item;

    // instructions
    parameter [3:0] ADD = 4'b0001,
                    AND = 4'b0101,
                    NOT = 4'b1001,
                    LD  = 4'b0010,
                    LDR = 4'b0110,
                    LDI = 4'b1010,
                    LEA = 4'b1110,
                    ST  = 4'b0011,
                    STR = 4'b0111,
                    STI = 4'b1011,
                    BR  = 4'b0000,
                    JMP = 4'b1100;

    // random transactions: instr_dout
    rand bit [3:0] instr; 
    rand bit [2:0] dr; 
    rand bit [2:0] sr1;
    rand bit [2:0] sr2;
    rand bit       im;
    rand bit [4:0] imm5;
    rand bit [2:0] baser;
    rand bit [5:0] pcoffset6;
    rand bit [8:0] pcoffset9;
    rand bit [2:0] nzp;

    // decode inputs
    rand bit [15:0] npc_in;
    bit      [15:0] instr_dout;
    rand bit [2:0]  psr;
    rand bit        enable_decode;
    time            start_time;
    time            end_time;

    // add to wave
    int transaction_view_h;
    
    // randomization constraints
    constraint trans_val{
        npc_in >= 3000; // starts counting up at 3000
        psr > 3'b000;
        nzp > 3'b000; // valid at all 3 bits except 000
    };

    constraint instr_val{
        instr inside {ADD, AND, NOT, LD, LDR, LDI, LEA, ST, STR, STI, BR, JMP};
    };

    // construct instr_dout
    function void post_randomize();
        case(instr)
            ADD: begin
                if (im) instr_dout = {instr, dr, sr1, 1'b1, imm5};
                else    instr_dout = {instr, dr, sr1, 3'b000, sr2};
            end
            AND: begin
                if (im) instr_dout = {instr, dr, sr1, 1'b1, imm5};
                else    instr_dout = {instr, dr, sr1, 3'b000, sr2};
            end
            NOT: begin
                        instr_dout = {instr, dr, sr1, 6'b111111};
            end
            LD: begin
                        instr_dout = {instr, dr, pcoffset9};
            end
            LDR: begin
                        instr_dout = {instr, dr, baser, pcoffset6};
            end
            LDI: begin
                        instr_dout = {instr, dr, pcoffset9};
            end
            LEA: begin
                        instr_dout = {instr, dr, pcoffset9};
            end
            ST: begin
                        instr_dout = {instr, sr1, pcoffset9};
            end
            STR: begin
                        instr_dout = {instr, sr1, baser, pcoffset6};
            end
            STI: begin
                        instr_dout = {instr, sr1, pcoffset9};
            end
            BR: begin
                        instr_dout = {instr, nzp, pcoffset9};
            end
            JMP: begin
                        instr_dout = {instr, 3'b000, baser, 6'b000000};
            end
            default: begin
                `uvm_fatal("TRANSACTION", "Invalid instruction type")
            end
        endcase
    endfunction

    function new(string name = "");
        super.new(name);
    endfunction

    // Convert2string method in transaction and configuration classes
    virtual function string convert2string();
        return $sformatf("npc_in: 0x%x, instr_dout: 0x%b, psr: 0x%b, enable_decode: 0x%b", npc_in, instr_dout, psr, enable_decode);
    endfunction

    // Transaction viewing in the wave window
    virtual function void add_to_wave(int transaction_viewing_stream_h);
        transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"Transaction",start_time);
        $add_attribute( transaction_view_h, npc_in, "npc_in" );
        $add_attribute( transaction_view_h, instr_dout, "instr_dout" );
        $add_attribute( transaction_view_h, psr, "psr" );
        $add_attribute( transaction_view_h, enable_decode, "enable_decode" );
        $end_transaction(transaction_view_h,end_time);
        $free_transaction(transaction_view_h);
    endfunction

endclass