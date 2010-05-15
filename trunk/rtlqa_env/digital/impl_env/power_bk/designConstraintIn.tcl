#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designConstraintIn.tcl
#
#      DESCRIPTION:
#         This TCL script is used to generate reports in PP flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { [file exists $ppConstraintPath/PPConstraint.tcl] == 1 } {
      source -echo -verbose $ppConstraintPath/PPConstraint.tcl
} else {
      echo    "Can not find design constraints PPConstraint.tcl\n"
      quit
}

