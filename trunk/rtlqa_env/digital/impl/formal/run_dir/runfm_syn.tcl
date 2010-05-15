#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      runfm.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#

#-----------------------------------#
# Formality Flow Control
#-----------------------------------#
set runSetType		FM	;# runSetType defines script category,RTL-QA flow will use this
				;# variable to setup stage-process environments
set projectName		des	;#
set runFMstage		syn 	;# syn/dft/fp/psyn/rt/bsd This variable is used in analysis process.
				;# ( STA,Formal,Power) RTL-QA flow will use this variable to 
				;# distinguish the target database to be analyzed
set designReport        true	;# true/false To be true,detailed information will be reported out
set savesession		false	;# true/false To be true,current session will be saved
set UseHierCompare	false	;# true/false To be true,formality will automatically use 
				;# hierarchy compare method

set topModuleName       des     ;# Define top-module name to perform Formal check

#set REFFilePath	""	;# set this variable if different REF file directory is used than default
#set IMPFilePath	""	;# set this variable if different IMP file directory is used than default
#set REFsourcefilelist	""	;# list all possible files referenced by REF container, set it only when 
				;# special list will be used than default
#set IMPsourcefilelist	""	;# list all possible files referenced by IMP container, set it only when
				;# special list will be used than default

# ===================== Flow Control ========================#
#-----------------------------------#
# Include Library Setup Script
#-----------------------------------#
#set synopsys_auto_setup true
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl
source -echo -verbose $LibrarySetupPath/setupLib.tcl

#-----------------------------------#
# Include Design Read In Script
#-----------------------------------#
source -echo -verbose $fmScriptPath/designReadIn.tcl

#-----------------------------------#
# Include Design Constraint Script
#-----------------------------------#
source -echo -verbose $fmScriptPath/designConstraintIn.tcl

#-----------------------------------#
# Include Design Verify Script
#-----------------------------------#
if {$UseHierCompare == "true"} {
$source -echo -verbose $fmScriptPath/hier_verify.tcl
} else {
source -echo -verbose $fmScriptPath/verify.tcl
}
#quit
