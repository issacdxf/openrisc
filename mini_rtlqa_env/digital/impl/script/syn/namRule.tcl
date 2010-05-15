#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      namRule.tcl
#
#      DESCRIPTION:
#         This script is used to define naming rules in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#-------------------------------#
# Define Naming Rules
#-------------------------------#
set bus_inference_descending_sort    true
set bus_inference_style              %s\[%d\]
set bus_naming_style                 %s\[%d\]

set verilogout_no_tri true

set change_names_dont_change_bus_members true

set_fix_multiple_port_nets -all

define_name_rules lab_vlog -type port \
			-allowed {a-zA-Z0-9[]_} \
			-equal_ports_nets \
			-first_restricted "0-9_" \
			-max_length 256

define_name_rules lab_vlog -type net \
			-allowed "a-zA-Z0-9_" \
			-equal_ports_nets \
			-first_restricted "_0-9" \
			-max_length 256

define_name_rules lab_vlog -type cell \
			-allowed "a-zA-Z0-9_" \
			-first_restricted "_0-9" \
			-map {{ {"\[", "_"}, {"\]", ""}, {"\[", "_"} }} \
			-max_length 256

define_name_rules slash -restricted {/} -replace {_}

change_names -verbose -hier -rules slash
change_names -verbose -hier -rules lab_vlog
