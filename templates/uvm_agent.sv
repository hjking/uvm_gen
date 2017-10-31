`ifndef _{:UPPERNAME:}AGENT_SV_
`define _{:UPPERNAME:}AGENT_SV_

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_agent
//
//------------------------------------------------------------------------------

class {:NAME:}Agent extends uvm_agent;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    {:NAME:}AgentConfig mAgtCfg;
    bit coverage_enable = 1;
    bit checks_enable = 1;
    static string MSGID = "/{:COMPANY:}/{:PROJECT:}/{:NAME:}_agent";

    `uvm_component_utils_begin({:NAME:}Agent)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    //------------------------------------------
    // Component Members
    //------------------------------------------
    uvm_analysis_port #({:TRANSACTION:}) analysis_port;

    {:NAME:}Sequencer #({:TRANSACTION:})   mSequencer;
    {:NAME:}Monitor                        mMonitor;
    {:NAME:}Driver                         mDriver;
    {:NAME:}Coverage                       mCoverage;

    //------------------------------------------
    // Methods
    //------------------------------------------
    // Standard Methods
    extern function new (string name = "{:NAME:}Agent", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass: {:NAME:}Agent

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
// Constructor
function {:NAME:}Agent::new (string name = "{:NAME:}Agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

//------------------------------------------------------------------------------
// Construct sub-components
// retrieve and set sub-component configuration
//
function void {:NAME:}Agent::build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #({:NAME:}AgentConfig)::get(this, "{:NAME:}AgentConfig", mAgtCfg))begin
        `uvm_error({MSGID,"Failed to get agent's config object: {:NAME:}AgentConfig"})
    end
    // Monitor is always present
    mMonitor = {:NAME:}Monitor::type_id::create("mMonitor", this);
    // Only build the driver and sequencer if active
    if(mAgtCfg.is_active == UVM_ACTIVE)begin
        mSequencer = {:NAME:}Sequencer#({:TRANSACTION:})::type_id::create("mSequencer", this);
        mDriver    = {:NAME:}Driver::type_id::create("mDriver", this);
    end
    if(mAgtCfg.has_functional_coverage)begin
        mCoverage = {:NAME:}Coverage::type_id::create("mCoverage", this);
    end
endfunction: build_phase

//------------------------------------------------------------------------------
// Connect sub-components
//
function void {:NAME:}Agent::connect_phase (uvm_phase phase);
    mMonitor.{:NAME:}Vif = mAgtCfg.{:LOWERNAME:}Vif;
    analysisPort = mMonitor.analysisPort;
    // Only connect the driver and the sequencer if active
    if(mAgtCfg.is_active == UVM_ACTIVE)
        mDriver.seq_item_port.connect(m_sequencer.seq_item_export);
        mDriver.{:NAME:}Vif = mAgtCfg.{:NAME:}Vif;
    end
    if(m_cfg.has_functional_coverage) begin
        m_monitor.analysis_port.connect(m_coverage.analysis_export);
    end
endfunction: connect_phase

`endif
