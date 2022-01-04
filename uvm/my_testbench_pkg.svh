package my_testbench_pkg;
  import uvm_pkg::*;

  // C functions
  import "DPI-C" context function void set_model_packed_bytes(bit [7:0] a[]);
  //import "DPI-C" context function void get_model_output(bit [7:0] a[]);

  //enums can be added in a separate file but since its just a few of them easier to refer in the same file
  typedef enum {MESSAGE_PASSTHROUGH=0, REGISTER_UPDATE=1} e_packet_type;
  typedef enum {MASS_QUOTE=0, HEARTBEAT=1} e_message_type;
  typedef enum {NORMAL=0, BURST=1} e_mode;

  // The UVM sequence, transaction item, and driver are in these files:
  `include "my_transaction.svh"
  `include "my_sequence.svh"
  `include "my_driver.svh"
  `include "my_monitor.svh"
  `include "my_scoreboard.svh"
  `include "my_agent.svh"
  `include "my_env.svh"
  `include "my_test.svh"

endpackage