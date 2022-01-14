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
    byte unsigned   in_data_bits[];
    uvm_packer eth_packer ;

    vif.cb_drv.in_valid <= 0;
    //// Now drive normal traffic
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("ENV", $sformatf("%s seq item \n:%s", get_full_name(), req.sprint()), UVM_MEDIUM)

      i = 1;
      in_data_bits.delete;
      eth_packer = new;
      //- also unless you want to override the packer fields you don't 
      //  need to pass it as an argument
      //
      //default seems to be big endian
      //eth_packer.big_endian = 0;
      num_bits = req.pack_bytes(in_data_bits, eth_packer);
      in_data = {>>{in_data_bits}}; 
      foreach (in_data[j])
         `uvm_info("ENV", $sformatf("packed word:%h", in_data[j]), UVM_HIGH)

      @(vif.cb_drv);   
      //for clocking blocks we need to use non-blocking assignments
      vif.cb_drv.in_endofpayload <= 0;
      vif.cb_drv.in_data  <= in_data[0];
      vif.cb_drv.in_startofpayload <= 1;
      vif.cb_drv.in_valid <= 1;      

      while (i < in_data.size()) begin
         do begin
            @(vif.cb_drv);   
         end while(!vif.cb_drv.in_ready);

         vif.cb_drv.in_data  <= in_data[i];
         vif.cb_drv.in_startofpayload <= 0;
         vif.cb_drv.in_valid <= 1;      

         if (i == in_data.size() - 1)
            vif.cb_drv.in_endofpayload <= 1;
         i++;
      end

      @(vif.cb_drv);   
      vif.cb_drv.in_valid <= 0;      
      vif.cb_drv.in_endofpayload <= 0;
      seq_item_port.item_done();
    end
  endtask

endclass: eth_driver
