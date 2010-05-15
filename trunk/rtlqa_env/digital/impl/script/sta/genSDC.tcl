#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      genSDC.tcl 
#
#      DESCRIPTION:
#         This script is used to generate SDC file in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { $GenSDCfile == "true" } { 
  echo "Generating SDC files\n"
  set SDCDir $workPath/SDC_${PTCase}_${runPTstage}
  if { [file exists $SDCDir] == 1 } {
    if { [file exists $SDCDir/current] == 1 } {
      exec mv $SDCDir/current $SDCDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
      file mkdir $SDCDir/current
    } else {
      file mkdir $SDCDir/current
    }
  } else {
    file mkdir $SDCDir
    file mkdir $SDCDir/current
  }
  set filename $SDCDir/current/$topModuleName.sdc
  write_sdc $filename
}
