
#
#----------------------------------------------------------------------
# Project         : decode Simulation Bench 
# Unit            : Bench makefile
# File            : Makefile
#----------------------------------------------------------------------
#                                          
# DESCRIPTION: This makefile includes the shared makefile and contains
#   bench level make targets.
#


# *********************************************************************************************
# UVMF library directory:
# This variable points to the UVMF release where uvmf_base_pkg directory resides.
# This variable points to release code that is not user modified.
# This variable allows for UVMF release directories to reside independent of project related verification_ip and project_benches directories.
# This code below looks "upward" for directory starting with UVMF_* and returns first match for use with the release examples.
UVMF_HOME ?= /mnt/ncsudrive/e/echao2/UVMF_2023.3

#
# Project(s) specific verification_ip library:
# Directory where reusable verification packages for interfaces, environments, utilities, etc. reside.
# This variable allows for verification_ip to reside independent of project bench and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/verification_ip
# export UVMF_VIP_LIBRARY_HOME ?= ../../../verification_ip
export UVMF_VIP_LIBRARY_HOME ?= $(PWD)/../../../verification_ip
#
# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
# export UVMF_PROJECT_DIR ?= ../../../project_benches/decode
export UVMF_PROJECT_DIR ?= $(PWD)/..
#
#
# *********************************************************************************************

## Check PATH for required vinfo scripts
PVAL := $(shell command -v make_filelist.py 2> /dev/null)
ifndef PVAL
  MFLIST = $(UVMF_HOME)/scripts/make_filelist.py
else
  MFLIST = make_filelist.py
endif

# Set test case specific Variables
TEST_NAME            ?= test_top

TEST_SEED            ?= 1
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0

# Usage of vinfo flow for generating file list
USE_VINFO           ?= 0

# Usage of Veloce and Questa profilers
USE_VELOCE_PROFILER ?= 0
USE_QUESTA_PROFILER ?= 0


# Set project Variables
TEST_PLAN_NAME       = decode_TestPlan
REPORTING_DO_FILE    = decode_reports_script

# Include makefile that includes targets for UVM_VIP_Library packages
include $(UVMF_HOME)/scripts/Makefile


# Include all requisite interface package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/decode_in_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/decode_out_pkg/Makefile

# Include all requisite environment package targets for this bench

# Add to default compile/load/run arguments
VCOM_ARGS             += 

# Note: vsim-3009 error can be eliminated by adding -timescale 1ps/1ps to VLOG_ARGS
VLOG_ARGS             += +define+UVM_REPORT_DISABLE_FILE_LINE
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=
EXTRA_VOPT_TOPS       +=

COMMON_VSIM_ARGS      +=  
COMMON_VSIM_ARGS      +=  


BATCH_VSIM_ARGS       += #-uvmcontrol=none
DEBUG_VSIM_ARGS       += 
EXTRA_VSIM_TOPS       += 

decode_TEST_PKG =\
$(UVMF_PROJECT_DIR)/tb/tests/decode_test_pkg/decode_test_pkg.sv

decode_VERILOG_DUT =\
$(UVMF_PROJECT_DIR)/rtl/verilog/Decode_Pipelined.vp

comp_decode_tests_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/tests $(decode_TEST_PKG)

comp_decode_dut: 
	$(HDL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/rtl/verilog $(decode_VERILOG_DUT)

comp_hvl : comp_hvl_core

comp_hvl_core :   \
	comp_decode_in_pkg  \
	comp_decode_out_pkg \
	comp_decode_tests_pkg 

comp_uvmf_core : comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg 

build: comp_decode_dut comp_uvmf_core comp_hvl comp_test_bench  

