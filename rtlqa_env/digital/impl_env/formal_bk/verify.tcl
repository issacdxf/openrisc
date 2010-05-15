#----------------------------------------------------------------------
#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      verify.tcl
#
#      DESCRIPTION:
#        verify script for formal verification in FM flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15 
#
#----------------------------------------------------------------------

redirect [file join $rptDir $topModuleName.report_black_box] {
	report_black_boxes -all
}
redirect [file join $rptDir $topModuleName.report_constants] {
	report_constants
}	
redirect [file join $rptDir $topModuleName.report_constraint] {
	report_constraint -long 
}
redirect [file join $rptDir $topModuleName.report_ref_loops] {
	report_loops -ref -unfold
}
redirect [file join $rptDir $topModuleName.report_impl_loops] {
	report_loops -imp -unfold
}

match

redirect [file join $rptDir $topModuleName.report_unmatch_points] {
	report_unmatched_points
}
redirect [file join $rptDir $topModuleName.report_match_points] {
	report_matched_points
}

if { ! [verify] } {
	redirect [file join $rptDir $topModuleName.report_failing_points] {
		report_failing_points 
	}
	redirect [file join $rptDir $topModuleName.report_aborted_points] {
		report_aborted_points
	}
 	redirect [file join $rptDir $topModuleName.report_mismatches] {
		report_hdlin_mismatches -verbose -reference -implementation
 	}

  set error_count [incr error_count]
}

if { $savesession == "true" } {
    save_session -replace $sessionDir/$topModuleName.fss
}
