`ifndef _{:UPPERNAME:}_MONITOR_SV_
`define _{:UPPERNAME:}_MONITOR_SV_

//------------------------------------------
// Class Description
//------------------------------------------
class {:NAME:}MonitorConfig extends uvm_object;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // active or passive
    uvm_active_passive_enum isActive = UVM_ACTIVE;

    bit checksEnable = 1; // Control checking in monitor and interface.
    bit coverageEnable = 1; // Control coverage in monitor and interface.

    // UVM Factory Registration Macro
    //
    `uvm_object_utils_begin({:NAME:}MonitorConfig)
        `uvm_field_int(checksEnable, UVM_ALL_ON)
        `uvm_field_int(coverageEnable, UVM_ALL_ON)
    `uvm_object_utils_end

    //------------------------------------------
    // Constraint
    //------------------------------------------

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}MonitorConfig");
        super.new(name);
    endfunction

endclass:{:NAME:}MonitorConfig

//------------------------------------------
// Class Description
//------------------------------------------
class {:NAME:}Monitor extends uvm_monitor;

    // Attributes
    virtual {:NAME:}If vif;
    uvm_analysis_port #({:TRANSACTION:}) ap;
    {:NAME:}MonitorConfig               cfg;
    string                              tID;

    protected {:TRANSACTION:} transCollected;
    event covTransaction;

    covergroup covTrans @covTransaction;
    endgroup : covTrans

    `uvm_component_utils_begin({:NAME:}Monitor)
    `uvm_component_utils_end

    ////////////////////////////////////////////////////////////////////////////////
    // Implementation
    //------------------------------------------------------------------------------
    function new(string name="{:LOWERNAME:}Monitor", uvm_component parent=null);
        super.new(name, parent);
        this.covTrans = new();
        this.covTrans.set_inst_name({get_full_name(), ".covTrans"});
        this.transCollected = {:TRANSACTION:}::type_id::create("transCollected");
        this.cfg = new();
        this.tID = get_type_name().toupper();
        this.ap = new("ap", this);
    endfunction: new

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

        if (!(uvm_config_db #({:NAME:}Cfg)::get(this, "", "mCfg", cfg))) begin
            `uvm_fatal("CONFIG_LOAD", {get_full_name(), ".cfg get failed!!!"})
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

`endif // _{:UPPERNAME:}_MONITOR_SV_
