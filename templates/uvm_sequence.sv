`ifndef _{:UPPERNAME:}_SEQUENCE_SV_
`define _{:UPPERNAME:}_SEQUENCE_SV_

class {:NAME:}Sequence extends uvm_sequence #({:TRANSACTION:});

    `uvm_sequence_utils({:NAME:}Sequence)

    // Attributes
    /*NONE*/

    // Methods
    extern function new (string name="{:NAME:}Sequence");

    extern task body;

endclass: {:NAME:}Sequence

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}Sequence::new (string name="{:NAME:}Sequence");
    super.new(name);
endfunction

task {:NAME:}Sequence::body;

    //`uvm_do(req)
    {:TRANSACTION:} orig_req = {:TRANSACTION:}::type_id::create("orig_req");
    {:TRANSACTION:} req;

    $cast(req, orig_req.clone());
    start_item(req); // wait for request from driver

    if (!req.randomize()) begin // late "just-in-time" randomization
        `uvm_error("body", "randomization failure for req") // an error can be overridden
    end

    finish_item(req); // send the data

    `uvm_info("SEQ", req.convert2string(), UVM_DEBUG)

endtask

`endif
