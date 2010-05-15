#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designConstraintIn.tcl 
#
#      DESCRIPTION:
#         This script is used to read in parasitics in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

## -----------------------------------------------------------------------------
## Do setup for on-chip variation.  For a single operating condition, the variation
## is created by derating the timing by 5%.  For OP_BC_WC, the timing is not derated
## because it would be unrealistically pessimistic
## -----------------------------------------------------------------------------

if { $AnalysisType == "OCV" } {
  echo "On Chip Variation - PT_OP_MODE=$AnalysisType"
}

if { $OperatingCondition == "BCWC" } {
      set_timing_derate -early 1.00
      set_timing_derate -late  1.00
} elseif { $OperatingCondition == "WC" || $OperatingCondition == "TYP" } {
      set_timing_derate -early 1.00
      set_timing_derate -late  1.00
} elseif { $OperatingCondition == "BC" } {
      set_timing_derate -early 1.00
      set_timing_derate -late  1.00
} else {
}

## --------------------------------------------------------------------------
## Set design constraints.
## --------------------------------------------------------------------------

current_design $topModuleName


echo "Sourcing constraints from PTconstraint_${PTCase}_${runPTstage}.tcl\n"
  if { [file exists $ptConstraintPath/PTconstraint_${PTCase}_${runPTstage}.tcl] == 1 } {
     source -echo -verbose $ptConstraintPath/PTconstraint_${PTCase}_${runPTstage}.tcl
  } else {
     echo	"Can not find design constraints PTconstraint_${PTCase}_${runPTstage}.tcl\n"
     quit
  }

if { $runPTstage == "rt" } {
  echo "Setting all clocks to be propagated for post-route mode\n"
  set_propagated_clock [all_clocks]
}
