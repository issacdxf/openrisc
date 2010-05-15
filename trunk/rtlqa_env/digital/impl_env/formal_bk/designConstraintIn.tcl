#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designConstraintIn.tcl
#
#      DESCRIPTION:
#         read in constraints script for formal verification in FM flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

if { [file exists $rptDir] == 1 } {
} else {
  file mkdir $rptDir
}

if { [file exists $rptDir/current] == 1 } {
  exec mv $rptDir/current $rptDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]$runFMstage
  file mkdir $rptDir/current
} else {
  file mkdir $rptDir/current
}

set rptDir $rptDir/current

set sessionDir "$workPath/session"
if { [file exists $sessionDir] == 1 } {
  [sh \\rm -r $sessionDir]
}
file mkdir $sessionDir

if { [file exists $fmConstraintPath/FMconstraint_${runFMstage}.tcl] } {
  source $fmConstraintPath/FMconstraint_${runFMstage}.tcl
} else {
  echo "Can not find constraint file $fmConstraintPath/FMconstraint_${runFMstage}.tcl\n";
}
