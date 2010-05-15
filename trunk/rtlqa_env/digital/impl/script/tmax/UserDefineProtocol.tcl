 add_clocks 0 Clk -timing {100 45 55 40} -shift
 add_pi_constraint 0 Reset
 add_pi_constraint 1 Test_Mode
 add_scan_enable 1 Test_Se
 add_scan_chain c0 Test_Si Test_So

