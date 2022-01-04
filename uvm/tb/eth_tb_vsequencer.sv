import eth_pkg::*;

class eth_tb_vsequencer extends uvm_sequencer;
   `uvm_component_utils(eth_tb_vsequencer)

   eth_sequencer eth_seqr;

   function new(string name, uvm_component parent);
       super.new(name, parent);
   endfunction 
endclass
