class eth_reg_wr_seq extends uvm_sequence#(eth_trans);
    rand int num_reg_wr;
    rand bit reg_mode;

    `uvm_object_utils_begin(eth_reg_wr_seq)
       `uvm_field_int(num_reg_wr, UVM_ALL_ON)
       `uvm_field_int(reg_mode, UVM_ALL_ON)
    `uvm_object_utils_end
   constraint c_num_reg_wr { num_reg_wr > 1 && num_reg_wr < 30; }

    virtual task body();
       `uvm_info("BSEQ", {get_full_name(), " starting"},UVM_NONE) 
       //no license for randomization `uvm_do_on(reg_wr_seq, p_sequencer.eth_seqr)
       //`uvm_do_with(req, {req.packet_type == 1;
       //                   req.reg_data.size() == num_reg_wr; 
       //                   req.reg_mode == reg_mode;})
       `uvm_create(req)
       req.packet_type = 1;
       req.transaction_id = new[2];
       req.reg_addr = new[10];
       req.reg_data = new[10];
       req.padding = new[4];
       req.reg_mode = 1;
       foreach(req.padding[i]) req.padding[i] = 'h5;
       for(int i = 0; i < req.transaction_id.size(); i++) begin
          req.transaction_id[i] = 'hAA+i;
       end
       for(int i = 0; i < req.reg_data.size(); i++) begin
          req.reg_addr[i] = i+1;
          req.reg_data[i] = i+1;
       end
       `uvm_send(req)
    endtask
    
endclass


class eth_pass_through_seq extends uvm_sequence#(eth_trans);

    `uvm_object_utils(eth_pass_through_seq)

    virtual task body();
       `uvm_info("BSEQ", {get_full_name(), " starting"},UVM_NONE) 
       //`uvm_do_with(req, {req.packet_type == 0;})
       `uvm_create(req)
       req.packet_type = 0;
       req.transaction_id = new[4];
       req.padding = new[12];
       foreach(req.padding[i]) req.padding[i] = 'h5;
       for(int i = 0; i < req.transaction_id.size(); i++) begin
          req.transaction_id[i] = 'hAA+i;
       end
       req.pt_message_type = 'hF1;
       req.pt_connection_id = 'hF2;
       req.pt_checksum = 'hF3;
       req.pt_data = new[32];
       for(int i = 0; i < req.pt_data.size(); i++) begin
          req.pt_data[i] = i+1;
          req.reg_data[i] = i+1;
       end
       `uvm_send(req)
    endtask
endclass
