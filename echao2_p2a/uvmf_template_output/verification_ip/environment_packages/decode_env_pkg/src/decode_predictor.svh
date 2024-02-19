// Extension of uvm_subscriber
class decode_predictor extends uvm_subscriber #(decode_in_transaction);
    `uvm_component_utils(decode_predictor)

	//`uvm_analysis_imp_decl(_decode_in)
	//uvm_analysis_imp_decode_in#(decode_in_transaction, decode_predictor) decode_in_ae;

	// Instantiates an analysis_port
	// Use uvm_analysis_port for broadcasting transactions
	uvm_analysis_port #(decode_out_transaction) decode_sb_ap;

	decode_out_transaction d_out_trans_pred;

	decode_env_configuration configuration; 

    function new( string name = "", uvm_component parent = null );
        super.new( name, parent );
    endfunction    

	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase); 
		// Constructs an analysis_port
		//decode_in_ae = new("decode_in_ae", this);
		decode_sb_ap = new("decode_sb_ap", this);
	endfunction

    // Use decode_model function for prediction
	virtual function void write(decode_in_transaction t);
		d_out_trans_pred = new("d_out_trans_pred");
		decode_model(	t.instruction,
						t.npc_in,
						d_out_trans_pred.IR,
						d_out_trans_pred.npc_out,
						d_out_trans_pred.E_Control,
						d_out_trans_pred.W_Control,
						d_out_trans_pred.Mem_Control 
						);
		// Broadcast predicted result through analysis port
		decode_sb_ap.write(d_out_trans_pred);
	endfunction

endclass