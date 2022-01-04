class eth_monitor extends uvm_monitor;
 
  // Virtual Interface
  virtual eth_if vif;
 
  uvm_analysis_port #(eth_trans) analysis_port;
 
  //// Placeholder to capture transaction information.
  //my_transaction trans_collected;
 
  `uvm_component_utils(eth_monitor)
 
  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual eth_if)::get(this, "", "vif", vif)) 
       `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
 
  // run phase
  logic [63:0] in_data[];
  bit in_data_bits[];
  eth_trans trans;
  uvm_packer packer;
  int num_bits;

  virtual task run_phase(uvm_phase phase);
    forever begin      
      @(posedge vif.clk);   
      while(vif.in_ready && vif.in_valid) begin
        if (vif.in_startofpayload == 1)
          in_data = new[1];
        else
          in_data = new[in_data.size()+1](in_data);

        in_data[in_data.size()-1] = vif.in_data;
        if (vif.in_endofpayload == 1)
           break;
        @(posedge vif.clk);   
      end

      trans = eth_trans::type_id::create("trans", this);
      packer = new;
      in_data_bits = {>>{in_data}};
      num_bits = trans.unpack(in_data_bits, packer);

      `uvm_info("ENV", $sformatf("%s seq item \n:%s", get_full_name(), trans.sprint()), UVM_NONE)
      analysis_port.write(trans);
   end
   
  endtask : run_phase
 
endclass : eth_monitor
