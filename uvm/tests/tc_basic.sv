class tc_basic extends uvm_test;
  `uvm_component_utils(tc_basic)
  
    eth_tb env;
    eth_tb_vsequencer vseqr;

//  my_sequence seq;
//  int num_pkts=10;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    //int status;
    //status = $value$plusargs("num_pkts=%d",num_pkts);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    env = eth_tb::type_id::create("env", this);
    vseqr = eth_tb_vsequencer::type_id::create("vseqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    vseqr.eth_seqr = env.eth_primary.agent.sequencer;
  endfunction
  
  simple_bringup_vseq bringup_seq;

  task run_phase(uvm_phase phase);
    // We raise objection to keep the test from completing      
    phase.raise_objection(this);

    bringup_seq = simple_bringup_vseq::type_id::create("bringup_seq", this);

    `uvm_info("TEST",$sformatf("Starting tc_basic"), UVM_NONE)
    #100ns;
    bringup_seq.start(vseqr);
    `uvm_info("TEST",$sformatf("Ending tc_basic"), UVM_NONE)
    //seq = my_sequence::type_id::create("seq");
    //seq.m_packet_type=REGISTER_UPDATE; // 
    //seq.m_message_type=-1;
    //seq.m_mode=NORMAL;
    //seq.m_packet_len=8;
    //seq.start(env.agent.sequencer);           
    //`uvm_info("TEST",$sformatf("Done with Packet 1 REGISTER_UPDATE NORMAL"), UVM_NONE)
    //`uvm_info("TEST",$sformatf("Starting Packet 2 REGISTER_UPDATE BURST"), UVM_NONE)
    //#100ns;
    //seq = my_sequence::type_id::create("seq");
    //seq.m_packet_type=REGISTER_UPDATE; // 
    //seq.m_message_type=-1;
    //seq.m_mode=BURST;
    //seq.m_packet_len=8;
    //seq.start(env.agent.sequencer);           
    //`uvm_info("TEST",$sformatf("Done with  Packet 2 REGISTER_UPDATE BURST"), UVM_NONE)             
    
    // We drop objection to allow the test to complete
    phase.drop_objection(this);
  endtask
endclass
