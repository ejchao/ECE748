// Extension of uvm_component
class decode_scoreboard extends uvm_component;
	`uvm_component_utils(decode_scoreboard)

	// Use uvm_analysis_imp_decl to create two analysis_exports
		// One for expected output from decode stage
		// One for actual output from decode stage
	`uvm_analysis_imp_decl(_expected)
	`uvm_analysis_imp_decl(_actual)

	uvm_analysis_imp_expected#(decode_out_transaction, decode_scoreboard) expected_ae;
	uvm_analysis_imp_actual#(decode_out_transaction, decode_scoreboard) actual_ae;

	// Use a systemVerilog queue to store transactions received from expected analysis export
	decode_out_transaction expected_results[$];
	decode_out_transaction expected_transaction;

	int match_count = 0;
	int mismatch_count = 0;
	int nothing_to_compare_against_count = 0;

	bit end_of_test_empty_check = 1'b1;
	bit end_of_test_activity_check = 1'b1;
	int transaction_count = 0;

	bit wait_for_scoreboard_empty = 1'b1;
	event entry_received;

	//int report_variables[];
	//string report_header = "SCOREBOARD_RESULTS: ";

	function new(string name="", uvm_component parent=null);
    	super.new(name, parent);
    	expected_ae = new("expected_ae", this);
    	actual_ae = new("actual_ae", this);
    	expected_transaction = new();
		// Inserts the given element at the end of the queue
		// queue starts with { 0 }
    	expected_results.push_back( expected_transaction );
    endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	virtual function string compare_message(string header, decode_out_transaction expected, decode_out_transaction actual);
		return {header, "\nEXPECTED: ", expected.convert2string(), "\nACTUAL: ", actual.convert2string()};
	endfunction

	// When a transaction is received through actual analysis export
		// Retrieve an expected item from the queue
	// Keep count of expected transactions received and comparisons made
	virtual function void write_actual(decode_out_transaction t);
		->entry_received;
		expected_transaction = new();
		// Removes and returns the first element of the queue
		expected_transaction = expected_results.pop_front();
		if ( !expected_transaction ) // if queue is empty, transaction will be 0 which will trigger
			begin : try_get_fail
			nothing_to_compare_against_count++;
			`uvm_error($sformatf("SCOREBOARD_ERROR.%s", this.get_full_name()), "NO PREDICTED ENTRY TO COMPARE AGAINST!")
			end : try_get_fail
		else 
			begin : try_get_pass
				// Use the decode_out_transaction compare function to compare the actual with expected --- p2a ---
				// Compare actual transaction to expected transaction
				if ( t.compare( expected_transaction ) )
					begin : compare_pass
					match_count++;
					// Transaction match: send message using `uvm_info --- p2a ---
					`uvm_info($sformatf("SCOREBOARD_INFO.%s", this.get_full_name()), compare_message("MATCH! - ", expected_transaction, t), UVM_MEDIUM)
					end : compare_pass
				else
					begin : compare_fail
					mismatch_count++;
					// Transaction mismatch: send message with `uvm_error --- p2a ---
					`uvm_error($sformatf("SCOREBOARD_INFO.%s", this.get_full_name()), compare_message("MISMATCH! - ", expected_transaction, t))
					end : compare_fail
			end : try_get_pass
	endfunction : write_actual

	function void write_expected(decode_out_transaction t);
		// Inserts given element at the end of the queue
		// { 0, 1, 2 } <--- queue from expected
		expected_results.push_back(t);
		transaction_count++;
		//->entry_received;
	endfunction

	virtual function void check_phase(uvm_phase phase);
		super.check_phase(phase);
		if ( end_of_test_empty_check && ( expected_results.size() != 0 ) )
			begin : entries_remain
			`uvm_error($sformatf("SCOREBOARD_ERROR.%s", this.get_full_name()), "SCOREBOARD NOT EMPTY");
			end : entries_remain
		if ( end_of_test_activity_check && ( transaction_count == 0 ) )
			begin : entries_remaining
			`uvm_error($sformatf("SCOREBOARD_ERROR.%s", this.get_full_name()), "SCOREBOARD RECEIVED NO TRANSACTIONS FROM THE PREDICTOR")
			end : entries_remaining
	endfunction

	virtual task wait_for_scoreboard_drain();
		while ( expected_results.size() != 0 ) 
			begin : while_entries_remain
			@entry_received;
			// removes and returns the first element of the queue
			// clear up queue
			expected_results.pop_front();
			end : while_entries_remain
	endtask

	virtual function void phase_ready_to_end(uvm_phase phase);
		if ( phase.get_name() == "run" )
			begin : if_run_phase
			if ( wait_for_scoreboard_empty )
				begin : if_wait_for_scoreboard_empty
				phase.raise_objection( this, {get_full_name(),"- DELAYING UNTIL SCOREBOARD EMPTY"});
				fork
					begin : wait_for_scoreboard_to_drain 
						wait_for_scoreboard_drain();
						phase.drop_objection( this, {get_full_name(), "- DONE DELAYING UNTIL SCOREBOARD EMPTY"});
					end : wait_for_scoreboard_to_drain
				join_none
				end : if_wait_for_scoreboard_empty
			end : if_run_phase
	endfunction
/*
	virtual function string report_message( string header, int variables [] );
		return {$sformatf("%s PREDICTED_TRANSACTIONS=%.0d MATCHES=%.0d MISMATCHES=%.0d", header, variables[0], variables[1], variables[2])};
	endfunction
*/
	// Report results during report phase
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info($sformatf("SCOREBOARDS_SUMMARY.%s", this.get_full_name()), $sformatf("PREDICTED_TRANSACTIONS=%.0d", transaction_count), UVM_MEDIUM) 
		`uvm_info($sformatf("SCOREBOARDS_SUMMARY.%s", this.get_full_name()), $sformatf("MATCHES=%.0d", match_count), UVM_MEDIUM) 
		`uvm_info($sformatf("SCOREBOARDS_SUMMARY.%s", this.get_full_name()), $sformatf("MISMATCHES=%.0d", mismatch_count), UVM_MEDIUM) 
	endfunction

endclass