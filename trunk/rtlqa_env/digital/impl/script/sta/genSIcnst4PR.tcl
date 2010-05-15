#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      genSIcnst4PR.tcl 
#
#      DESCRIPTION:
#         This script is used to generate Tcl scripts for Astro to
#			fix SI violations in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

## -----------------------------------------------------------------------------
## This section generates a net isolation SI constraint file that can be fed
## back into Astro.  This section would only be run during the RT step for
## intermediate analysis.  The final sign-off STA does not need to generate a 
## constraint file.
## -----------------------------------------------------------------------------

set SIcnstDir	"$workPath/SIcnst"
if { [file exists $SIcnstDir] == 1 } {
  if { [file exists $SIcnstDir/current] == 1 } {
    exec mv $SIcnstDir/current $workPath/SIcnst/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
    file mkdir $SIcnstDir/current
  } else {
    file mkdir $SIcnstDir/current
} else {
  file mkdir $SIcnstDir
}

if { $EnablePTSI == "true" && $GenSIConstraints4PR == "true" } {

  echo "You are generating an SI constraint file for astro\n"
  source $ENV_HOME/impl_env/misc/si_astro_fix_v1.7.tcl

  set violating_timing_paths [get_timing_path -nworst 100 -max_paths 100 -slack_lesser_than 0.1 ]
  set astro_constraint_file $SIcnstDir/ptsi_xtalk_cmds.net_isolation.scm
  set num_violating_timing_paths [sizeof_collection $violating_timing_paths]
  echo "$topModuleName contains $num_violating_timing_paths timing paths with slack < 0.1"
  echo ";# No Net constraints were generated" > $astro_constraint_file

if { $num_violating_timing_paths > 0} {
   create_astro_xtalk_constraints \
      -delay \
      -init_constraints \
      -nworst_net $xtalk_nworst_nets \
      -nworst_aggressor 2 \
      -output $astro_constraint_file \
      $violating_timing_paths
   redirect [file join $rptDir $topModuleName.sta.si_bottleneck] {
      report_si_bottleneck -nosplit
   }
} else {
    echo "No SI constraint file for astro is created because there are no violating timing paths\n"
  }
 echo ";# End of file" >> $astro_constraint_file
}
