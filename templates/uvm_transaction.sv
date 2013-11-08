`ifndef {:UPPERNAME:}_TRANSACTION_SV
`define {:UPPERNAME:}_TRANSACTION_SV

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_transaction
//
//------------------------------------------------------------------------------

class {:NAME:}_transaction extends uvm_sequence_item;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // Request data attributes
    rand {:TYPE1:} {:IDENTIFIER1:};

    // Constraint attributes
    constraint {:CONSTRAINT1:} {

    }

    //------------------------------------------
    // Field automation
    //------------------------------------------
    `uvm_object_utils_begin({:NAME:}_transaction)
        `uvm_field_{:FIELD_TYPE1:}({:IDENTIFIER1:}, UVM_ALL_ON)
    `uvm_object_utils_end


    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new (string name="{:NAME:}_transaction");
    // extern function void   do_copy (uvm_object rhs);
    // extern function bit    do_compare (uvm_object rhs, uvm_comparer _comparer);
    // extern function string convert2string ();
    // extern function void   do_print (uvm_printer printer);
    // extern function void   do_record (uvm_recorder recorder);
    // extern function void   do_pack (uvm_object rhs);
    // extern function void   do_unpack (uvm_object rhs);

endclass: {:NAME:}_transaction

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_transaction::new (string name="{:NAME:}_transaction");
    super.new(name);
endfunction: new

// function void   {:NAME:}_transaction::do_copy(uvm_object rhs);
// endfunction

// function bit    {:NAME:}_transaction::do_compare(uvm_object rhs, uvm_comparer _comparer);
// endfunction

// function string {:NAME:}_transaction::convert2string();
// endfunction

// function void   {:NAME:}_transaction::do_print(uvm_printer printer);
// endfunction

// function void   {:NAME:}_transaction::do_record(uvm_recorder recorder);
// endfunction

// function void   {:NAME:}_transaction::do_pack(uvm_object rhs);
// endfunction

// function void   {:NAME:}_transaction::do_unpack(uvm_object rhs);
// endfunction

`endif
