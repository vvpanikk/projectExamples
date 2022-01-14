// This is the SystemVerilog interface that we will use to connect
// our design to our UVM testbench.
interface eth_if(input clk, input rst_n);
  logic in_valid;
  logic in_startofpayload;
  logic in_endofpayload;
  logic in_ready;
  logic [63:0] in_data;
  logic [2:0] in_empty;
  logic in_error;

  clocking cb_drv @(posedge clk);
     default input #1 output #2;
     input   in_ready;
     output  in_valid;
     output  in_startofpayload;
     output  in_endofpayload;
     output  in_data;
     output  in_empty;
     output  in_error;
  endclocking

  clocking cb_mon @(posedge clk);
     default input #1;
     input  in_valid;
     input  in_ready;
     input  in_startofpayload;
     input  in_endofpayload;
     input  in_data;
     input  in_empty;
     input  in_error;
  endclocking

endinterface


