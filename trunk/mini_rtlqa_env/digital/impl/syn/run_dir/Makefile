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

all:	syn	

syn:
	dc_shell-xg-t -wait 1 -f rundc.tcl |tee ../log/dc.log	\

clean:
	mv command.log ../log/
	mv filenames.log ../log/
	rm ../log/*
	rm ../rpts/*
	rm -rf ../work/*
	rm -rf ../rpts/*
	rm -rf ../work/ddc/*
	rm -rf ../work/milkyway/*
	rm -rf ../work/net/*
	rm -rf ../work/SDC/*
	rm -rf ../work/sourceDb/*
	rm -rf ../work/SPEF/*
	rm -rf ../work/svf_dir/*
	rm -rf ../work/template/*

