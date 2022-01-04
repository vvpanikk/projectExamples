class eth_env extends uvm_env;
  `uvm_component_utils(eth_env)
  
  eth_agent  agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = eth_agent::type_id::create("agent", this);

  endfunction

  //function void connect_phase(uvm_phase phase);
  //  agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  //endfunction
endclass
