// Extends from uvm_component
class print_component extends uvm_component;
  `uvm_component_utils(print_component)

  // In the test package use the uvm_analysis_imp_decl macro to define two analysis_exports
  // One for decode_in and another for decode_out
  `uvm_analysis_imp_decl(_decode_in_analysis_export)
  `uvm_analysis_imp_decl(_decode_out_analysis_export)

  // Contains one of each of the analysis exports defined above
  uvm_analysis_imp_decode_in_analysis_export#(decode_in_transaction, print_component) decode_in_analysis_export;
  uvm_analysis_imp_decode_out_analysis_export#(decode_out_transaction, print_component) decode_out_analysis_export;

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
    decode_in_analysis_export = new("decode_in_analysis_export", this);
    decode_out_analysis_export = new("decode_out_analysis_export", this);
  endfunction

  // Prints the transaction received in the write_... Function
  function void write_decode_in_analysis_export(decode_in_transaction trans);
    `uvm_info(get_full_name(), {"Decode Input: ", trans.convert2string()}, UVM_MEDIUM)
  endfunction

  function void write_decode_out_analysis_export(decode_out_transaction trans);
    `uvm_info(get_full_name(), {"Decode Output: ", trans.convert2string()}, UVM_MEDIUM)
  endfunction

endclass