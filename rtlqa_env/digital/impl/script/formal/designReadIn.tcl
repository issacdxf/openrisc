#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designReadIn.tcl
#
#      DESCRIPTION:
#         read in design script for formal verification in FM flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#---------------------------------------
# Read in Design
#---------------------------------------
create_container REF
create_container IMP

if { $runFMstage == "timing" } {
    current_container REF
    set REFFileList [exec cat $REFsourcefilelist]
    foreach rtlfile $REFFileList {
    lappend temp_filelist $REFFilePath/$rtlfile
    }
    read_verilog $temp_filelist
    set_top REF:/WORK/$topModuleName
    current_design $topModuleName
    current_container IMP
    set IMPLFileList [exec cat $IMPLsourcefilelist]
    foreach rtlfile $IMPLFileList {
    lappend temp2_filelist $IMPLFilePath/$rtlfile
    }
    read_verilog $temp2_filelist
    set_top IMP:/WORK/$topModuleName
    current_design $topModuleName
} elseif { $runFMstage == "syn" } {
    current_container REF
    set REFFileList [exec cat $REFsourcefilelist]
    foreach rtlfile $REFFileList {
    lappend temp_filelist $REFFilePath/$rtlfile
    }
    read_verilog $temp_filelist
    set_top REF:/WORK/$topModuleName
    current_design $topModuleName
    current_container IMP
    if { [file exists $IMPFilePath/$topModuleName.v] == 1 } {
	    read_verilog -netlist [file join $IMPFilePath ${topModuleName}.v]
    } else {
  	echo "\n\nCan not find the specified file $IMPFilePath/$topModuleName.v"
  	quit
    }
    set_top IMP:/WORK/$topModuleName
} elseif { $runFMstage == "dft" || $runFMstage == "fp" ||\
	   $runFMstage == "psyn" || $runFMstage == "rt" || $runFMstage == "bsd"} {
    current_container REF
    if { [file exists $REFsourcefilelist] == 1 } {
      set REFFileList [exec cat $REFsourcefilelist]
      foreach reffile $REFFileList {
	echo "\n\n\nPerform $reffile Reading ..........................\n\n\n"
  	read_verilog -netlist [file join $REFFilePath $reffile]
      }
    } else {
  	echo "\n\nCan not find the specified file $REFsourcefilelist"
  	quit
      }
    set_top REF:/WORK/$topModuleName

    current_container IMP
    if { [file exists $IMPsourcefilelist] == 1 } {
	set IMPFileList [exec cat $IMPsourcefilelist]
	foreach impfile $IMPFileList {
	  read_verilog -netlist [file join $IMPFilePath $impfile]
	}
    } else {
  	echo "\n\nCan not find the specified file $IMPsourcefilelist"
  	quit
    }
    set_top IMP:/WORK/$topModuleName
}
set_reference_design      REF:/WORK/$topModuleName
set_implementation_design IMP:/WORK/$topModuleName
