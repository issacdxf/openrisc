#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      ioCnst.tcl
#
#      DESCRIPTION:
#         This script is used to specify io constraints in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#==========================#
#   Input Constraints      #
#==========================# 

set_input_delay -max $HCLK_PERIOD_HALF  -clock hclk [remove_from_collection [all_inputs] hclk] -net -source
set_input_delay -min $HCLK_PERIOD_HALF  -clock hclk [remove_from_collection [all_inputs] hclk] -net -source

set_output_delay -max $HCLK_PERIOD_HALF -clock hclk [remove_from_collection [all_outputs] hclk] -net -source 
set_output_delay -min $HCLK_PERIOD_HALF -clock hclk [remove_from_collection [all_outputs] hclk] -net -source 
