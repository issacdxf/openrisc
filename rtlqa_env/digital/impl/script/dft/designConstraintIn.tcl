#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designConstraintIn.tcl
#
#      DESCRIPTION:
#         This script is used to read in the design constraints in DFT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------
  if { $AutoFix == "true" } {
    if { [file exists $dftConstraintPath/AutoFix.tcl] == 1 } {
          source -echo -verbose $dftConstraintPath/AutoFix.tcl
    } else {
          echo    "Can not find design constraints AutoFix.tcl\n"
          quit
    }
  }	  
  
  if { [file exists $dftConstraintPath/DefineScanConfig.tcl] == 1 } {
          source -echo -verbose $dftConstraintPath/DefineScanConfig.tcl
  } else {
          echo    "Can not find design constraints DefineScanConfig.tcl\n"
          quit
  }
  if { [file exists $dftConstraintPath/DefineScanSignal.tcl] == 1 } {
          source -echo -verbose $dftConstraintPath/DefineScanSignal.tcl
  } else {
          echo    "Can not find design constraints DefineScanSignal.tcl\n"
          quit
  }
  if { [file exists $dftConstraintPath/DefineScanHold.tcl] == 1 } {
          source -echo -verbose $dftConstraintPath/DefineScanHold.tcl
  } else {
          echo    "Can not find design constraints DefineScanHold.tcl\n"
          quit
  }
  if { [file exists $dftConstraintPath/ScanException.tcl] == 1 } {
          source -echo -verbose $dftConstraintPath/ScanException.tcl
  } else {
          echo    "Can not find design constraints ScanException.tcl\n"
          quit
  }

