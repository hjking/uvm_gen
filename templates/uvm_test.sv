`ifndef {:UPPERNAME:}_SV
`define {:UPPERNAME:}_SV

//------------------------------------------------------------------------------
// Class Description
//------------------------------------------------------------------------------
class {:NAME:} extends {:PARENT:};

    //------------------------------------------
    // UVM Factory Registration Macro
    //------------------------------------------
    `uvm_component_utils({:NAME:})

    //------------------------------------------
    // Data Members
    //------------------------------------------

    //------------------------------------------
    // Component Members
    //------------------------------------------
    {:ENV_NAME:}_env m_env;

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
endclass: {:NAME:}

//------------------------------------------------------------------------------
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}::new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("debug", "{:NAME:}::new", UVM_MEDIUM)
endfunction: new

//------------------------------------------------------------------------------
function void {:NAME:}::build_phase(uvm_phase phase);
    super.build_phase(phase); //< enable automation
    // Configure
    // Create
    m_env =  {:ENV_NAME:}_env::type_id::create("m_env", this);
endfunction: build_phase

//------------------------------------------------------------------------------
function void {:NAME:}::end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print();
endfunction: {:NAME:}::end_of_elaboration_phase

//------------------------------------------------------------------------------
task {:NAME:}::run_phase(uvm_phase phase);
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

`endif
