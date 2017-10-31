`ifndef _{:UPPERNAME:}_SCOREBOARD_SV_
`define _{:UPPERNAME:}_SCOREBOARD_SV_

class {:NAME:}Scoreboard extends uvm_scoreboard;

    `uvm_component_utils({:NAME:}Scoreboard)

    // Attributes

    // Methods
    extern function new (string name="{:NAME:}Scoreboard", uvm_component parent=null);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern function void start_of_simulation_phase (uvm_phase phase);
    extern function void report_phase (uvm_phase phase);
endclass: {:NAME:}Scoreboard

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}Scoreboard::new (string name="{:NAME:}Scoreboard", uvm_component parent=null);
    super.new(name, parent);
endfunction: new

function void {:NAME:}Scoreboard::build_phase (uvm_phase phase);
endfunction

function void {:NAME:}Scoreboard::connect_phase (uvm_phase phase);
endfunction

task {:NAME:}Scoreboard::run_phase (uvm_phase phase);
endtask: run_phase

//------------------------------------------------------------------------------
// Print configuration
//
function void {:NAME:}Scoreboard::start_of_simulation_phase (uvm_phase phase);
endfunction

function void {:NAME:}Scoreboard::report_phase (uvm_phase phase);
endfunction

`endif
