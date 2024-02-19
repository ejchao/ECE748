// Environment configuration should contain initialize function
	// Receives from test: path to environment, interface names, agent activities
	// Passes to agent configurations: path to agent, interface name, agent activity

// Extension of uvm_object
class decode_env_configuration extends uvm_object;
	`uvm_object_utils(decode_env_configuration)

	// Instantiates agent configurations
	decode_in_configuration d_in_configuration;
	decode_out_configuration d_out_configuration;

	function new(string name = "");
    	super.new(name);
		d_in_configuration    = new("d_in_configuration");
    	d_out_configuration   = new("d_out_configuration");
  	endfunction

	function void post_randomize();
		super.post_randomize();
		if(!d_in_configuration.randomize()) `uvm_fatal("RAND","decode_in randomization failed");
    	if(!d_out_configuration.randomize()) `uvm_fatal("RAND","decode_out randomization failed");
	endfunction

	virtual function string convert2string();
    	return {
    		"\n", d_in_configuration.convert2string,
    		"\n", d_out_configuration.convert2string
    	};
  	endfunction

	// Contains initialize function
	// Receives parent path, interface names, and activity settings for all agents within the environment
	function void initialize(	string environment_path,
								string interface_names[],
								uvmf_active_passive_t interface_activity[] = {}
								);
		// Calls agent config initialize function passing agent path, interface name, and activity
		// Interface initialization for local agents
		d_in_configuration.initialize(	interface_activity[0], 
										{environment_path, ".d_in_agent"}, 
										interface_names[0]
										);
		d_in_configuration.initiator_responder = INITIATOR;

		d_out_configuration.initialize(	interface_activity[1], 
										{environment_path, ".d_out_agent"}, 
										interface_names[1]
										);
		d_out_configuration.initiator_responder = RESPONDER;
	endfunction

endclass

