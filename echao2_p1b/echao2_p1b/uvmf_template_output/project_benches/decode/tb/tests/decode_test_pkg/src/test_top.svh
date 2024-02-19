import uvmf_base_pkg::*;
import uvmf_base_pkg_hdl::*;
import decode_test_pkg::*;
`include "print_component.svh"

class test_top extends uvm_test;
  `uvm_component_utils(test_top)

  // decode_in
  decode_in_agent           d_in_agent;
  decode_in_configuration   d_in_configuration;
  decode_in_random_sequence d_in_random_sequence;

  // decode_out
  decode_out_agent           d_out_agent;
  decode_out_configuration   d_out_configuration;
  decode_out_random_sequence d_out_random_sequence;

  string interface_names[] = {"decode_in", "decode_out"};

  // print_component
  print_component print_comp;

  // virtual interface
  virtual decode_in_if d_in_if;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // Instantiate the decode_out agent, agent configuration, and call to agent configuration initialize call to test_top class definition
    d_in_configuration    = new("d_in_configuration");
    d_out_configuration   = new("d_out_configuration");
    d_in_agent            = new("d_in_agent", this);
    d_out_agent           = new("d_out_agent", this);
    d_in_random_sequence  = new("d_in_random_sequence");
    d_out_random_sequence = new("d_out_random_sequence");

    // check uvmf_base_pkg_hdl for ACTIVE/PASSIVE and INITIATOR/RESPONDER handles
    d_in_configuration.initialize(ACTIVE, {"uvm_test_top",".d_in_agent"}, interface_names[0]);
    d_in_configuration.initiator_responder = INITIATOR;
    d_out_configuration.initialize(PASSIVE, {"uvm_test_top",".d_out_agent"}, interface_names[1]);
    d_out_configuration.initiator_responder = RESPONDER;

    uvm_config_db#(decode_in_configuration)::set(this, "*", "d_in_configuration", d_in_configuration);
    `uvm_info(get_full_name(), {"\n\nd_in_configuration: ", d_in_configuration.convert2string()}, UVM_MEDIUM)
    uvm_config_db#(decode_out_configuration)::set(this, "*", "d_out_configuration", d_out_configuration); 
    `uvm_info(get_full_name(), {"\n\nd_out_configuration: ", d_out_configuration.convert2string()}, UVM_MEDIUM) 
  
    // Instantiate the print_component in the test_class
    print_comp = new("print_comp", this);
  endfunction 

  // Connect the print_component in the test class to the analysis port of each agent
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d_in_agent.monitored_ap.connect(print_comp.decode_in_analysis_export);
    d_out_agent.monitored_ap.connect(print_comp.decode_out_analysis_export);
  endfunction

  // Run random sequence 25 times to generate 25 random transactions
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Objection raised by test_base");
    d_in_configuration.wait_for_reset();
    if(d_in_configuration.active_passive == ACTIVE) begin
      repeat (25) d_in_random_sequence.start(d_in_configuration.sequencer);
    end
    phase.drop_objection(this, "Objection dropped by test_base");
  endtask

endclass