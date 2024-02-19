// The only package import needed in hvl_top is the test package which imports the other necessary packages.
// The constructed uvm test object is it's own top level and is not instanced in hvl_top. 
// hvl_top is a vehicle to ensure the test package is imported and run_test started.

// Import decode_test_pkg in hvl_top module
import uvm_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
import decode_test_pkg::*;

module hvl_top();

    initial run_test();

endmodule