typedef enum {PRIMARY, SECONDARY} agent_type_enum;

class eth_agent_config extends uvm_object;
   `uvm_object_utils(eth_agent_config)

   agent_type_enum agent_type;
   uvm_active_passive_enum is_active;
endclass
