`ifndef _{:UPPERNAME:}_ENV_SV_
`define _{:UPPERNAME:}_ENV_SV_

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}Env
//
//------------------------------------------------------------------------------
class {:NAME:}EnvConfig extends uvm_object;

    // The following two bits are used to control whether checks and coverage are
    // done both in the bus monitor class and the interface
    bit intfChecksEnable = 1;
    bit intfCoverageEnable = 1;
    bit hasBusMonitor = 1;

    // include the scoreboard or not
    bit hasScoreboard = 0;

    // Control properties
    int unsigned numMasters = 1;
    int unsigned numSlaves = 1;

    // UVM Factory Registration Macro
    //
    `uvm_object_utils_begin({:NAME:}EnvConfig)
        `uvm_field_int(intfChecksEnable, UVM_ALL_ON)
        `uvm_field_int(intfCoverageEnable, UVM_ALL_ON)
        `uvm_field_int(hasBusMonitor, UVM_ALL_ON)
        `uvm_field_int(hasScoreboard, UVM_ALL_ON)
        `uvm_field_int(numMasters, UVM_ALL_ON)
        `uvm_field_int(numSlaves, UVM_ALL_ON)
    `uvm_object_utils_end


    //------------------------------------------
    // Methods
    //------------------------------------------

    function new(string name = "{:NAME:}EnvConfig");
        super.new(name);
    endfunction

endclass : {:NAME:}EnvConfig

//------------------------------------------------------------------------------
//
// CLASS: {:NAME:}Env
//
//------------------------------------------------------------------------------
class {:NAME:}Env extends uvm_env;
    string                tID;
    // Virtual Interface variable
    protected virtual interface {:NAME:}If vif;

    {:NAME:}EnvConfig cfg;

    //------------------------------------------
    // Data Members
    //------------------------------------------

    //------------------------------------------
    // Sub components
    //------------------------------------------
    // Agent instance handles
    {:AGENT1:} m{:AGENT1:}[];
    {:AGENT2:} m{:AGENT2:}[];

    // Virtual sequencer
    <VSQR> mVirtualSequencer;

    // UVM Factory Registration Macro
    `uvm_component_utils_begin({:NAME:}Env)
    `uvm_component_utils_end

    //------------------------------------------
    // Methods
    //------------------------------------------
    extern function new (string name="{:NAME:}Env", uvm_component parent=null);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern function void end_of_elaboration_phase (uvm_phase phase);
    // extern function void start_of_simulation_phase(uvm_phase phase);
    // extern task          run_phase(uvm_phase phase);
    // extern task          reset_phase(uvm_phase phase);
    // extern task          configure_phase(uvm_phase phase);
    // extern task          main_phase(uvm_phase phase);
    // extern task          shutdown_phase(uvm_phase phase);
    // extern function void extract_phase(uvm_phase phase);
    // extern function void check_phase(uvm_phase phase);
    // extern function void report_phase(uvm_phase phase);
    // extern function void final_phase(uvm_phase phase);
endclass : {:NAME:}Env

////////////////////////////////////////////////////////////////////////////////
// Implementation

//------------------------------------------------------------------------------
// Function: new
// Creates a new {:NAME:}Env component
//------------------------------------------------------------------------------
function {:NAME:}Env::new (string name="{:NAME:}Env", uvm_component parent=null);
    super.new(name, parent);
    tID = get_type_name().toupper();
endfunction: new

