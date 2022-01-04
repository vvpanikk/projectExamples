// This is the SystemVerilog interface that we will use to connect
// our design to our UVM testbench.
interface eth_if(input clk);
  logic rst_n;
  logic in_valid;
  logic in_startofpayload;
  logic in_endofpayload;
  logic in_ready;
  logic [63:0] in_data;
  logic [2:0] in_empty;
  logic in_error;
endinterface


