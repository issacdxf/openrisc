#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      runptpx.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#
  set runSetType		POWER 	;#runSetType defines script category,RTL-QA flow will use this 
					;# variable to setup stage-porcess environments
  set projectName               des     ;# the project name
  set runPPstage		syn   	;# syn/dft/bsd/psyn/fp/rt This variable is usded in analysis process
					;# (STA,Formal,Power) RTL-QA flow will use this variable to 
					;# distinguish the target database to be analyzed

  set OperatingCondition 	TC	;#WC/BC/TC Define which library will be used in STA

  set topModuleName		des	;# Define top-module name to perform power analysis

  set parasiticsFileFormat 	WLM	;# SPEF/SDF/SBPF/WLM. Define which type of parasitic file will be used
					;# in PTPX
  set WireLoadModel		AUTO    ;# AUTO/NONE/SELECT

  set MaxparasiticsFileName   	"des.spef"	;# Declare the worst-case parasitics file name
  set MinparasiticsFileName   	""	;# Declare the best-case parasitics file name

  set ToggleFileType            vcd; # vcd/saif/none, determin using vcd, saif or none

  set vcdFileName		"pp_max.vcd"	;	# Declare the vcd file name
  set vcdStripPath		"chiptop/des"	;# Define the hierarchy path to which the
							;# vcd file is back-annotated

#  set ToggleFileType            none; # vcd/saif/none, determin using vcd, saif or none

#  set vcdFileName		""	;# Declare the vcd file name
#  set vcdStripPath		""	;# Define the hierarchy path to which the
					;# vcd file is back-annotated

#  set saifFileName              ""      ;# Declare the saif file name
#  set saifStripPath             ""     ;# Define the hierarchy path to which the saif file is back-annotated

  set ReportPowerLevel		5	;# Define the hierarchy level depth in power report
  set savesession		false	;# true/false To be true, current session will be saved

  set vcdFilePath		""	;
#  set vcdFilePath		""	;# Define this variable if vcd file is under different directory than default				
					;# Default value is ~power/work/vcd
#  set netlistFilePath			;# Define this variable if netlist file is under different directory than default
#  set netlistFileList   	chip_core.lst	;# List all the netlist files that should be read in to perform
						;# Power-analysis process.Default value is $topModuleName.lst
#  set parasiticsFilePath		;# Define this variable if parasitic file is under different directory than default
#-------------------------------------------------------------------------------
# Main part of POWER flow
#-------------------------------------------------------------------------------
#-----------------------------------#
# Include Environment Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl

#-----------------------------------#
# Include Library Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupLib.tcl

#-----------------------------------#
# Include Design Read In Script
#-----------------------------------#
source -echo -verbose $PPScriptPath/designReadIn.tcl

#-----------------------------------#
# Include Parasitic Read In Script
#-----------------------------------#
source -echo -verbose $PPScriptPath/parasiticsReadIn.tcl

#-----------------------------------#
# Include Design Constraint Script
#-----------------------------------#
source -echo -verbose $PPScriptPath/designConstraintIn.tcl

#-----------------------------------#
# Include Post Compile Report Script
#-----------------------------------#
source -echo -verbose $PPScriptPath/designRpt.tcl

#-----------------------------------#
# Include session save script
#-----------------------------------#
if { $savesession == "true" } {
        source -echo -verbose $PPScriptPath/savesession.tcl
}

#quit