//------------------------------------------------------------------------------
// Function: build_phase
// Used to construct testbench components, build top-level testbench topology
//------------------------------------------------------------------------------
function void {:NAME:}Env::build_phase (uvm_phase phase);
    string instName;

    super.build_phase(phase);
    `uvm_info(tID, $sformatf("build_phase begin ..."), UVM_HIGH)

    // Configure
    if(!uvm_config_db #({:NAME:}EnvConfig)::get(this, "", "mEnvCfg", cfg)) begin
        `uvm_error("build_phase", "Unable to find cfg in uvm_config_db")
    end

    // Create
    m{:AGENT1:} = new[cfg.numMasters];
    for (int i = 0; i < cfg.numMasters; i++) begin
        $sformat(instName, "m{:AGENT1:}[%0d]", i);
        m{:AGENT1:}[i] = {:AGENT1:}::type_id::create(instName, this);
    end

    m{:AGENT2:} = new[cfg.numSlaves];
    for (int i = 0; i < cfg.numSlaves; i++) begin
        $sformat(instName, "m{:AGENT2:}[%0d]", i);
        m{:AGENT2:}[i] = {:AGENT2:}::type_id::create(instName, this);
    end

    `uvm_info("build_phase", $sformatf("%s built", get_full_name()))

endfunction

//------------------------------------------------------------------------------
// Function: connect_phase
// Used to connect components/tlm ports for environment topoloty
//------------------------------------------------------------------------------
function void {:NAME:}Env::connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(tID, $sformatf("connect_phase begin ..."), UVM_HIGH)
endfunction

//------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used to make any final adjustments to the env topology
//------------------------------------------------------------------------------
function void {:NAME:}Env::end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(tID, $sformatf("end_of_elaboration_phase begin ..."), UVM_HIGH)
endfunction


//------------------------------------------------------------------------------
// Function: start_of_simulation_phase
// Used to configure verification componets, printing
//------------------------------------------------------------------------------
function void {:NAME:}Env::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(tID, $sformatf("start_of_simulation_phase begin ..."), UVM_HIGH)

endfunction : start_of_simulation_phase

// //------------------------------------------------------------------------------
// // TASK: run_phase
// // Used to execute run-time tasks of simulation
// //------------------------------------------------------------------------------
// task {:NAME:}Env::run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     `uvm_info(tID, $sformatf("run_phase begin ..."), UVM_HIGH)
//
// endtask : run_phase
//
// //------------------------------------------------------------------------------
// // TASK: reset_phase
// // The reset phase is reserved for DUT or interface specific reset behavior
// //------------------------------------------------------------------------------
// task {:NAME:}Env::reset_phase(uvm_phase phase);
//     super.reset_phase(phase);
//     `uvm_info(tID, $sformatf("reset_phase begin ..."), UVM_HIGH)
//
// endtask : reset_phase
//
// //------------------------------------------------------------------------------
// // TASK: configure_phase
// // Used to program the DUT or memoried in the testbench
// //------------------------------------------------------------------------------
// task {:NAME:}Env::configure_phase(uvm_phase phase);
//     super.configure_phase(phase);
//     `uvm_info(tID, $sformatf("configure_phase begin ..."), UVM_HIGH)
//
// endtask : configure_phase
//
// //------------------------------------------------------------------------------
// // TASK: main_phase
// // Used to execure mainly run-time tasks of simulation
// //------------------------------------------------------------------------------
// task {:NAME:}Env::main_phase(uvm_phase phase);
//     super.main_phase(phase);
//     `uvm_info(tID, $sformatf("main_phase begin ..."), UVM_HIGH)
//
// endtask : main_phase
//
// //------------------------------------------------------------------------------
// // TASK: shutdown_phase
// // Data "drain" and other operations for graceful termination
// //------------------------------------------------------------------------------
// task {:NAME:}Env::shutdown_phase(uvm_phase phase);
//     super.shutdown_phase(phase);
//     `uvm_info(tID, $sformatf("shutdown_phase begin ..."), UVM_HIGH)
//
// endtask : shutdown_phase
//
// //------------------------------------------------------------------------------
// // Function: extract_phase
// // Used to retrieve final state of DUTG and details of scoreboard, etc.
// //------------------------------------------------------------------------------
// function void {:NAME:}Env::extract_phase(uvm_phase phase);
//     super.extract_phase(phase);
//     `uvm_info(tID, $sformatf("extract_phase begin ..."), UVM_HIGH)
//
// endfunction : extract_phase
//
// //------------------------------------------------------------------------------
// // Function: check_phase
// // Used to process and check the simulation results
// //------------------------------------------------------------------------------
// function void {:NAME:}Env::check_phase(uvm_phase phase);
//     super.check_phase(phase);
//     `uvm_info(tID, $sformatf("check_phase begin ..."), UVM_HIGH)
//
// endfunction : check_phase
//
// //------------------------------------------------------------------------------
// // Function: report_phase
// // Simulation results analysis and reports
// //------------------------------------------------------------------------------
// function void {:NAME:}Env::report_phase(uvm_phase phase);
//     super.report_phase(phase);
//     `uvm_info(tID, $sformatf("report_phase begin ..."), UVM_HIGH)
//
// endfunction : report_phase
//
// //------------------------------------------------------------------------------
// // Function: final_phase
// // Used to complete/end any outstanding actions of testbench
// //------------------------------------------------------------------------------
// function void {:NAME:}Env::final_phase(uvm_phase phase);
//     super.final_phase(phase);
//     `uvm_info(tID, $sformatf("final_phase begin ..."), UVM_HIGH)
//
// endfunction : final_phase

`endif // _{:UPPERNAME:}_ENV_SV_
