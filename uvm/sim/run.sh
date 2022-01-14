#!/usr/bin/sh
vsim -c -classdebug -msgmode both -uvmcontrol=all tb_eth -voptargs="+acc" -onfinish stop -do "source wave_dump.do" +UVM_VERBOSITY=UVM_HIGH | tee sim.log
