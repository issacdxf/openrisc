##########################################################################
#
# DUT Sources
#
##########################################################################
 
##########################################################################
#
# Misc Variables
#
##########################################################################

##########################################################################
#
# Make Targets
#
##########################################################################

all:	leda	

leda:
	leda +tcl_shell +tcl_file ./run_leda.tcl |tee ../log/leda.log	\

clean:
	rm -rf leda.cmd
	rm -rf leda_command.log
	rm -rf leda_history.log
	rm -rf leda-libs
	rm -rf leda-logs
	rm -rf leda.pro
	rm -rf prodesign.log
	rm -rf _prodesign_result
	rm -rf ../rpts/*
	rm ../log/*
	rm ../rpts/*
	rm -rf ../work/*

