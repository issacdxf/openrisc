#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      cnstDsg.tcl
#
#      DESCRIPTION:
#         This script is used to constraint the design in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

current_design $topModuleName

#-----------------------------------#
# Set Operating condition Constraints
#-----------------------------------#
set_operating_conditions $maxOptCond -library $maxLibName

set auto_wire_load_selection false
set_wire_load_mode top
set_wire_load_model -max -lib $maxLibName -name enG500K

#-----------------------------------#
# Source Design Rule Constraint 
#-----------------------------------#
source -echo -verbose $dtclConstraintPath/drcCnst.tcl

#-----------------------------------#
# Source Optimization Constraint
#-----------------------------------#

# Creat Clocks  
source -echo -verbose $dtclConstraintPath/bfCTSClk.tcl

# IO timing definition
source -echo -verbose $dtclConstraintPath/ioCnst.tcl


#-----------------------------------#
# Source Timing Exception Constraint
#-----------------------------------#
source -echo -verbose $dtclConstraintPath/dontTouch.tcl
source -echo -verbose $dtclConstraintPath/timeExcpt.tcl

#-----------------------------------#
# Source Case Analysis Constraints
#-----------------------------------#

