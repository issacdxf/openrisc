#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      runpt.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#
set runSetType				PT		;# runSetType defines script category,RTL-QA flow will use this
							;# variable to setup stage-process environments

set projectName				des		;#

set runPTstage 				syn             ;# syn/dft/bsd/psyn/fp/rt.	
					                ;# This variable is used in analysis process.
							;# (STA,Formal,Power) RTL-QA flow will use this variable to 
							;# distinguish the target database to be analyzed 
set PTCase				FUNCTION	;# SCAN/FUNCTION.Set analysis mode for STA.User-specified names can
							;# be declared here according to factual work mode,meanwhile,a 
							;# constraint file named "PTconstraint_$PTCase_$runPTstage.tcl"
							;# should be created under impl/<prj_home>/script/sta directory

#-----------------------------------#
# StaticTimingAnalysis Flow Control
#-----------------------------------#
set ParasiticModel			WLM		;# SPEF/SDF/SBPF/WLM.Define which parasitic model will be usded in STA.
							;# Usually,SPEF/SDF/SBPF are used in post-layout process while WLM is
							;# used in pre-layout process. In DCT flow, SPEF should be used and in regular flow, WLM be used
set WireLoadModel			AUTO  		;# AUTO/NONE/wlm_in_library.This variable will effect once ParasiticModel
							;# is set to "WLM"."AUTO","NONE" or special wire-load-model defined in 
							;# Vendor libraries are optional
set AnalysisType			OCV 		;# BCWC/SINGLE/OCV.Define which analysis mode will be used in STA
set OperatingCondition			WC		;# WC/BC/BCWC/TYP.Define which librarywill be used in STA. Particularly
							;# if this variable is set to "BCWC", both best-case library and worst-case
							;# library are both used even "Analysistype" is set to "OCV",which would
							;# lead to unnecessary pessimistic
set GenSDFfile				false		;# true/false To be true,SDF file will be generated
set GenSDCfile				false		;# true/false To be true,SDC file will be generated
set savesession				false		;# true/false To be true,current session will be saved
set EnablePTSI				false		;# true/false To be true,SI analysis will performed.
set GenSIConstraints4PR			false		;# true/false To be true,scheme scripts for Astro will be generated to 
							;# repair si violations.This ariable only make effects when "EnablePTSI"
							;# is set to "true"
set xtalk_nworst_nets 			0		;# integer Define the number of nets whom scheme scripts should be be
							;# generated for to repair the xtalk violations in Astro.

set ParasiticFileName			des.spef 	;# Define the parasitics file name
set netlistFileList 			des.lst	        ;# List all the netlist files that should be read in to perform STA
set topModuleName 			des		;# Define top-module name to perform STA

#set ParasiticFilePath			""		;# set this variable only when special parasitics file directory is 
							;# used than default
#set netlistFilePath			""		;# set this variable only when special netlist file directory is 
							;# used than default
#-------------------------------------------------------------------------------
# Main part of STA flow
#-------------------------------------------------------------------------------
#-----------------------------------#
# Include Environment Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl

#-----------------------------------#  
# Include Library Setup Script
#-----------------------------------#
source -echo -verbose $LibrarySetupPath/setupLib.tcl

#-----------------------------------#  
# Include Design Read In Script
#-----------------------------------#
source -echo -verbose $PTScriptPath/designReadIn.tcl

#-----------------------------------#  
# Include Parasitic Read In Script
#-----------------------------------#
source -echo -verbose $PTScriptPath/parasiticsReadIn.tcl

#-----------------------------------#   
# Include Design Constraint Script
#-----------------------------------#
source -echo -verbose $PTScriptPath/designConstraintIn.tcl

#-----------------------------------#
# Include Post Compile Report Script
#-----------------------------------#
source -echo -verbose $PTScriptPath/designRpt.tcl    

#-----------------------------------#
# Include session save script
#-----------------------------------#
if { $savesession == "true" } {
	source -echo -verbose $PTScriptPath/savesession.tcl
}

#quit
