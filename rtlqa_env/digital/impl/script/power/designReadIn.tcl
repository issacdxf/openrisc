#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designReadIn.tcl
#
#      DESCRIPTION:
#         This TCL script is used to generate reports in PP flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------
#-----------------------------------------------------------------------------
# read in netlist
#-----------------------------------------------------------------------------

if { [file exists $netlistFilePath/$netlistFileList] == 1 } {
  set filelist [sh cat $netlistFilePath/$netlistFileList]
  foreach netlist $filelist {
    if { [file exists $netlistFilePath/$netlist] == 1 } {
      if { [file extension $netlist ] == ".v" || [file extension $netlist ] == ".V" || [file extension $netlist ] == ".vg" || [file extension $netlist] == ".VG"} {
        read_verilog $netlistFilePath/$netlist
      } elseif { [file extension $netlist] == ".vhdl" || [file extension $netlist] == ".VHDL"} {
        read_vhdl $netlistFilePath/$netlist
      } else {
        echo "ERROR: File $netlist can not be recognized\n"
        quit
      }
    } else {
      echo "\n\nCan not find netlist file $netlist! Please check it.\n\n"
      quit
    }
  }
} else {
  echo "\n\nCan not find the List file $netlistFileList.Please check it and run again.\n\n"
  quit
}

current_design $topModuleName
link_design

if { $OperatingCondition == "WC" } {
  set_operating_conditions -analysis_type single $maxOptCond
} elseif { $OperatingCondition == "BC" } {
  set_operating_conditions -analysis_type single $minOptCond
}

