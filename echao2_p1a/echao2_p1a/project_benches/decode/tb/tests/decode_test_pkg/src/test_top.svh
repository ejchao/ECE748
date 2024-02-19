import decode_test_pkg::*;

class test_top extends uvm_test;
  `uvm_component_utils(test_top)

  // Instantiate decode_in agent, agent configuration, and decode random sequence in uvm_test extension named test_top
  decode_in_agent agent;
  decode_in_configuration configuration;
  decode_in_random_sequence rand_seq;

  // virtual interface
  virtual decode_in_if if_inst;

  // configuration variables
  uvm_active_passive_enum state = UVM_ACTIVE;
  bit enable_coverage = 1;
  bit enable_transaction_viewing = 1;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual decode_in_if)::get(null, "*", "decode_in_if", if_inst)) begin
      `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_if"})
    end      
    configuration = new("Agent Configuration");
    configuration.startup(state, enable_coverage, enable_transaction_viewing);
    uvm_config_db#(decode_in_configuration)::set(null, "*", "decode_in_configuration", configuration);
    `uvm_info(get_full_name(), {"\n\nAgent Configuration: ", configuration.convert2string()}, UVM_MEDIUM)
    agent = new("Agent", this);
    if(configuration.state == UVM_ACTIVE) begin
      rand_seq = new("random_sequence");
      //`uvm_info("TEST TOP", "random sequence instantiated", UVM_MEDIUM)
    end
  endfunction 

  // Run random sequence 25 times to generate 25 random transactions
  virtual task  run_phase(uvm_phase phase);
    //`uvm_info("TEST TOP", "start run phase", UVM_MEDIUM)
    phase.raise_objection(this, "Objection raised by test_base");
    //`uvm_info("TEST TOP", "objection raised", UVM_MEDIUM)
    wait (if_inst.reset == 1'b0);
    //`uvm_info("TEST TOP", "reset low", UVM_MEDIUM) // not hitting this
    repeat (5) @(posedge if_inst.clock);
    if(configuration.state == UVM_ACTIVE) begin
      repeat (25) rand_seq.start(agent.sequencer);
    end
    phase.drop_objection(this, "Objection dropped by test_base");
  endtask

endclass