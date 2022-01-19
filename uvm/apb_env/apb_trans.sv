typedef enum bit {APB_READ, APB_WRITE} apb_trans_type_t;

class apb_trans extends uvm_sequence_item;

  rand bit[31:0]   addr ;
  rand bit[31:0]   data ;
  rand bit         wr_en;
  rand apb_trans_type_t trans;

  `uvm_object_utils_begin(apb_trans)    
    `uvm_field_int( addr  , UVM_ALL_ON)
    `uvm_field_int( data  , UVM_ALL_ON)
    `uvm_field_int( wr_en , UVM_ALL_ON)
    `uvm_field_enum( apb_trans_type_t, trans, UVM_ALL_ON)
  `uvm_object_utils_end
 
  function new (string name = "");
    super.new(name);
  endfunction
  
endclass: apb_trans
