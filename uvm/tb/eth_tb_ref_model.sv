import eth_pkg::*;
import apb_pkg::*;

class eth_tb_ref_model extends uvm_component;

   `uvm_component_utils(eth_tb_ref_model)

   uvm_analysis_imp  #(eth_trans, eth_tb_ref_model) eth_in_analysis_export;
   uvm_analysis_port #(apb_trans) apb_out_analysis_port ;

   function new(string name, uvm_component parent);
      super.new(name, parent);
      eth_in_analysis_export = new("eth_in_analysis_export", this);
      apb_out_analysis_port  = new("apb_out_analysis_port ", this);
   endfunction

   function void write(uvm_object trans);
      logic [31:0] start_addr;

      eth_trans eth;
      apb_trans apb;
      $cast(eth, trans.clone());

      if (eth.packet_type == 1) begin
         if (eth.reg_mode == 0) begin
            foreach(eth.reg_addr[i]) begin
               apb = apb_trans::type_id::create("apb_trans");
               apb.trans = APB_WRITE;
               apb.addr = eth.reg_addr[i];
               apb.data = eth.reg_data[i];
               apb_out_analysis_port.write(apb);
            end
         end
         else if (eth.reg_mode == 1) begin
            start_addr = eth.reg_addr[0];
            foreach(eth.reg_data[i]) begin
               apb = apb_trans::type_id::create("apb_trans");
               apb.trans = APB_WRITE;
               apb.addr = start_addr + i*4;
               apb.data = eth.reg_data[i];
               apb_out_analysis_port.write(apb);
            end

         end

      end
   endfunction
endclass
