#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      cmpDsg.tcl
#
#      DESCRIPTION:
#         This script is used to compile the design in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#-----------------------------------#
# prepare the env/designs ready
#-----------------------------------#
if { $clockgating == "true" } {
  insert_clock_gating
#  hookup_testports -tm_port Test_Mode
}

set uniquify_naming_style {%s_%d}
uniquify
link

if { $clockgating == "true" } {
  propagate_constraints -gate_clock
}

current_design $topModuleName

set compile_log_format {  %elap_time %trials %mem %wns %max_delay %min_delay %tns %drc %area %group_path %endpoint}

set_fix_multiple_port_nets -feedthroughs -outputs -buffer_constants [get_designs *]

set_auto_disable_drc_nets -clock true -constant true

#compile -map $increCmpEffort -no_design_rule
compile -map $increCmpEffort -area_effort high

set verilogout_higher_designs_first false
set verilogout_equation false
set verilogout_no_tri true
set verilogout_single_bit false

# Setup naming rule
source -echo -verbose $dtclConstraintPath/insert_sparecell.tcl

current_design $topModuleName

source -echo -verbose $dtclConstraintPath/namRule.tcl

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

if { [ file exists $workPath/SPEF ] == 1 } {
  if { [ file exists $workPath/SPEF/current ] == 1 } {
  exec mv $workPath/SPEF/current $workPath/SPEF/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
  }
} else {
  file mkdir $workPath/SPEF
}

file mkdir $workPath/net/current
file mkdir $workPath/ddc/current
file mkdir $workPath/SPEF/current


write -f ddc     -hier -output $workPath/ddc/current/${topModuleName}.ddc $topModuleName
write -f verilog -hier -output $workPath/net/current/${topModuleName}.v $topModuleName
write_parasitics -output $workPath/SPEF/current/${topModuleName}.spef
echo "${topModuleName}.v" > $workPath/net/current/${topModuleName}.lst
