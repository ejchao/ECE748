package decode_env_pkg;

   import uvmf_base_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import decode_in_pkg::*;
   import decode_out_pkg::*;
   import lc3_prediction_pkg::*;

   `include "src/decode_env_configuration.svh"
   `include "src/decode_predictor.svh"
   `include "src/decode_scoreboard.svh"
   `include "src/decode_environment.svh"

endpackage
