/*
 * This package contains all of the components, transactions
 * and sequences related to the {:NAME:}Agent.  Import this
 * package if you need to use the {:NAME:}Agent anywhere.
 */

`ifndef _{:UPPERNAME:}_PKG_SV_
`define _{:UPPERNAME:}_PKG_SV_

package {:NAME:}Pkg;
    import uvm_pkg::*;

    //Typedef used by the agent

    //Include the agent config object
    `include "{:NAME:}Config.sv"

    // Include the components
    `include "{:NAME:}Driver.sv"
    `include "{:NAME:}Monitor.sv"

	`include "{:NAME:}Agent.sv"

endpackage: {:NAME:}Pkg

`endif
