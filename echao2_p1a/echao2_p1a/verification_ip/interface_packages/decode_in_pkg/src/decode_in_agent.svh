class decode_in_agent extends uvm_agent;
  `uvm_component_utils(decode_in_agent)

  decode_in_configuration configuration;
  decode_in_driver driver;
  decode_in_monitor monitor;
  decode_in_coverage coverage;
  uvm_sequencer #(decode_in_transaction) sequencer;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent retrieves its configuration using uvm_config_db
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(decode_in_configuration)::get(null, "*", "decode_in_configuration", configuration)) begin
      `uvm_fatal("FATAL MSG", "Configuration object is not set properly")
    end
    monitor = new("decode_in_monitor", this);
    if(configuration.state == UVM_ACTIVE) begin
      `uvm_info("AGENT", "decode_in_agent configured as ACTIVE", UVM_MEDIUM)
      driver = new("decode_in_driver", this);
      sequencer = new("decode_in_sequencer", this);
    end
    else begin
      `uvm_info("AGENT", "decode_in_agent configured as PASSIVE", UVM_MEDIUM)
    end
    if(configuration.enable_coverage) begin
      coverage = new("decode_in_coverage", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    monitor.monitor_bfm = configuration.monitor_bfm;
    monitor.set_bfm_proxy_handle();
    if(configuration.state == UVM_ACTIVE) begin
      driver.driver_bfm = configuration.driver_bfm;
      driver.seq_item_port.connect(sequencer.seq_item_export);
      //`uvm_info("AGENT", "driver connect successful", UVM_MEDIUM)
    end
    if(configuration.enable_coverage) begin
      monitor.analysis_port.connect(coverage.analysis_export);
    end
  endfunction

endclass