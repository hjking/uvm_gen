`ifndef _{:UPPERNAME:}_SV_
`define _{:UPPERNAME:}_SV_

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
    {:ENV_NAME:}Env mEnv;
    // Configuration objects
    {:ENV_NAME:}EnvConfig mEnvCfg;
    {:AGENT1:}Config m{:AGENT1:}Cfg;
    {:AGENT2:}Config m{:AGENT2:}Cfg;

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new(string name = {:NAME:}, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
    extern virtual function void configureEnv({:ENV_NAME:}EnvConfig cfg);
    extern virtual function void configure{:AGENT1:}({:AGENT1:}Config cfg);
    extern virtual function void configure{:AGENT2:}({:AGENT2:}Config cfg);
endclass: {:NAME:}

//------------------------------------------------------------------------------
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}::new (string name = {:NAME:}, uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("debug", "{:NAME:}::new", UVM_MEDIUM)
endfunction

//------------------------------------------------------------------------------
function void {:NAME:}::build_phase (uvm_phase phase);
    super.build_phase(phase); //< enable automation

    // Create env configuration object
    mEnv =  {:ENV_NAME:}Env::type_id::create ("mEnv", this);
    // Create env configuration object
    mEnvCfg = {:ENV_NAME:}EnvConfig::type_id::create("mEnvCfg");
    // Call function to configure the env
    configureEnv(mEnvCfg);

    // Create agent1 configuration object
    m{:AGENT1:}Cfg = {:AGENT1:}Config::type_id::create("m{:AGENT1:}Cfg");
    configure{:AGENT1:}(m{:AGENT1:}Cfg);

    // Create agent1 configuration object
    m{:AGENT2:}Cfg = {:AGENT2:}Config::type_id::create("m{:AGENT2:}Cfg");
    configure{:AGENT2:}(m{:AGENT2:}Cfg);
    // More to follow
endfunction

//
// Convenience function to configure the env
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configureEnv({:ENV_NAME:}Config cfg);
    // cfg.has_functional_coverage = 1;
    // cfg.has_reg_scoreboard = 0;
    // cfg.has_spi_scoreboard = 1;
endfunction

//
// Convenience function to configure the agent1
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configure{:AGENT1:}(m{:AGENT1:}Cfg cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
endfunction

//
// Convenience function to configure the agent1
//
// This can be overloaded by extensions to this base class
function void {:NAME:}::configure{:AGENT2:}(m{:AGENT2:}Cfg cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
endfunction

//------------------------------------------------------------------------------
function void {:NAME:}::end_of_elaboration_phase (uvm_phase phase);
    uvm_top.print();
endfunction

//------------------------------------------------------------------------------
task {:NAME:}::main_phase (uvm_phase phase);
    {:VIRTUAL_SEQUENCE:} mainSequence;
    {:if:VIRTUAL_SEQUENCER:}
    {:VIRTUAL_SEQUENCER:} virtualSequencer = mEnv.mVirtualSequencer;
    {:endif:VIRTUAL_SEQUENCER:}
    mainSequence = {:VIRTUAL_SEQUENCE:}::type_id::create();
    phase.raise_objection(this);
    {:if:VIRTUAL_SEQUENCER:}
    mainSequence.start(virtual_sequencer,null,-1,1);
    {:else:VIRTUAL_SEQUENCER:}
    mainSequence.start(null,null,-1,1);
    {:endif:VIRTUAL_SEQUENCER:}
    phase.drop_objection(this);
endtask

`endif
