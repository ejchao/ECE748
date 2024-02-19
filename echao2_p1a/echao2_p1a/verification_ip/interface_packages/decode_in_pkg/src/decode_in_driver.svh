class decode_in_driver extends uvm_driver #(.REQ(decode_in_transaction), .RSP(decode_in_transaction));

    virtual decode_in_driver_bfm driver_bfm;
    decode_in_transaction req;
    decode_in_transaction rsp;  

    function new(string name="", uvm_component parent = null); 
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
     forever
        begin : forever_loop
          `uvm_info("DRIVER", "Requesting a transaction from the sequencer",UVM_MEDIUM)
          seq_item_port.get_next_item(req);
          `uvm_info("DRIVER", "Received a transaction from the sequencer",UVM_MEDIUM)
          `uvm_info("DRIVER", "Performing signal operations",UVM_MEDIUM)
          rsp = new("rsp");
          driver_bfm.initiate_and_get_response(req.npc_in, req.instr_dout, req.psr, req.enable_decode);
          rsp.set_id_info(req);
          `uvm_info("DRIVER", "Done performing signal operations",UVM_MEDIUM)
          `uvm_info("DRIVER", "Sending transaction back to sequence through sequencer",UVM_MEDIUM)
          seq_item_port.item_done(rsp);
        end 
    endtask

endclass