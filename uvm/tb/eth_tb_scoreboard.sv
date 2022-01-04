import eth_pkg::*;
class eth_tb_scoreboard extends uvm_scoreboard;
 
  `uvm_component_utils(eth_tb_scoreboard)

  uvm_analysis_imp#(eth_trans, eth_tb_scoreboard) primary_analysis_export;

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    primary_analysis_export = new("primary_analysis_export", this);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase
  
  virtual function void write(eth_trans pkt);
    `uvm_info("SCB",$sformatf("Packet Received"), UVM_NONE)
  endfunction : write
 
endclass: eth_tb_scoreboard
