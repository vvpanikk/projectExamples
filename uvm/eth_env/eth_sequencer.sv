class eth_sequencer extends uvm_sequencer#(eth_trans);
    `uvm_component_utils(eth_sequencer)
    function new(string name, uvm_component parent);
         super.new(name, parent);
    endfunction
endclass
