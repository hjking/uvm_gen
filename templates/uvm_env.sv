
class {:NAME:}_env extends uvm_env;
  `uvm_component_utils({:NAME:}_env)

  // Agent instance handles
  {:AGENT1:}_agent m_{:AGENT1:}_agent;
  {:AGENT2:}_agent m_{:AGENT2:}_agent;
  ...
  // Virtual sequencer
  <VSQR> m_virtual_sequencer;

  {:if:REG1:}
  // Register blocks
  {:REG1:}_reg_model m_{:REG1:}_reg_model;
  {:endif:REG1:}

  // Methods
  extern function new (string _name="", uvm_component _parent=null);
  extern function void build_phase(uvm_phase _phase);
  extern function void connect_phase(uvm_phase phase);

endclass :{:NAME:}_env

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_env::new (string _name="", uvm_component _parent=null);
  super.new(_name, _parent);
endfunction: {:NAME:}_env::new

//------------------------------------------------------------------------------
function void {:NAME:}_env::end_of_elaboration_phase(uvm_phase phase);
function void {:NAME:}_env::build_phase(uvm_phase _phase);
  super.build(_phase);

  // Configure

  // Create
  m_{:AGENT1:}_agent = {:AGENT1:}_agent::type_id::create("m_{:AGENT1:}_agent", this);
  m_{:AGENT2:}_agent = {:AGENT2:}_agent::type_id::create("m_{:AGENT2:}_agent", this);
  ...

  {:if:REG1:}
  // Create and build register blocks
  m_{:REG1:}_reg_model = {:REG1:}_reg_model::type_id::create("m_{:REG1:}_reg_model", this);
  m_{:REG1:}_reg_model.build();
  {:endif:REG1:}

endfunction: {:NAME:}_env::build_phase

//------------------------------------------------------------------------------
function void {:NAME:}_env::connect_phase(uvm_phase phase);
  // Connectivity if any

  {:if:REG1:}
  if (m_serial_reg_model.get_parent() == null) begin

     // Create register to IO adapters
     {:ADAPTOR1:}_adapter m_{:ADAPTOR1:} = {:ADAPTOR1:}_adapter::type_id::create("m_{:ADAPTOR1:}",,get_full_name());

     // Add the adapter to the register model
     m_serial_reg_model.default_map.set_sequencer(m_{:AGENT1:}_agent.m_sequencer, m_{:ADAPTOR1:});

     // Set the base address in the system
     m_{:REG1:}_reg_model.default_map.set_base_addr({:BASE1:});
     ...

  end
  {:endif:REG1:}

endfunction: {:NAME:}_env::connect_phase
