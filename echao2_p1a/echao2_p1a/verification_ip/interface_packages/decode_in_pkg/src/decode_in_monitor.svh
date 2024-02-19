class decode_in_monitor extends uvm_monitor;
    `uvm_component_utils(decode_in_monitor)

    uvm_analysis_port #(decode_in_transaction) analysis_port;
    decode_in_transaction trans;
    decode_in_configuration configuration;

    // monitor_bfm
    virtual decode_in_monitor_bfm monitor_bfm;

    // Convenience variable for storing timestamps
    protected time time_stamp = 0;

    // Handle used for transaction viewing
    int transaction_viewing_stream;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      analysis_port = new("analysis_port", this);
      if(!uvm_config_db #(decode_in_configuration)::get(null, "*", "decode_in_configuration", configuration)) begin
        `uvm_fatal("FATAL MSG", "Configuration object is not set properly")
      end
    endfunction

    function void notify_transaction(input bit [15:0] npc_in, 
                                     input bit [15:0] instr_dout, 
                                     input bit [2:0] psr, 
                                     input bit enable_decode);
      
      trans = new("trans");
      trans.start_time = time_stamp;
      trans.end_time = $time;
      time_stamp = trans.end_time;
      trans.npc_in = npc_in;
      trans.instr_dout = instr_dout;
      trans.psr = psr;
      trans.enable_decode = enable_decode;
      analyze(trans);
    endfunction

    virtual function void set_bfm_proxy_handle();
      monitor_bfm.proxy = this;
    endfunction

    protected virtual function void analyze(decode_in_transaction t);
      if(configuration.enable_transaction_viewing) begin
        t.add_to_wave(transaction_viewing_stream);
        `uvm_info("MONITOR_PROXY", t.convert2string(), UVM_HIGH);
      end
      analysis_port.write(t);
    endfunction

    // FUNCTION: start_of_simulation_phase
    virtual function void start_of_simulation_phase(uvm_phase phase);
      if(configuration.enable_transaction_viewing) begin
        transaction_viewing_stream = $create_transaction_stream({"..", get_full_name(), ".", "txn_stream"});
      end
    endfunction

endclass