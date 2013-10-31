`include "uvm_macros.svh"

module {:NAME:}_test_top;

    timeunit 1ns;
    timeprecision 1ps;

    import uvm_pkg::*;
    import {:NAME:}_test_pkg::*;

    // Clock generation
    localparam PERIOD = {:PERIOD:}ns;
    bit {:CLOCK:} = 0;
    always #(PERIOD/2) {:CLOCK:} = ~{:CLOCK:};

    // Instantiate the static parts of the testbench
    //
    {:if:PORTS:}
    {:INTERFACE:}_if {:INTERFACE:}_if1({:CLOCK:},{:PORTS:});
    {:else:PORTS:}
    {:INTERFACE:}_if {:INTERFACE:}_if1({:CLOCK:});
    {:endif:PORTS:}

    dut_model dut(
        {:CONNECTION_LIST:}
    )

    //----------------------------------------------------------------------------
    initial begin
        // Hardware interfaces for UVM monitors & drivers
        uvm_config_db #(virtual {:INTERFACE}_if.{:MODPORT:})::set(null, "*", "{:MODPORT:}", {:INTERFACE:}_if1.{:MODPORT:});

        run_test();
    end

endmodule: {:NAME:}_test_top
