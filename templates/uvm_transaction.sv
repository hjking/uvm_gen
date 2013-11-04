`ifndef {:NAME:}_TRANSACTION_SV
`define {:NAME:}_TRANSACTION_SV

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_transaction
//
//------------------------------------------------------------------------------

class {:NAME:}_transaction extends uvm_sequence_item;

    // Request data attributes
    rand {:TYPE1:} {:IDENTIFIER1:};

    // Constraint attributes
    constraint {:CONSTRAINT1:} {

    }

    // Field automation
    `uvm_object_utils_begin({:NAME:}_transaction)
        `uvm_field_{:FIELD_TYPE1:}({:IDENTIFIER1:}, UVM_ALL_ON)
    `uvm_object_utils_end

    // Methods
    extern function new(string name="{:NAME:}_transaction");
    //extern function void   do_copy(uvm_object rhs);
    //extern function bit    do_compare(uvm_object rhs, uvm_comparer _comparer);
    //extern function string convert2string();
    //extern function void   do_print(uvm_printer _printer);
    //extern function void   do_record(uvm_recorder recorder);
    //extern function void   do_pack(uvm_object rhs);

endclass: {:NAME:}_transaction

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_transaction::new(string name);
    super.new(name);
endfunction: {:NAME:}_transaction::new

//`include "{:NAME:}_do_copy.svh"        /*% new do_copy        {:NAME:} FIELD1=... */
//`include "{:NAME:}_do_compare.svh"     /*% new do_compare     {:NAME:} FIELD1=... */
//`include "{:NAME:}_convert2string.svh" /*% new convert2string {:NAME:} FIELD1=... */
//`include "{:NAME:}_do_print.svh"       /*% new do_print       {:NAME:} FIELD1=... */
//`include "{:NAME:}_do_record.svh"      /*% new do_record      {:NAME:} FIELD1=... */

`endif
