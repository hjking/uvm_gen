class {:NAME:}_agent extends uvm_component;

    // Data attributes
    {:CONFIG:} m_cfg; //< fetched from config DB as "{:CONFIG:}"
    bit coverage_enable = 1;
    bit check_enable = 1;
    `uvm_component_utils_begin({:NAME:}_agent)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    typedef uvm_sequencer#({:TRANSACTION:}) {:SEQUENCER:};

    // Component attributes
    {:if:NO_TYPEDEF:}
    uvm_analysis_port #({:TRANSACTION:}) analysis_port;
    {:endif:NO_TYPEDEF:}
    {:NAME:}_monitor          m_monitor;
    {:SEQUENCER:}        m_sequencer;
    {:DRIVER:}           m_driver;
    {:if:ADD_COVERAGE:}
    {:COVERAGE:} m_coverage;
    {:endif:ADD_COVERAGE:}

    // Standard Methods
    extern function new(string _name = "{:NAME:}_agent", uvm_component _parent = null);
    extern function void build_phase( uvm_phase _phase );
    extern function void connect_phase( uvm_phase _phase );

    static string MSGID = "/{:COMPANY:}/{:PROJECT:}/{:NAME:}_agent";

endclass : {:NAME:}_agent

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
// Constructor
function {:NAME:}_agent::new(string name = "{:NAME:}_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

//------------------------------------------------------------------------------
// Report configuration
//
function {:NAME:}_agent::start_of_simulation_phase(uvm_phase phase);
endfunction

//------------------------------------------------------------------------------
// Construct sub-components
// retrieve and set sub-component configuration
//
function void {:NAME:}_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if( !uvm_config_db #( {:CONFIG:} )::get(this,"{:CONFIG:}",m_cfg) ) begin
        `uvm_error({MSGID,"Failed to get agent's config object: {:CONFIG:}")
    end
    // Monitor is always present
    m_monitor = {:MONITOR:}::type_id::create("m_monitor", this);
    // Only build the driver and sequencer if active
    if (get_is_active() == UVM_ACTIVE) begin
        m_driver    = {:DRIVER:}_driver::type_id::create   ("m_driver",    this);
        m_sequencer = {:SEQUENCER:}_sequencer::type_id::create("m_sequencer", this);
    end
    {:if:ADD_COVERAGE:}
    if(coverage_enable) begin
        m_coverage = {:COVERAGE:}::type_id::create("m_coverage", this);
    end
    {:endif:ADD_COVERAGE:}
endfunction: build_phase

//------------------------------------------------------------------------------
// Connect sub-components
//
function void {:NAME:}_agent::connect_phase(uvm_phase phase);
    m_monitor.{:NAME:}_vif = m_cfg.{:NAME:}_vif;
    analysis_port = new("analysis_port", this);
    // Only connect the driver and the sequencer if active
    if (get_is_active() == UVM_ACTIVE)
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        m_driver.{:NAME:}_vif = m_cfg.{:NAME:}_vif;
    end
    {:if:ADD_COVERAGE:}
    if(coverage_enable) begin
        m_monitor.analysis_port.connect(m_coverage.analysis_export);
    end
    {:endif:ADD_COVERAGE:}
endfunction :connect_phase
