`include "uvm_macros.svh"

module {:NAME:}_test_top;

    import uvm_pkg::*;
    import {:NAME:}_test_pkg::*;

    // Clock generation
    localparam PERIOD = {:PERIOD:}ns;
    bit {:CLOCK:} = 0;
    always #(PERIOD/2) {:CLOCK:} = ~{:CLOCK:};

    // Instantiate the static parts of the testbench
    //
    {:if:PORTS:}
    {:INTERFACE1:}_if {:INTERFACE1:}_if1({:CLOCK:},{:PORTS:});
    {:INTERFACE2:}_if {:INTERFACE2:}_if2({:CLOCK:},{:PORTS:});
    {:else:PORTS:}
    {:INTERFACE1:}_if {:INTERFACE1:}_if1({:CLOCK:});
    {:INTERFACE2:}_if {:INTERFACE2:}_if2({:CLOCK:});
    {:endif:PORTS:}

    // DUT
    {:DUT:} dut(
        {:CONNECTION_LIST:}
    )

    //----------------------------------------------------------------------------
    initial begin
        // Hardware interfaces for UVM monitors & drivers
        uvm_config_db #(virtual {:INTERFACE}_if.{:MODPORT:})::set(null, "*", "{:MODPORT:}", {:INTERFACE:}_if1.{:MODPORT:});
        uvm_config_db #(virtual {:INTERFACE1}_if)::set(null, "{:NAME:}_test_top", "{:MODPORT:}", {:INTERFACE1:}_if1);
        uvm_config_db #(virtual {:INTERFACE2}_if)::set(null, "{:NAME:}_test_top", "{:MODPORT:}", {:INTERFACE2:}_if2);
    end

    // run testcase, specify testcase by `+UVM_TESTNAME=testname`
    initial begin
        run_test();
    end
endmodule: {:NAME:}_test_top
