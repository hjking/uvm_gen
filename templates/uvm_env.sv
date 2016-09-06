`ifndef {:UPPERNAME:}_ENV_SV
`define {:UPPERNAME:}_ENV_SV

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}_env
//
//------------------------------------------------------------------------------
class {:NAME:}_env extends uvm_env;

    // Virtual Interface variable
    protected virtual interface {:NAME:}_if vif;

    //------------------------------------------
    // Data Members
    //------------------------------------------
    // Control properties
    protected bit has_bus_monitor = 1;
    protected int unsigned num_masters = 0;
    protected int unsigned num_slaves = 0;

    // The following two bits are used to control whether checks and coverage are
    // done both in the bus monitor class and the interface
    bit intf_checks_enable = 1;
    bit intf_coverage_enable = 1;

    //------------------------------------------
    // Sub components
    //------------------------------------------
    // Agent instance handles
    {:AGENT1:}_agent m_{:AGENT1:}_agent[];
    {:AGENT2:}_agent m_{:AGENT2:}_agent[];

    // Virtual sequencer
    <VSQR> m_virtual_sequencer;

    // UVM Factory Registration Macro
    `uvm_component_utils_begin({:NAME:}_env)
        `uvm_field_int(has_bus_monitor, UVM_ALL_ON)
        `uvm_field_int(num_masters, UVM_ALL_ON)
        `uvm_field_int(num_slaves, UVM_ALL_ON)
        `uvm_field_int(intf_checks_enable, UVM_ALL_ON)
        `uvm_field_int(intf_coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    {:if:REG1:}
    // Register blocks
    {:REG1:}_reg_model m_{:REG1:}_reg_model;
    {:endif:REG1:}

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new (string name="{:NAME:}_env", uvm_component parent=null);
    extern function void end_of_elaboration_phase (uvm_phase _phase);
    extern function void build_phase (uvm_phase _phase);
    extern function void connect_phase (uvm_phase phase);

endclass :{:NAME:}_env

////////////////////////////////////////////////////////////////////////////////
// Implementation
//------------------------------------------------------------------------------
function {:NAME:}_env::new (string name="{:NAME:}_env", uvm_component parent=null);
    super.new(name, parent);
endfunction: new

//------------------------------------------------------------------------------
function void {:NAME:}_env::end_of_elaboration_phase (uvm_phase phase);
    super.build(phase);
endfunction

//------------------------------------------------------------------------------
function void {:NAME:}_env::build_phase (uvm_phase phase);

    string inst_name;
    super.build(phase);

    // Configure

    // Create
    m_{:AGENT1:}_agent = new[num_masters];
    for(int i = 0; i < num_masters; i++)begin
        $sformat(inst_name, "m_{:AGENT1:}_agent[%0d]", i);
        m_{:AGENT1:}_agent[i] = {:AGENT1:}_agent::type_id::create(inst_name, this);
    end
    m_{:AGENT2:}_agent = new[num_slaves];
    for(int i = 0; i < num_slaves; i++)begin
        $sformat(inst_name, "m_{:AGENT2:}_agent[%0d]", i);
        m_{:AGENT2:}_agent[i] = {:AGENT2:}_agent::type_id::create(inst_name, this);
    end

    {:if:REG1:}
    // Create and build register blocks
    m_{:REG1:}_reg_model = {:REG1:}_reg_model::type_id::create("m_{:REG1:}_reg_model", this);
    m_{:REG1:}_reg_model.build();
    {:endif:REG1:}

endfunction: build_phase

//------------------------------------------------------------------------------
function void {:NAME:}_env::connect_phase (uvm_phase phase);
    // Connectivity if any

    {:if:REG1:}
    if (m_serial_reg_model.get_parent() == null) begin

        // Create register to IO adapters
        {:ADAPTOR1:}_adapter m_{:ADAPTOR1:} = {:ADAPTOR1:}_adapter::type_id::create("m_{:ADAPTOR1:}",,get_full_name());

        // Add the adapter to the register model
        m_serial_reg_model.default_map.set_sequencer(m_{:AGENT1:}_agent.m_sequencer, m_{:ADAPTOR1:});

        // Set the base address in the system
        m_{:REG1:}_reg_model.default_map.set_base_addr({:BASE1:});

    end
    {:endif:REG1:}

endfunction: connect_phase

`endif
