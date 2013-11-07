`ifndef {:UPPERNAME:}_SEQUENCE_SV
`define {:UPPERNAME:}_SEQUENCE_SH

class {:NAME:}_sequence extends uvm_sequence #({:TRANSACTION:});
    `uvm_sequence_utils({:NAME:}_sequence)

    // Attributes
    /*NONE*/

    // Methods
    extern function new (string name="{:NAME:}_sequence");
    //ignore task pre_start();
    //ignore task pre_body(); -- not recommended
    extern task body;
    //ignore task post_body(); -- not recommended
    //ignore task post_start();
    //ignore task pre_do();
    //ignore task mid_do();
    //ignore task post_do();

endclass: {:NAME:}_sequence

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_sequence::new (string name="{:NAME:}_sequence");
    super.new(name);
endfunction: {:NAME:}_sequence::new

task {:NAME:}_sequence::body;
    if (starting_phase != null) starting_phase.raise_objection(this,"starting {:NAME:}_sequence");

    //`uvm_do(req)
    req = {:TRANSACTION:}::type_id::create("req");
    start_item(req); // wait for request from driver
    if (!req.randomize()) begin // late "just-in-time" randomization
        `uvm_error("body", "randomization failure for req") // an error can be overridden
    end
    finish_item(req); // send the data

    if (starting_phase != null) starting_phase.drop_objection(this,"finishing {:NAME:}_sequence");
endtask: {:NAME:}_sequence::body

`endif
