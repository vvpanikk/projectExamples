class eth_trans extends uvm_sequence_item;

  rand byte        packet_type            ;
  rand byte        transaction_id      [] ;
  rand byte        padding             [] ;
  rand byte        pt_message_type        ;
  rand byte        pt_connection_id       ;
  rand byte        pt_checksum            ;
  rand byte        reg_mode               ;
  rand byte        pt_data             [] ;
  rand bit[31:0]   reg_addr            [] ;
  rand bit[31:0]   reg_data            [] ;

  bit [63:0] packed_bytes[];

  `uvm_object_utils_begin(eth_trans)    
    `uvm_field_int( packet_type      , UVM_ALL_ON)
    `uvm_field_int( pt_message_type  , UVM_ALL_ON)
    `uvm_field_int( pt_connection_id , UVM_ALL_ON)
    `uvm_field_int( pt_checksum      , UVM_ALL_ON)
    `uvm_field_int( reg_mode         , UVM_ALL_ON)
    `uvm_field_array_int( transaction_id   , UVM_ALL_ON)
    `uvm_field_array_int( padding          , UVM_ALL_ON)
    `uvm_field_array_int( pt_data          , UVM_ALL_ON)
    `uvm_field_array_int( reg_addr         , UVM_ALL_ON)
    `uvm_field_array_int( reg_data         , UVM_ALL_ON)
  `uvm_object_utils_end
 
  constraint c_packet_type    { packet_type inside {[0:1]};} 
  constraint c_transaction_id { packet_type == 0 -> transaction_id.size()==4;
                                packet_type == 1 -> transaction_id.size()==2;
                              }
  constraint c_pt_message_type { pt_message_type inside {0,1}; }
  constraint c_padding { packet_type == 0 -> padding.size()==12;
                         packet_type == 1 -> padding.size()==2;
                         foreach(padding[ii]) padding[ii] == 8'b0;
  }

  constraint c_reg_mode { reg_mode inside {0,1}; }
  constraint c_pt_data  { pt_data.size() >= 128 && pt_data.size() < 1017; }
  constraint c_reg_addr { reg_mode == 1 -> reg_addr.size() == 1;
                          reg_mode == 0 -> reg_addr.size() == reg_data.size();}
  constraint c_reg_data { reg_data.size() > 1 && reg_data.size() < 30; }

  constraint c_conn_id { pt_connection_id dist {1:=5, [10:12]:/5};} 
  function new (string name = "");
    super.new(name);
  endfunction
  
  function void do_pack(uvm_packer packer) ;
    super.do_pack(packer);
    if (packet_type == 1) begin
       packer.pack_field_int(packet_type, $bits(packet_type));
       foreach(transaction_id[i])
          packer.pack_field_int(transaction_id[i], 8);
       packer.pack_field_int(pt_message_type, $bits(pt_message_type));
       packer.pack_field_int(pt_connection_id, $bits(pt_connection_id));
       packer.pack_field_int(pt_checksum, $bits(pt_checksum));
       foreach(padding[i])
          packer.pack_field_int(padding[i], 8);
       foreach(pt_data[i])
          packer.pack_field_int(pt_data[i], 8);
       //packer.pack_bytes(padding);
       //packer.pack_bytes(pt_data);
    end
    else if (packet_type == 0) begin
       packer.pack_field_int(packet_type, $bits(packet_type));
       //packer.pack_bytes(transaction_id);
       foreach(transaction_id[i])
          packer.pack_field_int(transaction_id[i], 8);
       packer.pack_field_int(reg_mode, $bits(reg_mode));
       foreach(padding[i])
          packer.pack_field_int(padding[i], 8);
       //packer.pack_bytes(padding);
       if (reg_mode == 0) begin
         foreach(reg_data[i]) 
            packer.pack_field_int({reg_addr[i], reg_data[i]}, 64);
       end
       else if (reg_mode == 1) begin
         packer.pack_field_int(reg_addr[0], 32);
         foreach(reg_data[i])
            packer.pack_field_int(reg_data[i], 8);
         //packer.pack_bytes(reg_data);
       end
    end 
 endfunction  

 function void do_unpack(uvm_packer packer) ;
    super.do_unpack(packer);
    packet_type = packer.unpack_field_int(8);
    if (packet_type == 0) begin
       transaction_id = new[4];
       foreach(transaction_id[i])
          transaction_id[i] = packer.unpack_field_int( 8);
       //packer.unpack_bytes(transaction_id);

       pt_message_type  = packer.unpack_field_int( 8);
       pt_connection_id = packer.unpack_field_int( 8);
       pt_checksum      = packer.unpack_field_int( 8);

       padding = new[12];
       foreach(padding[i])
          padding[i] = packer.unpack_field_int( 8);
       //packer.unpack_bytes(padding);

       pt_data = new[2];
       foreach(pt_data[i])
          pt_data[i] = packer.unpack_field_int( 8);
       //packer.pack_bytes(pt_data);
    end
    else if (packet_type == 1) begin
       transaction_id = new[2];
       foreach(transaction_id[i])
          transaction_id[i] = packer.unpack_field_int( 8);
       //packer.unpack_bytes(transaction_id);

       reg_mode  = packer.unpack_field_int( 8);

       padding = new[2];
       foreach(padding[i])
          padding[i] = packer.unpack_field_int( 8);
       //packer.unpack_bytes(padding);

       if (reg_mode == 0) begin
         bit [63:0] addr_data[];
         addr_data = new[2];
         foreach(addr_data[i])
            addr_data[i] = packer.unpack_field_int(8);
         //packer.unpack_ints(addr_data);
         reg_addr = new[addr_data.size()];
         reg_data = new[addr_data.size()];
         foreach (addr_data[i]) begin
            reg_addr[i] = addr_data[i][63:32];
            reg_data[i] = addr_data[i][31:0];
         end
       end
       else if (reg_mode == 1) begin
         reg_addr = new[1];
         reg_addr[0] = packer.unpack_field_int(8);
         reg_addr = new[2];
         foreach(reg_data[i])
            reg_data[i] = packer.unpack_field_int(8);
         //packer.unpack_ints(reg_addr);
         //packer.unpack_ints(reg_data);
       end
    end 
 endfunction  
 
// function void post_randomize() ;
//
//    if (packet_type == 1)
//      packed_bytes = {>>64{packet_type, transaction_id,  pt_message_type, pt_connection_id, pt_checksum, padding,  pt_data}} ;
//    else if (packet_type == 0) begin
//      if (reg_mode == 0) begin
//         foreach(reg_data[i]) begin
//            packed_bytes = {>>64{packed_bytes, reg_addr[i], reg_data[i]}};
//         end
//      end
//      else if (reg_mode == 1) begin
//         packed_bytes = {>>64{reg_addr, reg_data}};
//      end
//      packed_bytes = {>>64{packet_type, transaction_id,  padding,  packed_bytes}} ;
//    end 
// endfunction 
endclass: eth_trans
