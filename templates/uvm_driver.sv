`ifndef _{:UPPERNAME:}_DRIVER_SV_
`define _{:UPPERNAME:}_DRIVER_SV_

////////////////////////////////////////////////////////////////////////////////
// Class Description
////////////////////////////////////////////////////////////////////////////////
class {:NAME:}DriverConfig extends uvm_object;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils_begin({:NAME:}DriverConfig)
        `uvm_field_int(hasCoverage, UVM_ALL_ON)
    `uvm_object_utils_end

    //------------------------------------------
    // Data Members
    //------------------------------------------

    // include the functional coverage or not
    bit hasCoverage = 0;

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}DriverConfig");
        super.new(name);
    endfunction

endclass:{:NAME:}DriverConfig

////////////////////////////////////////////////////////////////////////////////
// Class Description
////////////////////////////////////////////////////////////////////////////////
class {:NAME:}Driver extends uvm_driver #({:TRANSACTION:});

    {:TRANSACTION:} req;
    {:NAME:}DriverConfig  cfg;
    string                tID;

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

//------------------------------------------------------------------------------
// Function: new
// Creates a new driver
function {:NAME:}Driver::new(string name="{:NAME:}Driver", uvm_component parent=null);
    super.new(name, parent);
    this.cfg = new();
    this.tID = get_type_name().toupper();
endfunction : new

//------------------------------------------------------------------------------
// Build
//
function void {:NAME:}Driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    // Get configuration from uvm_config_db
    if (!(uvm_config_db #({:NAME:}DriverConfig)::get(this, "", "mCfg", cfg))) begin
        `uvm_fatal("CONFIG_LOAD", {get_full_name(), ".cfg get failed!!!"})
    end

    // Get virtual interface from uvm_config_db
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

`endif // _{:UPPERNAME:}_DRIVER_SV_
