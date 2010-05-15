#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designReadIn.tcl
#
#      DESCRIPTION:
#         This script is used to read in the designs in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------
#-----------------------------------#
# Define Design Library Path 
#-----------------------------------#

#define_design_lib work -path $workPath\template
#define_design_lib WORK -path $workPath\template

set RTLFileList [exec cat $hdlFileList]
foreach rtlfile $RTLFileList {
  echo "\n\n\nPerform $rtlfile Reading ..........................\n\n\n"
  if { [file exists $rtlfile] == 1 } {
    if { [file extension $rtlfile ] == ".v" || [file extension $rtlfile ] == ".V" || [file extension $rtlfile ] == ".vg" || [file extension $rtlfile] == ".VG"} {
      #read_verilog [file join $hdlFilePath $rtlfile]
      analyze -f verilog $rtlfile
    } elseif { [file extension $rtlfile] == ".vhdl" || [file extension $rtlfile] == ".VHDL" || [file extension $rtlfile] == ".vhd" || [file extension $rtlfile] == ".VHD"} {
      read_vhdl $hdlFilePath/$rtlfile
    } else {
      echo "\n\n\nERROR: File $rtlfile can not be recognized\n\n\n"
      quit
    }
  } else {
    echo "\n\nCan not find file $rtlfile! Please check it.\n\n"
    quit
  }
}
#set temp_filelist ""
#foreach rtlfile $RTLFileList {
#lappend temp_filelist $hdlFilePath/$rtlfile
#}

analyze -f verilog $temp_filelist
elaborate -update $topModuleName
current_design $topModuleName
link
#-----------------------------------#
# Perform Clock Gating insertion
#-----------------------------------#
if { $clockgating == "true" } {
        echo "\n\nPerform Clock Gating style define\n";
        source $dtclConstraintPath/clock_gating.tcl
}

write -format ddc -hierarchy -output $workPath/sourceDb/$topModuleName.gtech.ddc
current_design $topModuleName
link
#
