// basically subscriber, count # of transactions

class decode_in_coverage extends uvm_subscriber #(decode_in_transaction);
    `uvm_component_utils(decode_in_coverage)

    // transaction object
    T trans;

    // count # of transactions = 25
    int counter;

    // Covergroup(s) for coverage of ISA
    covergroup trans_cg;
        npc_in : coverpoint trans.npc_in;
        instr_dout : coverpoint trans.instr_dout {
            wildcard bins add_reg = {16'b0001_???_???_0_0_0_???};
            wildcard bins add_imm = {16'b0001_???_???_1_?????};
            wildcard bins and_reg = {16'b0101_???_???_0_0_0_???};
            wildcard bins and_imm = {16'b0101_???_???_1_?????};
            wildcard bins not_bin = {16'b1001_???_???_111111};
            wildcard bins  ld_bin = {16'b0010_???_?????????};
            wildcard bins ldr_bin = {16'b0110_???_???_??????};
            wildcard bins ldi_bin = {16'b1010_???_?????????};
            wildcard bins lea_bin = {16'b1110_???_?????????};
            wildcard bins  st_bin = {16'b0011_???_?????????};
            wildcard bins str_bin = {16'b0111_???_???_??????};
            wildcard bins sti_bin = {16'b1011_???_?????????};
            wildcard bins  br_bin = {16'b0000_???_?????????};
            wildcard bins jmp_bin = {16'b1100_000_???_000000};
        }
        psr : coverpoint trans.psr;
        enable_decode : coverpoint trans.enable_decode;
    endgroup 

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
        trans_cg = new;
        counter = 0;
    endfunction  

    virtual function void write(T t);
       `uvm_info("COVERAGE", {"Transaction received: ", t.convert2string()}, UVM_MEDIUM)
       counter += 1;
       `uvm_info("COVERAGE", $sformatf("Number of transactions received: %d", counter), UVM_MEDIUM)

       trans = new;
       trans.npc_in = t.npc_in;
       trans.instr_dout = t.instr_dout;
       trans.psr = t.psr;
       trans.enable_decode = t.enable_decode;
       trans_cg.sample();
    endfunction 

endclass