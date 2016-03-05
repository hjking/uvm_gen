`ifndef {:UPPERNAME:}_MONITOR_SV
`define {:UPPERNAME:}_MONITOR_SV

class {:NAME:}_monitor extends uvm_monitor;

    // Attributes
    virtual {:NAME:}_if vif;
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

    ////////////////////////////////////////////////////////////////////////////////
    // Implementation
    //------------------------------------------------------------------------------
    function new(string name="{:NAME:}_monitor", uvm_component parent=null);
        super.new(name, parent);
        cov_trans = new();
        cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
        trans_collected = new();
    endfunction: new

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_port = new("analysis_port", this);

        m_config = {:NAME:}_config::get_config(this);

        if(!uvm_config_db#(virtual {:NAME:}_if)::get(this, "", "{:NAME:}_vif", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
    endfunction

    task run_phase(uvm_phase phase);
        collect_transactions(); // collector task
    endtask: run_phase

    task collect_transactions();
        forever begin
            phase.raise_objection();
            bus_to_transaction();
            if (checks_enable)
                perform_transfer_checks();
            if (coverage_enable)
                perform_transfer_coverage();
            analysis_port.write(trans_collected);
            phase.drop_objection();
        end
    endtask : collect_transactions

    function void bus_to_transaction();
    endfunction : bus_to_transaction

    function void perform_transfer_coverage();
        -> cov_transaction;
    endfunction : perform_transfer_coverage

    function void perform_transfer_checks();
    endfunction : perform_transfer_checks

endclass: {:NAME:}_monitor

`endif
