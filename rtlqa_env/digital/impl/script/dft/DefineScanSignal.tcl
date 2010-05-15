#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      DefineScanSignal.tcl
#
#      DESCRIPTION:
#         This script is used to setup scan signals in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

# Define DFT Clock
set_dft_signal -view exist -type ScanClock -timing {45 55} -port [get_ports hclk] 

# Define DFT Reset if the reset signal is async

# Define DFT Scan Enable
# Note: if the scan enable is used to connect the test pin of CG, 
# The exist view is also needed to pass drc check
create_port -direction "in" {Test_Se}
set_dft_signal -view spec -type ScanEnable -port Test_Se 

# Define this variable for subsequent set_ideal_network $DFTScanEnable
set DFTScanEnable [list]
set DFTScanEnable "Test_Se"

# Define DFT Scan In
create_port -direction "in"  {si0 si1 si2 si3}
set_dft_signal -view spec  -type ScanDataIn -port si0 
set_dft_signal -view spec  -type ScanDataIn -port si1 
set_dft_signal -view spec  -type ScanDataIn -port si2 
set_dft_signal -view spec  -type ScanDataIn -port si3 

# Define DFT Scan Out
create_port -direction "out"  {so0 so1 so2 so3}
set_dft_signal -view spec -type ScanDataOut -port so0
set_dft_signal -view spec -type ScanDataOut -port so1
set_dft_signal -view spec -type ScanDataOut -port so2 
set_dft_signal -view spec -type ScanDataOut -port so3 

# Define Scan Connection

set_scan_path -view spec -scan_data_in si0 -scan_data_out so0 chain_1
set_scan_path -view spec -scan_data_in si1 -scan_data_out so1 chain_2
set_scan_path -view spec -scan_data_in si2 -scan_data_out so2 chain_3
set_scan_path -view spec -scan_data_in si3 -scan_data_out so3 chain_4

# Define DFT Test Mode
create_port -direction "in"  {Test_Mode}
set_dft_signal -view exist -type Constant -port Test_Mode -active 1
#set_dft_signal -view exist -type TestMode -port Comp_Mode -active 1 

# Define DFT Autofix Signals
# The definitions are in Autofix.tcl

