`ifndef _{:UPPERNAME:}_SEQUENCE_SV_
`define _{:UPPERNAME:}_SEQUENCE_SV_

class {:NAME:}Sequence extends uvm_sequence #({:TRANSACTION:});

    `uvm_sequence_utils({:NAME:}Sequence)

    // Attributes
    /*NONE*/

    // Methods
    extern function new (string name="{:NAME:}Sequence");
    //ignore task pre_start();
    //ignore task pre_body(); -- not recommended
    extern task body;
    //ignore task post_body(); -- not recommended
    //ignore task post_start();
    //ignore task pre_do();
    //ignore task mid_do();
    //ignore task post_do();

endclass: {:NAME:}Sequence

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}Sequence::new (string name="{:NAME:}Sequence");
    super.new(name);
endfunction

task {:NAME:}Sequence::body;

    if (starting_phase != null) begin
        starting_phase.raise_objection(this,"starting {:NAME:}Sequence");
    end

    //`uvm_do(req)
    req = {:TRANSACTION:}::type_id::create("req");
    start_item(req); // wait for request from driver

    if (!req.randomize()) begin // late "just-in-time" randomization
        `uvm_error("body", "randomization failure for req") // an error can be overridden
    end

    finish_item(req); // send the data

    if (starting_phase != null) begin
        starting_phase.drop_objection(this,"finishing {:NAME:}_sequence");
    end
endtask

`endif
