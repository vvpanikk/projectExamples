import eth_pkg::*;
import apb_pkg::*;

`uvm_analysis_imp_decl(_act_eth_in)
`uvm_analysis_imp_decl(_exp_apb_out)

class eth_tb_scoreboard extends uvm_scoreboard;
 
  `uvm_component_utils(eth_tb_scoreboard)

  uvm_analysis_imp_act_eth_in#(eth_trans, eth_tb_scoreboard) act_eth_in_export;
  uvm_analysis_imp_exp_apb_out#(apb_trans, eth_tb_scoreboard) exp_apb_out_export;

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    act_eth_in_export = new("act_eth_in_export", this);
    exp_apb_out_export = new("exp_apb_out_export", this);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase
  
  virtual function void write_act_eth_in(eth_trans pkt);
    `uvm_info("SCB",$sformatf("ETH Packet Received %s", pkt.sprint()), UVM_NONE)
  endfunction : write_act_eth_in

  virtual function void write_exp_apb_out(apb_trans pkt);
    `uvm_info("SCB",$sformatf("APB Packet Received %s", pkt.sprint()), UVM_NONE)
  endfunction : write_exp_apb_out
  
endclass: eth_tb_scoreboard
