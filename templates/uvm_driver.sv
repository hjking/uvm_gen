`ifndef {:UPPERNAME:}_DRIVER_SV
`define {:UPPERNAME:}_DRIVER_SV

class {:NAME:}_driver extends uvm_driver #({:SEQ_ITEM:});

    {:SEQ_ITEM:} req;
    `uvm_component_utils({:NAME:}_driver)

    // Attributes
    virtual {:INTERFACE:}_if.driver_mp vif;

    // Methods
    extern function new (string name="{:NAME:}_driver", uvm_component parent=null);
    extern function start_of_simulation_phase (uvm_phase phase);
    extern function build_phase(uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task drive_item({:SEQ_ITEM:} item);
    extern function phase_ended (uvm_phase phase);
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
// Print configuration
//
function {:NAME:}_driver::start_of_simulation_phase(uvm_phase phase);
endfunction : start_of_simulation

//------------------------------------------------------------------------------
// Build
//
function {:NAME:}_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual {:INTERFACE:}_if.driver_mp)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction : build_phase

//------------------------------------------------------------------------------
// Get and process items
//
task {:NAME:}_driver::run_phase(uvm_phase phase);
    {:INIT_HARDWARE:}
    forever begin
        // Get the next data item from sequencer
        seq_item_port.get_next_item(req);
        phase.raise_objection();
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
        phase.drop_objection();
    end
endtask : run_phase

//------------------------------------------------------------------------------
// Drive sequence item
//
task {:NAME:}_driver::drive_item({:SEQ_ITEM:} item);
    // Add your logic here
endtask : drive_item

//------------------------------------------------------------------------------
// Jump Back
//
function {:NAME:}_driver::phase_ended (uvm_phase phase);
endfunction

`endif
