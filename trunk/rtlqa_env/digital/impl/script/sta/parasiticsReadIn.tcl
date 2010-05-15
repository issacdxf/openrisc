#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      parasiticsReadIn.tcl 
#
#      DESCRIPTION:
#         This script is used to read in parasitics in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

## -----------------------------------------------------------------------------
## Read parasitics
## -----------------------------------------------------------------------------
if { $ParasiticModel == "SPEF" || $ParasiticModel == "SBPF" } {
  if { $EnablePTSI == "true" } {
    echo "\n\nReading Parasitics File $ParasiticFile and keeping coupling caps\n\n"
    read_parasitics \
      -quiet \
      -format $ParasiticModel \
      -keep_capacitive_coupling \
      -complete_with zero \
      $ParasiticFile
  } else {
    echo "\n\nReading Parasitics File $ParasiticFile\n\n"
    read_parasitics \
      -quiet \
      -format $ParasiticModel \
      -complete_with zero \
      $ParasiticFile
  }
	redirect [file join $rptDir reportAnnotatedParasitics.rpt] {
		report_annotated_parasitics \
	    -check \
      -list_not_annotated \
      -constant_arcs
  }
} elseif { $ParasiticModel == "SDF" } {
    echo "\n\nReading SDF file $ParasiticFile\n\n"
    read_sdf \
      -quiet \
      $ParasiticFile
	redirect [file join $rptDir reportAnnotatedParasitics.rpt] {
    report_annotated_delay \
      -list_not_annotated \
      -constant_arcs
  }
} elseif { $ParasiticModel == "WLM" } {  	
      if { $WireLoadModel == "AUTO" } {
        echo "Using Auto Wireload Selection\n"
        set auto_wire_load_selection true
      } elseif { $WireLoadModel == "NONE" } {
        echo "Using No Wireload Model\n"
        remove_wire_load_model
        remove_wire_load_selection_group
        set auto_wire_load_selection false
      } else {
        echo "Using Wireload model $WireLoadModel"
        set auto_wire_load_selection false
        set_wire_load_mode top
        set_wire_load_model -name $WireLoadModel [current_design]
      }
}
