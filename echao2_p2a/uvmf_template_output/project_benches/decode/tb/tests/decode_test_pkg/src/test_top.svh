import uvmf_base_pkg::*;
import uvmf_base_pkg_hdl::*;
import decode_test_pkg::*;
`include "print_component.svh"

class test_top extends uvm_test;
  `uvm_component_utils(test_top)

  // Component instantiations
  decode_in_random_sequence d_in_random_sequence;
  decode_env_configuration configuration; // --- p2a ---
  decode_environment d_environment; // 

  // Initialize variables
  string environment_path = "test_top/environment/";
  string interface_names[] = {"decode_in", "decode_out"};
  uvmf_active_passive_t interface_activities[] = {ACTIVE, PASSIVE};

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    d_in_random_sequence = new("d_in_random_sequence");
    configuration = new("configuration"); // --- p2a ---
    // Environment configuration initialize call performed in test class build phase --- p2a ---
    configuration.initialize( environment_path,
                              interface_names,
                              interface_activities
                              ); 
    d_environment = new("d_environment", this);
    d_environment.set_config(configuration); // 
  endfunction 

  // Run random sequence 25 times to generate 25 random transactions
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Objection raised by test_base");
    configuration.d_in_configuration.wait_for_reset();
    if(configuration.d_in_configuration.active_passive == ACTIVE) begin
      repeat (25) d_in_random_sequence.start(configuration.d_in_configuration.sequencer);
    end
    phase.drop_objection(this, "Objection dropped by test_base");
  endtask

endclass