
`ifndef {:uc:NAME:}_DRIVER_SVH
`define {:uc:NAME:}_DRIVER_SVH

class {:NAME:}_driver extends uvm_driver #({:SEQ_ITEM:});
    `uvm_component_utils({:NAME:}_driver)

    // Attributes
    virtual {:INTERFACE:}_if.driver_mp vif;

    // Methods
    extern function new(string name="{:NAME:}_driver", uvm_component parent=null);
    extern virtual task drive_{:NAME:}
    extern task run_phase(uvm_phase phase);
endclass : {:NAME:}_driver

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_driver::new(string name="{:NAME:}_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction: new

virtual {:NAME:}_driver::task drive_{:NAME:}({:TYPE:} _{:ARG:});
    {:BFM_CODE_HERE:}
endtask: drive_{:NAME:}

task {:NAME:}_driver::run_phase(uvm_phase phase);
    {:INIT_HARDWARE:}
    forever begin
        seq_item_port.get_next_item(req);
        phase.raise_objection();
        drive_{:NAME:}({:ARGS:});
    `ifdef USING_RESPONSE
        {:CONSTRUCT_RSP_ITEM:}
        rsp.set_id_info(req);
        seq_item_port.item_done(rsp);
    `else
        seq_item_port.item_done();
    `endif
        phase.drop_objection();
    end
endtask: run_phase

`endif
