#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designOutput.tcl
#
#      DESCRIPTION:
#         This script is used to write data in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

source -echo -verbose $synConstraintPath/namRule.tcl

change_names -rule verilog -hier

write -f ddc -hier -o $workPath/ddc/current/$topModuleName.ddc
write -f verilog -hier -o $workPath/net/current/$topModuleName.v
write_parasitics -output $workPath/SPEF/current/${topModuleName}.spef


write_test_protocol  -output $workPath/spf/current/$topModuleName.spf -test_mode Internal_scan

if { $ScanCompression == "true"} {
	write_test_protocol  -output $workPath/spf/current/$topModuleName.comp.spf -test_mode ScanCompression_mode
}

redirect [file join $workPath/net/current/$topModuleName.lst] {
	echo "$topModuleName.v"
}
