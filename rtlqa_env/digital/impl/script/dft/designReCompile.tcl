current_design $topModuleName

set compile_no_new_cells_at_top_level true
set_fix_multiple_port_nets -all

set_ideal_network [get_ports $DFTScanEnable]


if {$ReadFileFormat == "ddc"} {
	compile -inc -scan -bound
} elseif {$ReadFileFormat == "netlist"} {
	source -echo -verbose $synConstraintPath/drcCnst.tcl
	source -echo -verbose $synConstraintPath/bfCTSClk.tcl
	source -echo -verbose $synConstraintPath/ioCnst.tcl
	source -echo -verbose $synConstraintPath/dontTouch.tcl
	source -echo -verbose $synConstraintPath/timeExcpt.tcl

	remove_input_delay [get_ports $clockPortList]
	set_auto_disable_drc_nets -clock true -constant true
	
	compile -incr -bound -scan
} else {
	echo "Var ReadFileFormat is not correcly specifed"
}
