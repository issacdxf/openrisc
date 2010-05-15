#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      DefineScanHold.tcl
#
#      DESCRIPTION:
#         This script is used to setup scan hold signals in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------
# Define DFT Constants
set_dft_signal -view exist -type Constant -port Test_Mode -active 1
set_dft_signal -view exist -type Constant -port hresetn   -active 1 
set_dft_signal -view exist -type Constant -port POR       -active 1

# Set the BSD reset signal to always active to pass drc_check
#set_dft_signal -view exist -type Constant -port BSD_trst -active 0

