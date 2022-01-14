onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_eth/eth_if_i/rst_n
add wave -noupdate /tb_eth/eth_if_i/in_valid
add wave -noupdate /tb_eth/eth_if_i/in_startofpayload
add wave -noupdate /tb_eth/eth_if_i/in_ready
add wave -noupdate /tb_eth/eth_if_i/in_error
add wave -noupdate /tb_eth/eth_if_i/in_endofpayload
add wave -noupdate /tb_eth/eth_if_i/in_empty
add wave -noupdate /tb_eth/eth_if_i/in_data
add wave -noupdate /tb_eth/eth_if_i/clk
add wave -noupdate /tb_eth/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {165 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {101 ns} {120 ns}
