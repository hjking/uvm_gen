`ifndef _{:UPPERNAME:}_MONITOR_SV_
`define _{:UPPERNAME:}_MONITOR_SV_

//------------------------------------------
// Class Description
//------------------------------------------
class {:NAME:}Cfg extends uvm_object;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // active or passive
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    bit checksEnable = 1; // Control checking in monitor and interface.
    bit coverageEnable = 1; // Control coverage in monitor and interface.

    // UVM Factory Registration Macro
    //
    `uvm_object_utils_begin({:NAME:}Cfg)
        `uvm_field_int(checksEnable, UVM_ALL_ON)
        `uvm_field_int(coverageEnable, UVM_ALL_ON)
    `uvm_object_utils_end


    //------------------------------------------
    // Constraint
    //------------------------------------------

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}Cfg");
        super.new(name);
    endfunction

endclass:{:NAME:}Cfg

//------------------------------------------
// Class Description
//------------------------------------------
class {:NAME:}Monitor extends uvm_monitor;

    // Attributes
    virtual {:NAME:}If vif;
    uvm_analysis_port #({:TRANSACTION:}) ap;
    {:NAME:}Cfg     mCfg;

    protected {:TRANSACTION:} transCollected;
    event covTransaction;

    covergroup covTrans @covTransaction;
    endgroup : covTrans

    `uvm_component_utils_begin({:NAME:}Monitor)
        `uvm_field_object(mCfg, UVM_ALL_ON)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    // Implementation
    //------------------------------------------------------------------------------
    function new(string name="{:LOWERNAME:}Monitor", uvm_component parent=null);
        super.new(name, parent);
        this.covTrans = new();
        this.covTrans.set_inst_name({get_full_name(), ".covTrans"});
        this.transCollected = {:TRANSACTION:}::type_id::create("transCollected");
        this.mCfg = new();

        this.ap = new("ap", this);
    endfunction: new

    function build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!(uvm_config_db #({:NAME:}Cfg)::get(this, "", "mCfg", mCfg))) begin
            `uvm_fatal("CONFIG_LOAD", {get_full_name(), ".mCfg get failed!!!"})
        end

        if (!(uvm_config_db#(virtual {:NAME:}If)::get(this, "", "{:NAME:}Vif", vif))) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
        end

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        this.CollectTransactions(phase); // collector task
    endtask: run_phase

    task CollectTransactions(uvm_phase phase);
        {:TRANSACTION:} transCollectedClone;

        forever begin
            phase.raise_objection(this);

            this.BusToTransaction();
            if (this.checksEnable) begin
                this.performTransferChecks();
            end

            if (this.coverageEnable) begin
                this.performTransferCoverage();
            end

            $cast(transCollectedClone, this.transCollected.clone());
            this.ap.write(transCollectedClone);

            phase.drop_objection(this);
        end
    endtask : CollectTransactions

    function void BusToTransaction();
    endfunction : BusToTransaction

    function void PerformTransferCoverage();
        -> this.covTransaction;
    endfunction : PerformTransferCoverage

    function void PerformTransferChecks();
    endfunction : PerformTransferChecks

endclass: {:NAME:}Monitor

`endif
