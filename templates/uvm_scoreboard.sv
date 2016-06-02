`ifndef {:UPPERNAME:}_SCOREBOARD_SV
`define {:UPPERNAME:}_SCOREBOARD_SV

class {:NAME:}_scoreboard extends uvm_scoreboard;
    `uvm_component_utils({:NAME:}_scoreboard)

    // Attributes

    // Methods
    extern function new (string name="{:NAME:}_scoreboard", uvm_component parent=null);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task main_phase (uvm_phase phase);
    extern function void start_of_simulation_phase (uvm_phase phase);
    extern function void report_phase (uvm_phase phase);
endclass: {:NAME:}_monitor

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_scoreboard::new (string name="{:NAME:}_scoreboard", uvm_component parent=null);
    super.new(name, parent);
endfunction: new

function void connect_phase (uvm_phase phase);
endfunction

task {:NAME:}_scoreboard::main_phase (uvm_phase phase);
endtask: main_phase

//------------------------------------------------------------------------------
// Print configuration
//
function {:NAME:}_scoreboard::start_of_simulation_phase (uvm_phase phase);
endfunction

`endif
