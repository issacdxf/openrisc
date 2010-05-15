#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      hier_verify.tcl
#
#      DESCRIPTION:
#        hierarchical verify script for formal verification in FM flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

set hier_script_name ${topModuleName}_hier.scr
write_hierarchical_verification_script \
	-replace \
	-save_directory $sessionDir \
	-save_file_limit 10 \
	$hier_script_name
	
source $hier_script_name
