`ifndef {:UPPERNAME:}_DRIVER_SV
`define {:UPPERNAME:}_DRIVER_SV

class {:NAME:}_driver extends uvm_driver #({:TRANSACTION:});

    {:TRANSACTION:} req;

    `uvm_component_utils_begin({:NAME:}_driver)
    `uvm_component_utils_end

    // Attributes
    virtual {:NAME:}_if vif;

    // Methods
    extern function new (string name="{:NAME:}_driver", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase (uvm_phase phase);
    extern task drive_item({:TRANSACTION:} item);
endclass : {:NAME:}_driver

////////////////////////////////////////////////////////////////////////////////
// Implementation
//
//------------------------------------------------------------------------------
// Constructor
//
function {:NAME:}_driver::new(string name="{:NAME:}_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// Build
//
function void {:NAME:}_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual {:NAME:}_if)::get(this, "", "{:NAME:}_vif", vif))
        `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction : build_phase

//------------------------------------------------------------------------------
// Get and process items
//
task {:NAME:}_driver::main_phase(uvm_phase phase);
    {:INIT_HARDWARE:}
    forever begin
        // Get the next data item from sequencer
        seq_item_port.get_next_item(req);
        phase.raise_objection(this);
        // Execute the item
        drive_item(req);
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
endtask : main_phase

//------------------------------------------------------------------------------
// Drive sequence item
//
task {:NAME:}_driver::drive_item({:TRANSACTION:} item);
    // Add your logic here
endtask : drive_item

`endif
