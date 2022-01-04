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
       `uvm_do_with(req, {req.packet_type == 1;
                          req.reg_data.size() == num_reg_wr; 
                          req.reg_mode == reg_mode;})
    endtask
    
endclass


class eth_pass_through_seq extends uvm_sequence#(eth_trans);

    `uvm_object_utils(eth_pass_through_seq)

    virtual task body();
       `uvm_info("BSEQ", {get_full_name(), " starting"},UVM_NONE) 
       `uvm_do_with(req, {req.packet_type == 0;})
    endtask
endclass
