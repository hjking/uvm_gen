`ifndef _{:UPPERNAME:}_ITEM_SV_
`define _{:UPPERNAME:}_ITEM_SV_

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}
//
//------------------------------------------------------------------------------

class {:NAME:} extends uvm_sequence_item;

    //------------------------------------------
    // Field automation
    //------------------------------------------
    `uvm_object_utils_begin({:NAME:})
    `uvm_object_utils_end

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // Request data attributes
    rand {:TYPE1:} {:IDENTIFIER1:};

    // Constraint attributes
    constraint {:CONSTRAINT1:} {

    }

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new(string name="{:NAME:}");
    extern function void   do_copy (uvm_object rhs);
    extern function bit    do_compare (uvm_object rhs, uvm_comparer _comparer);
    extern function string convert2string ();
    extern function void   do_print (uvm_printer printer);
    extern function void   do_pack (uvm_packer rhs);
    extern function void   do_unpack (uvm_packer rhs);

endclass : {:NAME:}

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}::new(string name="{:NAME:}");
    super.new(name);
endfunction : new

function void {:NAME:}::do_copy(uvm_object rhs);
endfunction

function bit {:NAME:}::do_compare(uvm_object rhs, uvm_comparer _comparer);
endfunction

function string {:NAME:}::convert2string();
endfunction

function void {:NAME:}::do_print(uvm_printer printer);
endfunction

function void {:NAME:}::do_pack(uvm_packer rhs);
endfunction

function void {:NAME:}::do_unpack(uvm_packer rhs);
endfunction

`endif
