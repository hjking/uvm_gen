`ifndef _{:UPPERNAME:}CONFIG_SV_
`define _{:UPPERNAME:}CONFIG_SV_

// Class Description
//
class {:NAME:}Config extends uvm_object;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils({:NAME:}Config)

    // Virtual Interface
    //

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // active or passive
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // include the functional coverage or not
    bit has_functional_coverage = 0;

    // include the scoreboard or not
    bit has_scoreboard = 0;

    //------------------------------------------
    // Constraint
    //------------------------------------------

    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}Config");
        super.new(name);
    endfunction

endclass:{:NAME:}Config

`endif

