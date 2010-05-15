###################################################################

# Created by write_sdc on Tue Jun 24 15:11:14 2008

###################################################################
#set sdc_version 1.7

#set_operating_conditions WCCOM -library fsa0a_c_sc_wc
#set_wire_load_mode top
#set_wire_load_model -name enG500K -library fsa0a_c_sc_wc
set_max_fanout 16 [current_design]
set_max_transition 1.2 [current_design]
#set_ideal_network [get_ports POR]
#set_ideal_network [get_ports hresetn]
create_clock [get_ports hclk]  -period 50  -waveform {0 25}
set_clock_latency 5  [get_clocks hclk]
