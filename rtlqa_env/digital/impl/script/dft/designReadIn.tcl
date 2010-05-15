#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designReadIn.tcl
#
#      DESCRIPTION:
#         This script is used to read in the designs in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { $ReadFileFormat == "ddc" } {

	if { $runDFTstage == "syn" } {
		read_ddc $synWorkPath/ddc/current/$topModuleName.ddc
		current_design $topModuleName
		link
	} elseif { $runDFTstage == "bsd" } {
		read_ddc $bsdWorkPath/ddc/current/$topModuleName.ddc
		current_design $topModuleName
		link
	}
} elseif { $ReadFileFormat == "netlist" } {
	if { $runDFTstage == "syn" } { 
		read_verilog -netlist $synWorkPath/net/current/$topModuleName.v
		current_design $topModuleName
		link
	} elseif { $runDFTstage == "bsd" } {
		read_verilog -netlist $bsdWorkPath/net/current/$topModuleName.v
		current_design $topModuleName
		link
	}
} else {
echo "No files are reading in, var ReadFileFormat is not correctly specified!"
}

