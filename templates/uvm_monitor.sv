`ifndef {:UPPERNAME:}_MONITOR_SV
`define {:UPPERNAME:}_MONITOR_SV

class {:NAME:}_monitor extends uvm_monitor;

    // Attributes
    virtual {:INTERFACE:}_if.monitor_mp vif;
    uvm_analysis_port #({:TRANSACTION:}) analysis_port;
    {:NAME:}_config m_config;

    bit checks_enable = 1; // Control checking in monitor and interface.
    bit coverage_enable = 1; // Control coverage in monitor and interface.
    protected {:TRANSACTION:} trans_collected;
    event cov_transaction;

    covergroup cov_trans @cov_transaction;

    endgroup : cov_trans

    `uvm_component_utils_begin({:NAME:}_monitor)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    // Methods
    extern function new (string name="{:NAME:}_monitor", uvm_component parent=null);
    extern function build_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern function start_of_simulation_phase (uvm_phase phase);
    extern virtual protected task collect_transactions();
    extern virtual protected function void perform_transfer_coverage();
endclass: {:NAME:}_monitor

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_monitor::new (string name="{:NAME:}_monitor", uvm_component parent=null);
    super.new(name, parent);
    cov_trans = new();
    cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
    trans_collected = new();
endfunction: new

function {:NAME:}_monitor::build_phase (uvm_phase phase);
    super.build_phase(phase);
    analysis_port = new("analysis_port", this);
    m_config = {:NAME:}_config::get_config(this);
endfunction

task {:NAME:}_monitor::run_phase (uvm_phase phase);
    {:INITIALIZAION:}
    collect_transactions(); // collector task
endtask: run_phase

task {:NAME:}_monitor::collect_transactions();
    forever begin
        @({:EVENT_:});
        phase.raise_objection();
        {:GATHER_DATA_INTO_TRANS:}
        if (checks_enable)
            perform_transfer_checks();
        if (coverage_enable)
            perform_transfer_coverage();
        analysis_port.write(trans_collected);
        phase.drop_objection();
    end
endtask : collect_transactions

function void {:NAME:}_monitor::perform_transfer_coverage();
    -> cov_transaction;
endfunction : perform_transfer_coverage

function void perform_transfer_checks();

endfunction : perform_transfer_checks

//------------------------------------------------------------------------------
// Print configuration
//
function {:NAME:}_monitor::start_of_simulation_phase(uvm_phase phase);
endfunction

`endif
