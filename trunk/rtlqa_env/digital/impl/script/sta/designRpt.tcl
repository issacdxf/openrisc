#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designRpt.tcl 
#
#      DESCRIPTION:
#         This TCL script is used to generate reports in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#--------------------------------------
#	report STA enviornment summary
#--------------------------------------

redirect [ file join $rptDir ${topModuleName}.sta.summary] {
	echo "runPTstage is\t\t $runPTstage"
	echo "EnablePTSI is\t\t $EnablePTSI"
	echo "savesession is\t\t $savesession"
	echo "GenSIConstraints4PR is\t $GenSIConstraints4PR"
	echo "GenSDFfile is\t\t $GenSDFfile"
	echo "netlistFileList is\t $netlistFileList"
	echo "ParasiticFile is\t $ParasiticFile"
	echo "topModuleName is \t $topModuleName"
	echo "AnalysisType is\t\t $analysis_type"
	echo "OperatingCondition is\t $OperatingCondition"
	echo "WireLoadModel is\t $WireLoadModel"
}

redirect [ file join $rptDir ${topModuleName}.report_design] {
	report_design
}	

## -------------------------------------
## report_timing max and min
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_timing_max] {
  report_timing -delay_type max \
    -path_type full_clock_expanded \
    -input_pins \
    -nets \
    -transition_time \
    -capacitance \
    -crosstalk_delta \
    -nworst 2 \
    -max_paths 20 \
    -nosplit
}
redirect [file join $rptDir $topModuleName.report_timing_min] {
  report_timing -delay_type min \
    -path_type full_clock_expanded \
    -input_pins \
    -nets \
    -transition_time \
    -capacitance \
    -crosstalk_delta \
    -nworst 2 \
    -max_paths 20 \
    -nosplit
}

## -------------------------------------
## report_constraint
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_constraint] {
  report_constraint -all_violators
  report_constraint -all_violators -nosplit -verbose
}

## -------------------------------------
## report_port
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_port] {
  report_port -verbose
}

## -------------------------------------
## report_clock
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_clock] {
  report_clock [all_clocks]
  report_clock -skew
  report_clock_timing -type summary
  report_clock_gating_check
}

## -------------------------------------
## report_annotated_parasitics
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_annotated_parasitics] {
  report_annotated_parasitics -list_not -max_nets 100
}

## -------------------------------------
## report_analysis_coverage
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_analysis_coverage] {
  report_analysis_coverage \
    -status_details { untested violated } \
    -check_type { \
      setup hold \
      recovery removal nochange \
      min_period min_pulse_width \
      clock_separation max_skew \
      clock_gating_setup clock_gating_hold \
      out_setup out_hold \
    } \
    -exclude_untested { \
       constant_disabled \
       mode_disabled  \
       user_disabled \
       no_paths \
       false_paths \
       no_endpoint_clock \
       no_clock \
     } \
    -sort_by slack
}

## -------------------------------------
## report_case_analysis
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_case_analysis] {
  report_case_analysis -all
}

## -------------------------------------
## report_annotated_check 
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_annotated_check ] {
  report_annotated_check -setup -hold -recovery -removal -width -period -max_skew -clock_separation
}

## -------------------------------------
## report_exceptions 
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_exceptions ] {
  report_exceptions
}

## -------------------------------------
## report_timing_derate 
## -------------------------------------

redirect [file join $rptDir $topModuleName.report_timing_derate ] {
  report_timing_derate -include_inherited
}

## -------------------------------------
## check_timing
## -------------------------------------

redirect [file join $rptDir $topModuleName.check_timing] {

  set timing_enable_multiple_clocks_per_reg true

  set timing_check_defaults { \
    clock_crossing \
    data_check_multiple_clock \
    data_check_no_clock \
    generated_clocks \
    generic \
    ideal_clocks \
    latch_fanout \
    latency_override \
    loops \
    ms_separation \
    no_clock \
    no_driving_cell \
    no_input_delay \
    partial_input_delay \
    retain \
    signal_level \
    unconstrained_endpoints \
    unexpandable_clocks \
  }

  echo "###############################################################################"
  echo "Performing check_timing with timing_enable_multiple_clocks_per_reg set to true."
  echo "###############################################################################"

  check_timing -verbose

  set timing_enable_multiple_clocks_per_reg false

  set timing_check_defaults { \
    multiple_clock \
  }

  echo "###############################################################################"
  echo "Performing check_timing with timing_enable_multiple_clocks_per_reg set to false."
  echo "###############################################################################"

  check_timing -verbose

  set timing_enable_multiple_clocks_per_reg true

  echo "###############################################################################"
  echo "Performing report_disable_timing."
  echo "###############################################################################"
  report_disable_timing

}

if { [info exists sync_clock_list] } {
  redirect [file join $rptDir ${topModuleName}.sync_clock_skew.rpt] {
    foreach_in_collection my_clock $sync_clock_list {
      report_clock_timing -type interclock_skew -verbose -from_clock $my_clock -to_clock $sync_clock_list
    }
  }
}

if { $GenSIConstraints4PR == "true" } {
  echo "###############################################################################"
  echo "Performing SI-violation-fix script generating."
  echo "###############################################################################"
  source -echo -verbose $PTScriptPath/genSIcnst4PR.tcl
}
if { $GenSDFfile == "true" } {
  echo "###############################################################################"
  echo "Performing SDF file generating."
  echo "###############################################################################"
  source -echo -verbose $PTScriptPath/genSDF.tcl
}
if { $GenSDCfile == "true" } {
  echo "###############################################################################"
  echo "Performing SDC file generating."
  echo "###############################################################################"
  source -echo -verbose $PTScriptPath/genSDC.tcl
}
