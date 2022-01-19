import eth_pkg::*;
class eth_tb extends uvm_env;
  `uvm_component_utils(eth_tb)
  
  eth_agent_config eth_pri_cfg;
  eth_agent_config eth_sec_cfg;

  eth_env  eth_primary;
  eth_env  eth_secondary;

  eth_tb_ref_model  ref_model;
  eth_tb_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    eth_pri_cfg = eth_agent_config::type_id::create("eth_pri_cfg", this);
    eth_sec_cfg = eth_agent_config::type_id::create("eth_sec_cfg", this);
    eth_pri_cfg.is_active = UVM_ACTIVE;
    eth_sec_cfg.is_active = UVM_PASSIVE;
    eth_pri_cfg.agent_type = PRIMARY;
    eth_sec_cfg.agent_type = SECONDARY;
    uvm_config_db#(eth_agent_config)::set(this, "*eth_primary*", "cfg", eth_pri_cfg );
    uvm_config_db#(eth_agent_config)::set(this, "*eth_secondary*", "cfg", eth_sec_cfg );

    eth_primary    = eth_env::type_id::create("eth_primary", this);
    //eth_secondary  = eth_env::type_id::create("eth_secondary" , this);

    sb = eth_tb_scoreboard::type_id::create("sb", this);
    ref_model = eth_tb_ref_model::type_id::create("ref_model", this);
  endfunction

  function void connect_phase(uvm_phase phase);
     eth_primary.agent.monitor.analysis_port.connect(sb.act_eth_in_export);
     eth_primary.agent.monitor.analysis_port.connect(ref_model.eth_in_analysis_export);
    
     ref_model.apb_out_analysis_port.connect(sb.exp_apb_out_export);

  endfunction

endclass
