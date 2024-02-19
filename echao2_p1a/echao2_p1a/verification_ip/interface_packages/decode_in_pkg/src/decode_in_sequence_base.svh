class decode_in_sequence_base extends uvm_sequence#(.REQ(decode_in_transaction), .RSP(decode_in_transaction));

    decode_in_transaction req;
    decode_in_transaction rsp;

    function new(string name=""); 
        super.new(name);
    endfunction

    /*virtual task body();
      req = new("req");
      `uvm_info("SEQUENCE", "Requesting to send transaction to driver",UVM_MEDIUM)
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "my_sequence::body()- randomization failed")
      `uvm_info("SEQUENCE", {"Sending transaction to Driver:",req.convert2string()},UVM_MEDIUM)
      finish_item(req);
      get_response(rsp);
      `uvm_info("SEQUENCE", {"Received transaction from Driver:",rsp.convert2string()},UVM_MEDIUM)
    endtask*/

endclass