`ifndef _{:UPPERNAME:}_DRIVER_SV_
`define _{:UPPERNAME:}_DRIVER_SV_

////////////////////////////////////////////////////////////////////////////////
// Class Description
////////////////////////////////////////////////////////////////////////////////
class {:NAME:}Cfg extends uvm_object;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils({:NAME:}Cfg)

    //------------------------------------------
    // Data Members
    //------------------------------------------

    // include the functional coverage or not
    bit has_functional_coverage = 0;

    // include the scoreboard or not
    bit has_scoreboard = 0;

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}Cfg");
        super.new(name);
    endfunction

endclass:{:NAME:}Cfg

////////////////////////////////////////////////////////////////////////////////
// Class Description
////////////////////////////////////////////////////////////////////////////////
class {:NAME:}Driver extends uvm_driver #({:TRANSACTION:});

    {:TRANSACTION:} req;
    {:NAME:}Cfg  mCfg;

    `uvm_component_utils_begin({:NAME:}Driver)
    `uvm_component_utils_end

    // Attributes
    virtual {:NAME:}If vif;

    // Methods
    extern function new (string name="{:NAME:}Driver", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task DriveItem({:TRANSACTION:} item);

endclass : {:NAME:}Driver

////////////////////////////////////////////////////////////////////////////////
// Implementation
//
//------------------------------------------------------------------------------
// Constructor
//
function {:NAME:}Driver::new(string name="{:NAME:}Driver", uvm_component parent=null);
    super.new(name, parent);
    this.mCfg = new();
endfunction : new

//------------------------------------------------------------------------------
// Build
//
function void {:NAME:}Driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!(uvm_config_db #({:NAME:}Cfg)::get(this, "", "mCfg", mCfg))) begin
        `uvm_fatal("CONFIG_LOAD", {get_full_name(), ".mCfg get failed!!!"})
    end

    if (!uvm_config_db#(virtual {:NAME:}If)::get(this, "", "{:NAME:}Vif", this.vif)) begin
        `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// Get and process items
//
task {:NAME:}Driver::run_phase(uvm_phase phase);
    {:INIT_HARDWARE:}
    forever begin
        // Get the next data item from sequencer
        seq_item_port.get_next_item(req);
        phase.raise_objection(this);
        // Execute the item
        this.DriveItem(req);

    `ifdef USING_RESPONSE
        {:CONSTRUCT_RSP_ITEM:} rsp;
        rsp.set_id_info(req);
        // response
        // seq_item_port.item_done(rsp);
        seq_item_port.put_response(rsp);
    `else
        // consume the request
        seq_item_port.item_done();
    `endif
        phase.drop_objection(this);
    end
endtask : run_phase

//------------------------------------------------------------------------------
// Drive sequence item
//
task {:NAME:}Driver::DriveItem({:TRANSACTION:} item);
    // Add your logic here
endtask : DriveItem

`endif
