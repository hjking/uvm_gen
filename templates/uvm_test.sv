`ifndef {:UPPERNAME:}_SV
`define {:UPPERNAME:}_SV

//------------------------------------------------------------------------------
// Class Description
//------------------------------------------------------------------------------
class {:NAME:} extends uvm_test;

    //------------------------------------------
    // UVM Factory Registration Macro
    //------------------------------------------
    `uvm_component_utils({:NAME:})

    //------------------------------------------
    // Data Members
    //------------------------------------------

    //------------------------------------------
    // Component Members
    //------------------------------------------
    // The environment class
    {:ENV_NAME:}_env m_env;
    // Configuration objects
    {:ENV_NAME:}_env_config m_env_cfg;
    {:AGENT1:}_agent_config m_{:AGENT1:}_agent_cfg;
    {:AGENT2:}_agent_config m_{:AGENT2:}_agent_cfg;

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new(string name = {:NAME:}, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
    extern virtual function void configure_env({:ENV_NAME:}_env_config cfg);
    extern virtual function void configure_{:AGENT1:}_agent({:AGENT1:}_agent_config cfg);
    extern virtual function void configure_{:AGENT2:}_agent({:AGENT2:}_agent_config cfg);
endclass: {:NAME:}

//------------------------------------------------------------------------------
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}::new (string name = {:NAME:}, uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("debug", "{:NAME:}::new", UVM_MEDIUM)
endfunction: new

//------------------------------------------------------------------------------
function void {:NAME:}::build_phase (uvm_phase phase);
    super.build_phase(phase); //< enable automation

    // Create env configuration object
    m_env =  {:ENV_NAME:}_env::type_id::create ("m_env", this);
    // Create env configuration object
    m_env_cfg = {:ENV_NAME:}_env_config::type_id::create("m_env_cfg");
    // Call function to configure the env
    configure_env(m_env_cfg);

    // Create agent1 configuration object
    m_{:AGENT1:}_agent_cfg = {:AGENT1:}_agent_config::type_id::create("m_{:AGENT1:}_agent_cfg");
    configure_{:AGENT1:}_agent(m_{:AGENT1:}_agent_cfg);

    // Create agent1 configuration object
    m_{:AGENT2:}_agent_cfg = {:AGENT2:}_agent_config::type_id::create("m_{:AGENT2:}_agent_cfg");
    configure_{:AGENT2:}_agent(m_{:AGENT2:}_agent_cfg);
    // More to follow
endfunction: build_phase

//
// Convenience function to configure the env
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configure_env({:ENV_NAME:}_env_config cfg);
    // cfg.has_functional_coverage = 1;
    // cfg.has_reg_scoreboard = 0;
    // cfg.has_spi_scoreboard = 1;
endfunction: configure_env

//
// Convenience function to configure the agent1
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configure_{:AGENT1:}_agent(m_{:AGENT1:}_agent_cfg cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
endfunction: configure_{:AGENT1:}_agent

//
// Convenience function to configure the agent1
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configure_{:AGENT2:}_agent(m_{:AGENT2:}_agent_cfg cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
endfunction: configure_{:AGENT2:}_agent

//------------------------------------------------------------------------------
function void {:NAME:}::end_of_elaboration_phase (uvm_phase phase);
    uvm_top.print();
endfunction: {:NAME:}::end_of_elaboration_phase

//------------------------------------------------------------------------------
task {:NAME:}::main_phase (uvm_phase phase);
    {:VIRTUAL_SEQUENCE:} main_sequence;
    {:if:VIRTUAL_SEQUENCER:}
    {:VIRTUAL_SEQUENCER:} virtual_sequencer = m_env.m_virtual_sequencer;
    {:endif:VIRTUAL_SEQUENCER:}
    main_sequence = {:VIRTUAL_SEQUENCE:}::type_id::create();
    phase.raise_objection(this);
    {:if:VIRTUAL_SEQUENCER:}
    main_sequence.start(virtual_sequencer,null,-1,1);
    {:else:VIRTUAL_SEQUENCER:}
    main_sequence.start(null,null,-1,1);
    {:endif:VIRTUAL_SEQUENCER:}
    phase.drop_objection(this);
endtask: main_phase

`endif
