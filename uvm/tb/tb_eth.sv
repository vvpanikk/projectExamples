/*******************************************
This is a basic UVM "Hello World" testbench.

Explanation of this testbench on YouTube:
https://www.youtube.com/watch?v=Qn6SvG-Kya0
*******************************************/

`include "uvm_macros.svh"
`include "eth_if.sv"
`include "eth_pkg.svh"
`include "eth_tb_pkg.svh"

// The top module that contains the DUT and interface.
// This module starts the test.
module tb_eth;
  import uvm_pkg::*;
  import eth_pkg::*;
  import eth_tb_pkg::*;
  `include "tb_eth_testlib.svh"
  logic clk;
  logic rst_n;
  
  // Instantiate the interface
  eth_if eth_if_i(clk, rst_n);
  
  // Clk generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
 initial begin
    rst_n = 1;
    #1;
    rst_n = 0;
    #1;
    rst_n = 1;
  end
 
  initial begin
    eth_if_i.in_ready = 1;
    begin
      uvm_component c;
      c = uvm_root::get();
      c.set_report_id_action_hier("ILLEGALNAME",UVM_NO_ACTION);
    end
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual eth_if)::set(null, "*eth*", "vif", eth_if_i);
    // Start the test
    run_test("tc_basic");
  end
  
endmodule
