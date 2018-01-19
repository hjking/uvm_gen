`ifndef {:UPPERNAME:}_ENV_SV
`define {:UPPERNAME:}_ENV_SV

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}Env
//
//------------------------------------------------------------------------------
class {:NAME:}EnvCfg extends uvm_object;
        // The following two bits are used to control whether checks and coverage are
    // done both in the bus monitor class and the interface
    bit intfChecksEnable = 1;
    bit intfCoverageEnable = 1;
    bit hasBusMonitor = 1;

    // Control properties
    int unsigned numMasters = 1;
    int unsigned numSlaves = 1;

endclass : {:NAME:}EnvCfg

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}Env
//
//------------------------------------------------------------------------------
class {:NAME:}Env extends uvm_env;

    // Virtual Interface variable
    protected virtual interface {:NAME:}If vif;

    {:NAME:}EnvCfg mCfg;

    //------------------------------------------
    // Data Members
    //------------------------------------------

    //------------------------------------------
    // Sub components
    //------------------------------------------
    // Agent instance handles
    {:AGENT1:} m{:AGENT1:}[];
    {:AGENT2:} m{:AGENT2:}[];

    // Virtual sequencer
    <VSQR> mVirtualSequencer;

    // UVM Factory Registration Macro
    `uvm_component_utils_begin({:NAME:}Env)
    `uvm_component_utils_end

    {:if:REG1:}
    // Register blocks
    {:REG1:}RegModel m{:REG1:}RegModel;
    {:endif:REG1:}

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new (string name="{:NAME:}Env", uvm_component parent=null);
    extern function void end_of_elaboration_phase (uvm_phase _phase);
    extern function void build_phase (uvm_phase _phase);
    extern function void connect_phase (uvm_phase phase);

endclass : {:NAME:}Env

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}Env::new (string name="{:NAME:}Env", uvm_component parent=null);
    super.new(name, parent);
endfunction: new

//------------------------------------------------------------------------------
function void {:NAME:}Env::end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction

//------------------------------------------------------------------------------
function void {:NAME:}Env::build_phase (uvm_phase phase);

    string instName;
    // super.build(phase);

    // Configure
    if(!uvm_config_db #({:NAME:}EnvCfg)::get(this, "", "mEnvCfg", mCfg)) begin
        `uvm_error("build_phase", "Unable to find mCfg in uvm_config_db")
    end

    // Create
    m{:AGENT1:} = new[mCfg.numMasters];
    for (int i = 0; i < mCfg.numMasters; i++) begin
        $sformat(instName, "m{:AGENT1:}[%0d]", i);
        m{:AGENT1:}[i] = {:AGENT1:}::type_id::create(instName, this);
    end

    m{:AGENT2:} = new[mCfg.numSlaves];
    for (int i = 0; i < mCfg.numSlaves; i++) begin
        $sformat(instName, "m{:AGENT2:}[%0d]", i);
        m{:AGENT2:}[i] = {:AGENT2:}::type_id::create(instName, this);
    end

    {:if:REG1:}
    // Create and build register blocks
    m{:REG1:}Model = {:REG1:}RegModel::type_id::create("m{:REG1:}RegModel", this);
    m{:REG1:}Model.build();
    {:endif:REG1:}

    `uvm_info("build_phase", $sformatf("%s built", get_full_name()))

endfunction

//------------------------------------------------------------------------------
function void {:NAME:}Env::connect_phase (uvm_phase phase);
    // Connectivity if any

    {:if:REG1:}
    if (m_serial_reg_model.get_parent() == null) begin

        // Create register to IO adapters
        {:ADAPTOR1:}_adapter m_{:ADAPTOR1:} = {:ADAPTOR1:}_adapter::type_id::create("m_{:ADAPTOR1:}",,get_full_name());

        // Add the adapter to the register model
        m_serial_reg_model.default_map.set_sequencer(m_{:AGENT1:}_agent.m_sequencer, m_{:ADAPTOR1:});

        // Set the base address in the system
        m_{:REG1:}_reg_model.default_map.set_base_addr({:BASE1:});

    end
    {:endif:REG1:}

endfunction

`endif
