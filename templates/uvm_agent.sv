`ifndef _{:UPPERNAME:}AGENT_SV_
`define _{:UPPERNAME:}AGENT_SV_


////////////////////////////////////////////////////////////////////////////////
// Class : {:NAME:}AgentConfig
////////////////////////////////////////////////////////////////////////////////
class {:NAME:}AgentConfig extends uvm_object;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils({:NAME:}AgentConfig)

    //------------------------------------------
    // Data Members
    //------------------------------------------

    // include the functional coverage or not
    bit hasCoverage = 0;

    // active or passive
    bit isActive = 1;

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}AgentConfig");
        super.new(name);
    endfunction

endclass:{:NAME:}AgentConfig


//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_agent
//
//------------------------------------------------------------------------------

class {:NAME:}Agent extends uvm_agent;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    {:NAME:}AgentConfig cfg;

    static string MSGID = "/{:COMPANY:}/{:PROJECT:}/{:NAME:}_agent";

    `uvm_component_utils_begin({:NAME:}Agent)
    `uvm_component_utils_end

    //------------------------------------------
    // Component Members
    //------------------------------------------
    uvm_analysis_port #({:TRANSACTION:})   ap;

    {:NAME:}Sequencer #({:TRANSACTION:})   sqr;
    {:NAME:}Monitor                        mon;
    {:NAME:}Driver                         drv;
    {:NAME:}Coverage                       cov;

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

    this.cfg = new();
endfunction

//------------------------------------------------------------------------------
// Construct sub-components
// retrieve and set sub-component configuration
//
function void {:NAME:}Agent::build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #({:NAME:}AgentConfig)::get(this, "{:NAME:}AgentConfig", cfg))begin
        `uvm_error({MSGID,"Failed to get agent's config object: {:NAME:}AgentConfig"})
    end
    // Monitor is always present
    mon = {:NAME:}Monitor::type_id::create("mon", this);
    // Only build the driver and sequencer if active
    if(cfg.isActive == UVM_ACTIVE)begin
        sqr = {:NAME:}Sequencer#({:TRANSACTION:})::type_id::create("sqr", this);
        drv    = {:NAME:}Driver::type_id::create("drv", this);
    end
    if(cfg.hasCoverage)begin
        cov = {:NAME:}Coverage::type_id::create("cov", this);
    end
endfunction: build_phase

//------------------------------------------------------------------------------
// Connect sub-components
//
function void {:NAME:}Agent::connect_phase (uvm_phase phase);
    mon.{:NAME:}Vif = cfg.{:LOWERNAME:}Vif;
    ap = mon.analysisPort;
    // Only connect the driver and the sequencer if active
    if(cfg.isActive == UVM_ACTIVE)
        drv.seq_item_port.connect(sqr.seq_item_export);
        drv.{:NAME:}Vif = cfg.{:NAME:}Vif;
    end
    if(cfg.hasCoverage) begin
        m_monitor.analysis_port.connect(m_coverage.analysis_export);
    end
endfunction: connect_phase

`endif
