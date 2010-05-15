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

#redirect [file join $rptDir ${topModuleName}.fault.rpt] {
#  report_fault -summary
#  report_faults -level 100 10
#}

#redirect [file join $rptDir ${topModuleName}.analyze_fault.rpt] {
#  analyze_faults -class AN -class UD 
#}

#redirect [file join $rptDir ${topModuleName}.summary.rpt] {
#  report_summaries
#}

#redirect [file join $rptDir ${topModuleName}.patterns.rpt] {
#  report_patterns -all
#}

if { [file exists $workPath/current] == 1 } {
  exec mv $workPath/current $workPath/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  file mkdir $workPath/current
} else {
  file mkdir $workPath/current
}
 
set pattern_dir $workPath/current

 write_pattern $pattern_dir/${topModuleName}.stil -format stil -replace -ser
 write_pattern $pattern_dir/${topModuleName}_s.v -format verilog_single_file -replace -serial -split 1 -last 0
 write_pattern $pattern_dir/${topModuleName}_p.v -format verilog_single_file -replace -parallel 1
 write_pattern $pattern_dir/${topModuleName}.bin -format binary -replace 
 write_faults $pattern_dir/${topModuleName}_faults.txt -all -replace -uncollapsed
 write_drc_file $pattern_dir/${topModuleName}.drc
