#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      AutoFix.tcl
#
#      DESCRIPTION:
#         This script is used to auto-fix violations in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#set_dft_configuration  -fix_clock enable \
#			 -fix_set enable -fix_reset enable
#set_dft_signal -view spec -type TestMode -port ASIC_TEST
#
#set_dft_signal -view exist -type ScanClock \
#                     -timing {45 55} -port CLK
#set_dft_signal -view spec -type TestData -port CLK
#
#set_autofix_configuration -type clock \
#            -control ASIC_TEST -test_data CLK

