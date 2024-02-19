onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -expand /hdl_top/clk
add wave -noupdate -expand /hdl_top/rst
add wave -noupdate -expand /hdl_top/enable_decode
add wave -noupdate -expand /hdl_top/dout
add wave -noupdate -expand /hdl_top/npc_in
add wave -noupdate -expand /hdl_top/IR
add wave -noupdate -expand /hdl_top/npc_out
add wave -noupdate -expand /hdl_top/E_Control
add wave -noupdate -expand /hdl_top/W_Control
add wave -noupdate -expand /hdl_top/Mem_Control
add wave -noupdate -expand /uvm_root/uvm_test_top/d_environment/d_in_agent/d_in_agent_monitor/txn_stream
add wave -noupdate -expand /uvm_root/uvm_test_top/d_environment/d_out_agent/d_out_agent_monitor/txn_stream
