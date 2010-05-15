#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      DefineScanConfig.tcl
#
#      DESCRIPTION:
#         This script is used to setup scan configrations in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#set_scan_configuration -add_lockup true
#set_scan_configuration -bidi_mode input
#set_scan_configuration -chain_count 1
#set_scan_configuration -clock_mixing mix_clocks
#set_scan_configuration -dedicated_scan_ports true
#set_scan_configuration -disable true
#set_scan_configuration -hierarchical_isolation true
#set_scan_configuration -internal_clocks false
#set_scan_configuration -internal_tri disable_all
#set_scan_configuration -methodology full_scan
#set_scan_configuration -rebalance true
#set_scan_configuration -route true
#set_scan_configuration -route_signals all
#set_scan_configuration -style multiplexed_flip_flop
#set_scan_configuration -insert_end_of_chain_lockup_latch true
set_scan_configuration  -clock_mixing mix_clocks
set_scan_configuration  -chain_count $ScanChainNum
set_scan_configuration  -add_lockup true
set_scan_configuration  -insert_terminal_lockup true
set_scan_configuration  -create_dedicated_scan_out_ports true

if {$ScanCompression == "true"} {
	set_dft_configuration -scan_compression enable
	set_scan_compression_configuration -minimum_compression $ScanCompRate
}

# New version DFTC does not support shadow_wrapper
#set_dft_configuration -shadow_wrapper
#set_wrapper_element I_RISC_CORE/I_MULT_STORE/I_RAM -type shadow
#set_port_configuration -cell sp256x16 -clock Clk -port Q
#set_port_configuration -cell sp256x16 -clock Clk -port D

