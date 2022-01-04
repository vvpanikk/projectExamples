vsim -classdebug -msgmode both -uvmcontrol=all tb_eth -voptargs="+acc" -onfinish stop -do "source wave_dump.do"
