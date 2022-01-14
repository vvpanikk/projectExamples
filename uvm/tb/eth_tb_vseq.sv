class eth_tb_base_vseq extends uvm_sequence;
   `uvm_object_utils(eth_tb_base_vseq)
   `uvm_declare_p_sequencer(eth_tb_vsequencer)

   function new(string name="eth_tb_base_vseq");
      super.new(name);
   endfunction

endclass


class simple_bringup_vseq extends eth_tb_base_vseq;
   `uvm_object_utils(simple_bringup_vseq)

   function new(string name="eth_tb_base_vseq");
      super.new(name);
   endfunction

   eth_reg_wr_seq          reg_wr_seq;
   eth_pass_through_seq    pt_seq;
   virtual task body();
      //no license for randomization `uvm_do_on(reg_wr_seq, p_sequencer.eth_seqr)
      //`uvm_create_on(reg_wr_seq, p_sequencer.eth_seqr)
      //`uvm_send(reg_wr_seq)
      `uvm_create_on(pt_seq, p_sequencer.eth_seqr)
      `uvm_send(pt_seq)
      //`uvm_do_on(p_sequencer.eth_seqr)
      #100;
   endtask
endclass
