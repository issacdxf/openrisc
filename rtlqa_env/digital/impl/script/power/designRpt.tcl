#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designRpt.tcl
#
#      DESCRIPTION:
#         This TCL script is used to generate reports in PP flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { [file exists $rptDir] == 1 } {
} else {
  file mkdir $rptDir
}

if { [file exists $rptDir/current ] == 1 } {
  exec mv $rptDir/current $rptDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  file mkdir $rptDir/current
} else {
  file mkdir $rptDir/current
}

set rptDir $rptDir/current

#set_waveform_options -file $topModuleName
#calculate_power -waveform -statistics -error_file $topModuleName

#create_power_waveform -output $topModuleName 
check_power		

redirect [ file join $rptDir ${topModuleName}.powerrpt_hier ] {
report_power -level $ReportPowerLevel -hier
}

redirect [ file join $rptDir ${topModuleName}.powerrpt ] {
report_power 
}

