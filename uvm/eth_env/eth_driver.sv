class eth_driver extends uvm_driver #(eth_trans);

  `uvm_component_utils(eth_driver)

  virtual eth_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual eth_if)::get(this, "", "vif", vif)) begin
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    end
  endfunction 

 
  task run_phase(uvm_phase phase);
    int          i = 0;
    int          num_bits;
    logic [63:0] in_data[];
    bit          in_data_bits[];
    uvm_packer eth_packer ;
    //// Now drive normal traffic
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("ENV", $sformatf("%s seq item \n:%s", get_full_name(), req.sprint()), UVM_NONE)

      i = 0;
      in_data_bits.delete();
      eth_packer = new;
      num_bits = req.pack(in_data_bits, eth_packer);
      in_data = {>>{in_data_bits}}; 

      @(posedge vif.clk);   
      vif.in_endofpayload = 0;
      vif.in_data  = in_data[0];
      vif.in_startofpayload = 1;
      vif.in_valid = 1;      

      while (i < in_data.size()) begin
         do begin
            @(posedge vif.clk);   
         end while(!vif.in_ready);

         vif.in_data  = in_data[i];
         vif.in_startofpayload = 0;
         vif.in_valid = 1;      

         if (i == in_data.size() - 1)
            vif.in_endofpayload = 1;
         i++;
      end
      seq_item_port.item_done();
    end
  endtask

endclass: eth_driver
