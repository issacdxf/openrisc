#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      runtmax.tcl
#
#      DESCRIPTION:
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#----------------------------------------------------------------------

set runSetType 		TMAX
set projectName		des

set topModuleName 	des
set UserDefineProtocol 	false

set FileList 		"./top.lst"
set_rule N29 warning
#-------------------------------------------------------------------------------
# Main part of TMAX flow
#-------------------------------------------------------------------------------
#-----------------------------------#
# Include Environment Setup Script
#-----------------------------------#
source -echo -verbose ../../script/con/setupEnv.tcl
source -echo -verbose ../../script/con/setupVar.tcl

#-----------------------------------#
# Include Design Read In Script
#-----------------------------------#
source -echo -verbose $tmaxScriptPath/designReadIn.tcl

#-----------------------------------#
# Include Design Build Script
#-----------------------------------#
source -echo -verbose $tmaxScriptPath/designBuild.tcl

#-----------------------------------#
# Include Design Report Script
#-----------------------------------#
source -echo -verbose $tmaxScriptPath/designRpt.tcl

#quit
