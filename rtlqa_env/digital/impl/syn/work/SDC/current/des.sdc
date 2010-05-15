###################################################################

# Created by write_sdc on Fri Sep 18 12:13:22 2009

###################################################################
set sdc_version 1.7

set_operating_conditions WCCOM -library fsa0a_c_sc_wc
set_wire_load_mode top
set_wire_load_model -name enG500K -library fsa0a_c_sc_wc
set_max_fanout 16 [current_design]
set_max_transition 1.2 [current_design]
set_ideal_network [get_ports POR]
set_ideal_network [get_ports hresetn]
create_clock [get_ports hclk]  -period 50  -waveform {0 25}
set_clock_latency 5  [get_clocks hclk]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports POR]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports hresetn]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports hsel]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[31]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[30]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[29]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[28]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[27]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[26]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[25]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[24]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[23]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[22]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[21]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[20]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[19]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[18]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[17]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[16]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[15]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[14]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[13]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[12]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[11]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[10]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[9]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[8]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[7]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[6]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[5]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[4]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[3]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[2]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[1]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hwdata[0]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[9]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[8]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[7]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[6]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[5]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[4]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[3]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[2]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[1]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {haddr[0]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports hwrite]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {htrans[1]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {htrans[0]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hsize[2]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hsize[1]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hsize[0]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hburst[2]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hburst[1]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hburst[0]}]
set_input_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports hready]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports hready_resp]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hresp[1]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hresp[0]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[31]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[30]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[29]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[28]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[27]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[26]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[25]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[24]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[23]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[22]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[21]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[20]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[19]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[18]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[17]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[16]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[15]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[14]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[13]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[12]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[11]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[10]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[9]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[8]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[7]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[6]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[5]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[4]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[3]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[2]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[1]}]
set_output_delay -clock hclk  25  -network_latency_included  -source_latency_included  [get_ports {hrdata[0]}]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_obs/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_obs/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_obs/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_obs/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
POWERGATING_hclk_N26_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
POWERGATING_hclk_N26_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
POWERGATING_hclk_N26_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
POWERGATING_hclk_N26_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
des_cop_unit/des_unit/u_tiny_des_round/clk_gate_obs/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
des_cop_unit/des_unit/u_tiny_des_round/clk_gate_obs/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
des_cop_unit/des_unit/u_tiny_des_round/clk_gate_obs/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
des_cop_unit/des_unit/u_tiny_des_round/clk_gate_obs/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
des_cop_unit/des_unit/u_tiny_des_round/POWERGATING_hclk_N1778_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
des_cop_unit/des_unit/u_tiny_des_round/POWERGATING_hclk_N1778_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
des_cop_unit/des_unit/u_tiny_des_round/POWERGATING_hclk_N1778_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
des_cop_unit/des_unit/u_tiny_des_round/POWERGATING_hclk_N1778_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desdat_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desdat_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desdat_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desdat_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desdat_unit/POWERGATING_hclk_N70_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desdat_unit/POWERGATING_hclk_N70_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desdat_unit/POWERGATING_hclk_N70_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desdat_unit/POWERGATING_hclk_N70_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desdat_unit/POWERGATING_hclk_N134_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desdat_unit/POWERGATING_hclk_N134_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desdat_unit/POWERGATING_hclk_N134_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desdat_unit/POWERGATING_hclk_N134_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desiv_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desiv_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desiv_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desiv_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desiv_unit/POWERGATING_hclk_N66_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desiv_unit/POWERGATING_hclk_N66_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desiv_unit/POWERGATING_hclk_N66_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desiv_unit/POWERGATING_hclk_N66_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
desiv_unit/POWERGATING_hclk_N130_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
desiv_unit/POWERGATING_hclk_N130_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
desiv_unit/POWERGATING_hclk_N130_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
desiv_unit/POWERGATING_hclk_N130_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/clk_gate_obs/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/clk_gate_obs/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N83_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N83_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N83_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N83_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N115_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N115_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N115_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N115_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N147_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N147_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N147_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N147_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N179_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N179_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N179_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N179_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N211_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N211_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N211_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N211_0/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N243_0/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
deskey_unit/POWERGATING_hclk_N243_0/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N243_0/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
deskey_unit/POWERGATING_hclk_N243_0/main_gate]
