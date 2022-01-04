// This is the SystemVerilog interface that we will use to connect
// our design to our UVM testbench.
interface dut_if;
  logic clk;
  logic reset_n;
  logic in_valid;
  logic in_startofpayload;
  logic in_endofpayload;
  logic in_ready;
  logic [63:0] in_data;
  logic [2:0] in_empty;
  logic in_error;
endinterface

`include "uvm_macros.svh"

// This is our design module.
// 
// the clock toggles.
module dut(dut_if dif);
  import uvm_pkg::*;
  int status; 
  int rdy_prob=75;
  assign status = $value$plusargs("rdy_prob=%d",rdy_prob);
  always @(posedge dif.clk) begin 
    dif.in_ready = $random()%100<rdy_prob;
    if (dif.reset_n != 1 && dif.in_valid && dif.in_ready) begin
      `uvm_info("DUT", $sformatf("Received data=0x%h", dif.in_data), UVM_MEDIUM);
    end
  end
endmodule
