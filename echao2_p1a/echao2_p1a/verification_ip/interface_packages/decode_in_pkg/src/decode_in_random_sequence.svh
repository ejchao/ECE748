class decode_in_random_sequence extends decode_in_sequence_base;

    function new(string name = "");
      super.new(name);
    endfunction

    virtual task body();
      req = new("req");
      `uvm_info("SEQUENCE", "Requesting to send transaction to driver",UVM_MEDIUM)
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "decode_in_sequence::body()- randomization failed") begin
      `uvm_info("SEQUENCE", {"Sending transaction to Driver: ",req.convert2string()},UVM_MEDIUM)
      end
      finish_item(req);
      get_response(rsp);
      //`uvm_info("SEQUENCE", {"Received transaction from Driver: ",rsp.convert2string()},UVM_MEDIUM)
      $display("\n\n"); // to separate transactions
    endtask

endclass