//==============================================================================
// Declaration
//------------------------------------------------------------------------------
class {:NAME:}_test extends uvm_test;
    `uvm_component_utils({:NAME:}_test)
    {:NAME:}_env m_env;
    extern function new (string _name="", uvm_component _parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass: {:NAME:}_test

//==============================================================================
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_test::new (string _name="", uvm_component _parent=null);
    super.new(_name, _parent);
    `uvm_info("debug", "{:NAME:}_test::new", UVM_MEDIUM)
endfunction: new

//------------------------------------------------------------------------------
function void {:NAME:}_env::end_of_elaboration_phase(uvm_phase phase);
function void {:NAME:}_test::build_phase(uvm_phase phase);
    super.build_phase(phase); //< enable automation
    // Configure
    // Create
    m_env =  {:NAME:}_env::type_id::create("m_env", this);
endfunction: build_phase

//------------------------------------------------------------------------------
function void {:NAME:}_env::end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print();
endfunction: {:NAME:}_env::end_of_elaboration_phase

//------------------------------------------------------------------------------
function void {:NAME:}_env::end_of_elaboration_phase(uvm_phase phase);
task {:NAME:}_test::run_phase(uvm_phase phase);
    {:VIRTUAL_SEQUENCE:} main_sequence;
    {:if:VIRTUAL_SEQUENCER:}
    {:VIRTUAL_SEQUENCER:} virtual_sequencer = m_env.m_virtual_sequencer;
    {:endif:VIRTUAL_SEQUENCER:}
    main_sequence = {:VIRTUAL_SEQUENCE:}::type_id::create();
    phase.raise_objection(this);
    {:if:VIRTUAL_SEQUENCER:}
    main_sequence.start(virtual_sequencer,null,-1,1);
    {:else:VIRTUAL_SEQUENCER:}
    main_sequence.start(null,null,-1,1);
    {:endif:VIRTUAL_SEQUENCER:}
    phase.drop_objection(this);
endtask: run_phase
