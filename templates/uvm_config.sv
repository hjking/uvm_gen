`ifndef {:UPPERNAME:}_CONFIG_SV
`define {:UPPERNAME:}_CONFIG_SV

// Class Description
//
class {:NAME:}_config extends uvm_object;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils({:NAME:}_config)

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

    function new(string name = "{:NAME:}_config");
        super.new(name);
    endfunction

endclass:{:NAME:}_config

`endif

