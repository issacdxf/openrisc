#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designReadIn.tcl 
#
#      DESCRIPTION:
#         This script is used to read in netlist according to user specified lists
#	       in PT flow.
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { [file exists $rptDir] == 1 } {
} else {
  file mkdir $rptDir
}

if { [file exists $rptDir/current] == 1 } {
  exec mv $rptDir/current $rptDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  file mkdir $rptDir/current
} else {
  file mkdir $rptDir/current
}

set rptDir $rptDir/current

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

#----------------------------------------------------------------------------------
#set operating condition
#----------------------------------------------------------------------------------

if { $AnalysisType == "BCWC" } {
	set analysis_type bc_wc
} elseif { $AnalysisType == "SINGLE" } {
	set analysis_type single
} elseif { $AnalysisType == "OCV" } {
	set analysis_type on_chip_variation
}

if { $OperatingCondition == "WC" } {
	set_operating_conditions -analysis_type $analysis_type -library $maxLibName $maxOptCond
	echo "set_operating_conditions -analysis_type $analysis_type -library $maxLibName $maxOptCond"

} elseif { $OperatingCondition == "BC" } {
	set_operating_conditions -analysis_type $analysis_type -library $minLibName $minOptCond
	echo "set_operating_conditions -analysis_type $analysis_type -library $minLibName $minOptCond"

} elseif { $OperatingCondition == "TYP" } {
	set_operating_conditions -analysis_type $analysis_type -library $typLibName $typOptcond
	echo "set_operating_conditions -analysis_type $analysis_type -library $typLibName $typOptcond"

} elseif { $OperatingCondition == "BCWC" } {
	set_operating_conditions -analysis_type $analysis_type \
			-min $minOptCond \
			-max $maxOptCond \
			-min_library $minLibName \
			-max_library $maxLibName
	echo "set_operating_conditions -analysis_type $analysis_type \
			-min $minOptCond \
			-max $maxOptCond \
			-min_library $minLibName \
			-max_library $maxLibName"
}

