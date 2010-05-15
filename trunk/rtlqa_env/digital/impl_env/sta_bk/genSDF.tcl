#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      genSDF.tcl 
#
#      DESCRIPTION:
#         This script is used to generate SDF file in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

## -----------------------------------------------------------------------------
## Generate reports and write SDF for simulation.  If there are customized reports
## you would like to generate, define TEV_ANALYSIS_FILE and make it point to your
## script that does the reporting.
## -----------------------------------------------------------------------------

if { $GenSDFfile == "true" } { 
  echo "Generating SDF and setload files\n"
  set SDFDir	$workPath/SDF_${PTCase}_${runPTstage}
  if { [file exists $SDFDir] == 1 } {
    if { [file exists $SDFDir/current] == 1 } {
      exec mv $SDFDir/current $SDFDir/[clock format [clock seconds] -format "%m%d%y_%H%M"]
      file mkdir $SDFDir/current
    } else {
      file mkdir $SDFDir/current
    }
  } else {
    file mkdir $SDFDir
    file mkdir $SDFDir/current
  }

  set filename $SDFDir/current/${topModuleName}_${OperatingCondition}
  write_sdf \
    -version 2.1 \
    -no_timing_checks \
    -input_port_nets \
    -output_port_nets \
    -no_internal_pin \
    -context verilog \
    -no_edge \
    ${filename}.sdf

#  set set_load_file ${filename}.set_load
#  echo "# set_load file for $topModuleName" > $set_load_file
#  foreach_in_collection net [get_nets * -hierarchical] {
#    set net_name [get_attribute $net full_name]
#    set net_cap  [get_attribute $net wire_capacitance_max]
#    if {$net_cap > 0.0} {
#      echo "set_load $net_cap \[get_nets $net_name\]" >> $set_load_file
#    } else {
#      echo "# OMITTED : set_load $net_cap \[get_nets $net_name\]" >> $set_load_file
#    }
#  }
}
