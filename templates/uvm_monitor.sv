
`ifndef {:uc:NAME:}_MONITOR_SVH
`define {:uc:NAME:}_MONITOR_SVH

class {:NAME:}_monitor extends uvm_monitor;
  `uvm_component_utils({:NAME:}_monitor)

  // Attributes
  virtual {:INTERFACE:}_if.monitor_mp vif;
  uvm_analysis_port#({:TRANSACTION:}) analysis_port;

  // Methods
  extern function new(string name="{:NAME:}_monitor", uvm_component parent=null);
  extern task run_phase(uvm_phase phase);
endclass : {:NAME:}_monitor

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_monitor::new
( string name="{:NAME:}_monitor"
, uvm_component parent=null
);
  super.new(name, parent);
endfunction: new

task {:NAME:}_monitor::run_phase(uvm_phase phase);
  {:TRANSACTION:} trans; //< place to store gathered data
  {:INITIALIZAION:}
  forever begin
    trans = new;
    @({:EVENT_:});
    phase.raise_objection();
    {:GATHER_DATA_INTO_TRANS:}
    analysis_port.write(trans);
    phase.drop_objection();
  end
endtask: run_phase
