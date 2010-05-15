if { [ file exists $rptDir ] == 1 } {
} else {
  file mkdir $rptDir
}

if { [ file exists $rptDir/current ] == 1 } {
  exec mv $rptDir/current $rptDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
}

  file mkdir $rptDir/current
  set rptDir $rptDir/current

current_design $topModuleName
check

redirect [file join $rptDir report_rulecheck.rpt] {
  report
}
