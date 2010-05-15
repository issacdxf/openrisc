#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      rundc.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#
get_license    DC-Expert
get_license    Power-Optimization
set runSetType 		DC		;# runSetType defines script category,RTL-QA flow will use this
					;# variable to setup stage-process environments
set projectName		des		;#
set topModuleName	des	 	;# Define top-module name of the whole chip.RTL-QA flow will use
					;# this variable to link designs,define transformed data name etc.
#-----------------------------------#
# Synthesis Flow Control
#-----------------------------------#
set setupLib 		true 		;# true/false.To be true,setupLib.tcl will be sourced in;Otherwise,
					;# library environment should be setup manually
set readInDesign  	true		;# true/false.To be true,rtl designs will be read in automatically
					;# according to the rtl design list; Otherwise,read in designs manually
set clockgating		true		;# true/false.Perform clock gating insertion or not
set constrainDesign  	true		;# true/false.Define constrains or not. To be true, design will be
					;# optimized by performing "compile" command; Otherwise,do it manually

set phyConstrainDesign 	false		;# true/false. Define physical constraints or not.
														; # It's a new var to support DCT

set compileDesign  	true;	# true/false.Perform optimization or not. To be true,design will be
					;# optimized by performing "compile" command; Otherwise,do it manually
set designReport 	true;# true/false.Generate reports or not. To be true,detailed informations
					;# will be reported out
set rptBufferTree	false;# true/false.To be true,high-fanout nets such as clock and reset will be
					;# checked to find out if unexpected buffers/inverters were inserted
set CleanBufferTree	false		;# true/false.To be true,unexpected buffers/inverters will be removed from
					;# high-fanout ideal nets

set fullCmpEffort 	high  		;# none/low/medium/high Define full compile effort level
set increCmpEffort	high		;# none/low/medium/high Define incremental compile effort level

set GenSDCfile		true		;# true/false.To be true, SDC file will be generated for P&R

set milkywayDatabase 	false		;# true/flase.Save milkyway CEL, used in DCT flow.

#set hdlFilePath	""		;# set this variable only when special rtl file directory is used than default.
#set hdlFileList 	""		;# set this variable only when special rtl file list is used than default.

#-----------------------------------#
# Generate Report
#-----------------------------------#
set padCellName 	 ""
set rptDesignInfo        true
set rptHierarchy         true
set rptAreaInfo          true
set rptClkInfo           true
set rptCheckTiming   	 true
set rptTimingExcept      true
set rptTimingCnst        true
set rptMaxDelayPath      true
set rptMinDelayPath      true

#-----------------------------------------#
# Reserved variables
#-----------------------------------------#

#set readDbFile 	false		;# true/false.Reserved variable
#set readMilkyWayFile	false		;# true/false.Reserved variable
#set acsRead            false		;# true/false.Reserved variable.Use acs_read method or not.
#set prepareOnly	false		;# true/false.Reserved variable.Used in acs flow.
#set useLsf 		false		;# true/false.Reserved variable.Used in acs flow.
#set acs_compile 	false		;# true/false.Reserved variable.Used in acs flow.
#set acsParalJobNum  	0		;# integer.Reserved variable.Used in acs flow.
#set levelPartition	false		;# true/false.Reserved variable.Used in acs flow.
#set levelNum       	0		;# integer.Reserved variable.Used in acs flow.
#set designPartition	false		;# true/false.Reserved variable.Used in acs flow.
#set designList 	[list]		;# collection.Reserved variable.Used in acs flow.
#set milkywayDatabase 	true		;# true/flase.Reserved variable.Used in acs flow.
#set optmiCost 		timing 		;# timing/timing_area.Reserved variable.Used in acs flow.

# ===================== Flow Control ========================#
#-----------------------------------#
# Include Environment Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl

#-----------------------------------#
# Include Library Setup Script
#-----------------------------------#
if {$setupLib == "true"} {
source -echo -verbose $LibrarySetupPath/setupLib.tcl
}

#-----------------------------------#
# Include Design Read In Script
#-----------------------------------#
if {$readInDesign == "true"} {
source -echo -verbose $dcScriptPath/designReadIn.tcl
}
link

#-----------------------------------#
# Include Design Logical Constraint Script
#-----------------------------------#
if {$constrainDesign == "true"} {
source -echo -verbose $dcScriptPath/cnstDsg.tcl
}

#-----------------------------------#
# Include Compile Script
#-----------------------------------#
if {$compileDesign == "true"} {
source -echo -verbose $dcScriptPath/cmpDsg.tcl
}

#-----------------------------------#
# Include Post Compile Report Script
#-----------------------------------#
if {$designReport == "true"} {
source -echo -verbose $dcScriptPath/designRpt.tcl
}

if {$GenSDCfile == "true"} {
source -echo -verbose $dcScriptPath/genSDC.tcl
}

#-----------------------------------#
# Include Clean Buffer Tree Script
#-----------------------------------#
if {$CleanBufferTree == "true"} {
source -echo -verbose $dtclConstraintPath/CleanBufferTree.tcl
}

#quit

