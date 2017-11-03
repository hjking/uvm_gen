`ifndef _{:UPPERNAME:}_MONITOR_SV_
`define _{:UPPERNAME:}_MONITOR_SV_

class {:NAME:}Monitor extends uvm_monitor;

    // Attributes
    virtual {:NAME:}If vif;
    uvm_analysis_port #({:TRANSACTION:}) analysisPort;
    {:NAME:}Config mConfig;

    bit checksEnable = 1; // Control checking in monitor and interface.
    bit coverageEnable = 1; // Control coverage in monitor and interface.
    protected {:TRANSACTION:} transCollected;
    event covTransaction;

    covergroup covTrans @covTransaction;

    endgroup : covTrans

    `uvm_component_utils_begin({:NAME:}Monitor)
        `uvm_field_int(checksEnable, UVM_ALL_ON)
        `uvm_field_int(coverageEnable, UVM_ALL_ON)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    // Implementation
    //------------------------------------------------------------------------------
    function new(string name="{:LOWERNAME:}Monitor", uvm_component parent=null);
        super.new(name, parent);
        covTrans = new();
        this.covTrans.set_inst_name({get_full_name(), ".covTrans"});
        this.transCollected = new();
    endfunction: new

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        this.analysisPort = new("analysisPort", this);

        this.mConfig = {:NAME:}Config::get_config(this);

        if (!uvm_config_db#(virtual {:NAME:}If)::get(this, "", "{:NAME:}Vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
        end

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        this.collectTransactions(phase); // collector task
    endtask: run_phase

    task collectTransactions(uvm_phase phase);
        forever begin
            phase.raise_objection(this);
            this.busToTransaction();
            if (this.checksEnable) begin
                this.performTransferChecks();
            end

            if (this.coverageEnable) begin
                this.performTransferCoverage();
            end

            this.analysisPort.write(transCollected);
            phase.drop_objection(this);
        end
    endtask : collectTransactions

    function void busToTransaction();
    endfunction : busToTransaction

    function void performTransferCoverage();
        -> this.covTransaction;
    endfunction : performTransferCoverage

    function void performTransferChecks();
    endfunction : performTransferChecks

endclass: {:NAME:}Monitor

`endif
