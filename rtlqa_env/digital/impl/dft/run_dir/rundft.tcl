#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      rundft.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

#================ Parameters Setting ===============#
set runSetType 		DFT		;# runSetType defines script category,RTL-QA flow will use
					;# this variable to setup stage-process environments
set projectName 	des		;#

set runDFTstage         syn             ;# syn/bsd From syn or from bsd phase

set AutoFix		false		;# true/false To be true,DFT-compiler will autofix drc violations

set ReCompile		false           ;# true/false To be true,DFT-compiler will perform incremental 
					;# compile to re-optimize design after dft insertion
set topModuleName       des		;# Define top-module name to perform DFT

set ReadFileFormat      netlist         ; # ddc/netlist. Determine what kind of files to read in during DFT
														; # In DCT mode, the ReadFileFormat will be default as ddc
set ScanChainNum        4; # Number of external scan chains


# Below variables are for Scan Compression use
# If the ScanCompression is set to true, ScanCompRate will be used .

set ScanCompression    false; # true/false
set ScanCompRate       2; # number to determine scan compression rate
												; # The internal scan number will be ScanChainNum * ScanCompRate * 1.2


# ===================== Flow Control ========================#
#-----------------------------------#
# Include Library Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl
source -echo -verbose $LibrarySetupPath/setupLib.tcl

#-----------------------------------#
# Include Design Read In Script
#-----------------------------------#
source -echo -verbose $dftScriptPath/designReadIn.tcl

current_design $topModuleName
link

#-----------------------------------#
# Include Design Constraint Script
#-----------------------------------#
source -echo -verbose $dftScriptPath/designConstraintIn.tcl

#-----------------------------------#
# Include Design Verify Script
#-----------------------------------#
source -echo -verbose $dftScriptPath/InsertScan.tcl

if { $ReCompile == "true" } {
  source -echo -verbose $dftScriptPath/designReCompile.tcl
}

#-----------------------------------#
# Include Design Output Script
#-----------------------------------#
source -echo -verbose $dftScriptPath/designOutput.tcl

quit
