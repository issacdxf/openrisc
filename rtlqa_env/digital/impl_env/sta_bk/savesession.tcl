#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      savesession.tcl 
#
#      DESCRIPTION:
#         This script is used to save current session in PT flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

set sessionDir "$workPath/session"
if { [file exists $sessionDir] == 1 } { 
  [sh \\rm -r $sessionDir]
  file mkdir $sessionDir
} else {
  file mkdir $sessionDir
}

save_session -replace $sessionDir
