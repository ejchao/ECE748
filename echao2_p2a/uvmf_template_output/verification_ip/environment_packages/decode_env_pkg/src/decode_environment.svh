// Extension of uvm_environment
class decode_environment extends uvm_env;
	`uvm_component_utils(decode_environment)

	// Instantiates agents, predictor, scoreboard
	decode_in_agent d_in_agent;
	decode_out_agent d_out_agent;
	decode_predictor d_predictor;
	decode_scoreboard d_scoreboard;

	decode_env_configuration configuration; 

	function new(string name = "", uvm_component parent = null);
    	super.new(name, parent);
  	endfunction

	function void set_config(decode_env_configuration cfg);
		configuration = cfg;
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// Constructs agents, predictor, scoreboard
		d_in_agent = new("d_in_agent", this);
		d_in_agent.set_config(configuration.d_in_configuration); 
		d_out_agent = new("d_out_agent", this);
		d_out_agent.set_config(configuration.d_out_configuration); 
		d_predictor = new("d_predictor", this);
		d_predictor.configuration = configuration; 
		d_scoreboard = new("d_scoreboard", this);

	endfunction

	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
		// Connects decode_in agent to predictor
    	d_in_agent.monitored_ap.connect(d_predictor.analysis_export); // input 
		// Connects predictor to scoreboard
    	d_predictor.decode_sb_ap.connect(d_scoreboard.expected_ae);
		// Connects decode_out agent to scoreboard
		d_out_agent.monitored_ap.connect(d_scoreboard.actual_ae);
  	endfunction

endclass