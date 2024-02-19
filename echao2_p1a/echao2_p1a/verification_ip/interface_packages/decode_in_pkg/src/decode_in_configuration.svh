class decode_in_configuration extends uvm_object;
  `uvm_object_utils(decode_in_configuration)

  // Agent configuration containing BFM handles
  virtual decode_in_monitor_bfm monitor_bfm;
  virtual decode_in_driver_bfm driver_bfm;

  // configuration variables
  uvm_active_passive_enum state;
  bit enable_coverage;
  bit enable_transaction_viewing;

  function new(string name = "");
    super.new(name);
  endfunction

  // Agent configuration retrieves BFM handles using uvm_config_db
  function void startup(input uvm_active_passive_enum mode, input en_cover, input bit en_view);
    if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(null, "*", "decode_in_monitor_bfm", monitor_bfm)) begin
      `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_monitor_bfm"})
    end
    if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(null, "*", "decode_in_driver_bfm", driver_bfm)) begin
      `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_driver_bfm"})
    end
    state = mode;
    enable_coverage = en_cover;
    enable_transaction_viewing = en_view;
  endfunction

  // Convert2string method in transaction and configuration classes
  virtual function string convert2string();
    return $sformatf("\n    Monitor BFM: %p\n    Driver BFM: %p\n    Active/Passive: %s\n    Enable Coverage: %s\n    Enable Transaction Viewing: %s\n", monitor_bfm, driver_bfm, (state?"ACTIVE":"PASSIVE"), (enable_coverage?"ON":"OFF"), (enable_transaction_viewing?"ON":"OFF"));
  endfunction

endclass