#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      InsertScan.tcl
#
#      DESCRIPTION:
#         This script is used to complete the scan chain insertion in DFT flow
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

if { [ file exists $workPath/net ] == 1 } {
  if { [ file exists $workPath/net/current ] == 1 } {
  exec mv $workPath/net/current $workPath/net/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  }
} else {
  file mkdir $workPath/net
}

if { [ file exists $workPath/ddc ] == 1 } {
  if { [ file exists $workPath/ddc/current ] == 1 } {
  exec mv $workPath/ddc/current $workPath/ddc/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  }
} else {
  file mkdir $workPath/ddc
}

if { [ file exists $workPath/spf ] == 1 } {
  if { [ file exists $workPath/spf/current ] == 1 } {
  exec mv $workPath/spf/current $workPath/spf/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  }
} else {
  file mkdir $workPath/spf
}

if { [ file exists $workPath/SPEF ] == 1 } {
  if { [ file exists $workPath/SPEF/current ] == 1 } {
  exec mv $workPath/SPEF/current $workPath/SPEF/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  }
} else {
  file mkdir $workPath/SPEF
}

file mkdir $workPath/net/current
file mkdir $workPath/ddc/current
file mkdir $workPath/spf/current
file mkdir $workPath/SPEF/current

current_design $topModuleName
uniquify
link

set_dft_configuration -scan enable -bsd disable

create_test_protocol

write_test_protocol -output $workPath/spf/current/${topModuleName}.pre.spf

redirect [file join $rptDir ${topModuleName}.chkdft_pre] {
	dft_drc -verbose
} 

redirect [file join $rptDir ${topModuleName}.prv_dft] {
 	preview_dft -test_points all
 	preview_dft -show all
}

redirect [file join $rptDir ${topModuleName}.prv_script] {
 	preview_dft -script
}

set_dft_insertion_configuration -synthesis_optimization None \
																-preserve_design_name true

insert_dft 

redirect [file join $rptDir ${topModuleName}.checkdft_post] {
   dft_drc -verbose
}
redirect [file join $rptDir ${topModuleName}.scan_path] {
 	report_scan_path -view exist
}
redirect [file join $rptDir ${topModuleName}.coverage] {
 	dft_drc -coverage_estimate
}

