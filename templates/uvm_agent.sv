`ifndef {:UPPERNAME:}_AGENT_SV
`define {:UPPERNAME:}_AGENT_SV

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_agent
//
//------------------------------------------------------------------------------

class {:NAME:}_agent extends uvm_agent;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    {:NAME:}_agent_config m_cfg;
    bit coverage_enable = 1;
    bit checks_enable = 1;
    static string MSGID = "/{:COMPANY:}/{:PROJECT:}/{:NAME:}_agent";

    `uvm_component_utils_begin({:NAME:}_agent)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    //------------------------------------------
    // Component Members
    //------------------------------------------
    uvm_analysis_port #({:TRANSACTION:}) analysis_port;
    {:NAME:}_monitor        m_monitor;
    {:NAME:}_sequencer      m_sequencer;
    {:NAME:}_driver         m_driver;
    {:NAME:}_coverage       m_coverage;

    //------------------------------------------
    // Methods
    //------------------------------------------
    // Standard Methods
    extern function new (string name = "{:NAME:}_agent", uvm_component parent = null);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass: {:NAME:}_agent

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
// Constructor
function {:NAME:}_agent::new (string name = "{:NAME:}_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

//------------------------------------------------------------------------------
// Construct sub-components
// retrieve and set sub-component configuration
//
function void {:NAME:}_agent::build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #({:NAME:}_agent_config)::get(this,"{:NAME:}_agent_config", m_cfg))begin
        `uvm_error({MSGID,"Failed to get agent's config object: {:NAME:}_agent_config")
    end
    // Monitor is always present
    m_monitor = {:NAME:}_monitor::type_id::create("m_monitor", this);
    // Only build the driver and sequencer if active
    if(m_cfg.is_active == UVM_ACTIVE)begin
        m_driver    = {:NAME:}_driver::type_id::create("m_driver", this);
        m_sequencer = {:NAME:}_sequencer::type_id::create("m_sequencer", this);
    end
    if(m_cfg.has_functional_coverage)begin
        m_coverage = {:NAME:}_coverage::type_id::create("m_coverage", this);
    end
endfunction: build_phase

//------------------------------------------------------------------------------
// Connect sub-components
//
function void {:NAME:}_agent::connect_phase (uvm_phase phase);
    m_monitor.{:NAME:}_vif = m_cfg.{:NAME:}_vif;
    analysis_port = m_monitor.analysis_port;
    // Only connect the driver and the sequencer if active
    if(m_cfg.is_active == UVM_ACTIVE)
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        m_driver.{:NAME:}_vif = m_cfg.{:NAME:}_vif;
    end
    if(m_cfg.has_functional_coverage) begin
        m_monitor.analysis_port.connect(m_coverage.analysis_export);
    end
endfunction: connect_phase

`endif
