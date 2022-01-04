// The agent contains sequencer, driver, and monitor
class eth_agent extends uvm_agent;

  eth_agent_config cfg;

  eth_driver    driver;
  eth_monitor   monitor;
  eth_sequencer sequencer;

  `uvm_component_utils_begin(eth_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(eth_agent_config)::get(this, "", "cfg", cfg))
      `uvm_error("NOCFG", {"config not found", get_full_name(), ".cfg"})

    if(cfg.is_active == UVM_ACTIVE) begin
      driver    = eth_driver   ::type_id::create("driver", this);
      sequencer = eth_sequencer::type_id::create("sequencer", this);
    end
    monitor = eth_monitor::type_id::create("monitor", this);
  endfunction    
  
  // In UVM connect phase, we connect the sequencer to the driver.
  function void connect_phase(uvm_phase phase);
    if(cfg.is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass
