#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      run_leda.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#
set runSetType          LEDA            ;# runSetType defines script category,RTL-QA flow will use this
                                        ;# variable to setup stage-process environments
set projectName         des             ;#
set topModuleName       des             ;# Define top-module name of the whole chip.RTL-QA flow will use
                                        ;# this variable to link designs,define transformed data name etc.
set CheckDC		false           ;# true/false
set CheckDW		false           ;# true/false
set CheckDFT		false		;# true/false
set CheckFM		false           ;# true/false

# ===================== Flow Control ========================#
#-----------------------------------#
# Include Environment Setup Script
#-----------------------------------#

source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl

#-----------------------------------#
# Include Library Setup Script
#-----------------------------------#
source -echo -verbose $LibrarySetupPath/setupLib.tcl

source -echo -verbose $ledaScriptPath/designReadIn.tcl
source -echo -verbose $ledaScriptPath/designRpt.tcl

gui_start
