`ifndef _{:UPPERNAME:}_INTERFACE_SV_
`define _{:UPPERNAME:}_INTERFACE_SV_

interface {:Name:} (bit clk, bit rstN);

    task write ();
        @(posedge clk);
    endtask

    task read ();
        @(posedge clk);
    endtask

    // delay some clock cycle
    task delay (int cycle = 1);
        repeat(cycle)@(posedge clk);
    endtask
endinterface

`endif
