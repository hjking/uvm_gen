`ifndef _{:UPPERNAME:}_INTERFACE_SV_
`define _{:UPPERNAME:}_INTERFACE_SV_

interface {:Name:} ();

    logic clk;
    logic rstN;

    task Write ();
        @(posedge clk);
    endtask

    task Read ();
        @(posedge clk);
    endtask

    // delay some clock cycle
    task Delay (int cycle = 1);
        repeat(cycle)@(posedge clk);
    endtask
endinterface

`endif
