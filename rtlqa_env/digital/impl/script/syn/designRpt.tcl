#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      designRpt.tcl
#
#      DESCRIPTION:
#         This script is used to report kinds of result in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

if { [ file exists $rptDir ] == 1 } {
} else {
  file mkdir $rptDir
}

if { [ file exists $rptDir/current ] == 1 } {
  exec mv $rptDir/current $rptDir/20[clock format [clock seconds] -format "%y%m%d_%H%M"]
}

file mkdir $rptDir/current
set rptDir $rptDir/current

current_design $topModuleName

###############
# timing exception
###############    
if {$rptTimingExcept == "true"} {   
  redirect [file join $rptDir reportTimingRequirements.rpt] {
    echo "Info : report_timing_requirements "
    report_timing_requirements
    echo ""
    echo "Info : report_timing_requirements -ignored"
  }
}

if {$rptCheckTiming == "true"} {   
  redirect [file join $rptDir checkTiming.rpt] { check_timing }

  redirect [file join $rptDir reportTimingLoops.rpt ] \
    { report_timing -loops -max_paths 50 }
}

###############
# clock
###############
if {$rptClkInfo == "true"} { 
  redirect [file join $rptDir reportPathGroup.rpt] { report_path_group }

  redirect [file join $rptDir reportClockAttributeSkew.rpt] \
    { report_clock -attributes -skew }

  redirect [file join $rptDir reportTransitiveFanout.rpt] \
    { report_transitive_fanout -clock_tree }

  set rptFile [file join $rptDir reportClockFanout_Summary.rpt]
  set clockList [concat $clockPortList $clockPinList]
  redirect $rptFile { 
    echo "" 
    echo "  clock_list: $clockNameList"  
    echo ""  
    echo "" 
    echo ">> Report All Seq. Cells(FF,Latch,MSFF) Clocked by Clock Source" 
    echo ""       
  } 
  redirect [file join $rptDir reportClockFanout_ClockedSeqCellOnly.rpt] {
    echo "" 
    echo "  clock_list: $clockNameList"  
    echo ""  
    echo "" 
    echo ">> Report All Seq. Cells(FF,Latch,MSFF) Clocked by Clock Source" 
    echo "" 
    foreach clock_name $clockNameList {
      # Collection Produced by all_registers
      set clocked_cell_coll [all_registers -cells -clock $clock_name] 
      set clocked_cell_cnt 0

      foreach_in_collection clocked_cell $clocked_cell_coll {
        set cked_cell [get_attribute $clocked_cell full_name]
        set clocked_cell_cnt [expr $clocked_cell_cnt + 1]
        echo "Info: Clock Name: $clock_name Clocked to Seq. Cell: $cked_cell"  
      }
      redirect -append $rptFile { echo "Info: Clocked Seq. Cells Count= $clocked_cell_cnt for $clock_name" } 
      echo "Info: Clocked Seq. Cells Count= $clocked_cell_cnt for $clock_name"  
      echo ""  
    }
  } 
  
  redirect -append $rptFile { 
    echo ""  
    echo "" 
    echo ">> Report All Seq.(FF,Latch,MSFF)/Com.(AND,...) Cells in Transitive Fanout from Clock Source" 
    echo ""       
  }    
  redirect [file join $rptDir reportClockFanout_TransitiveConnectedCell.rpt] {
    echo "" 
    echo "  clock_list: $clockNameList"  
    echo ""   
    echo "" 
    echo ">> Report All Seq.(FF,Latch,MSFF)/Com.(AND,...) Cells in Transitive Fanout from Clock Source"        
    echo "" 
    foreach clock_name $clockList {
      # Collection Produced by all_fanout
      set clocked_cell_coll [all_fanout -from $clock_name -only_cells -flat]
      set clocked_cell_cnt 0
  
      foreach_in_collection clocked_cell $clocked_cell_coll {
        set cked_cell [get_attribute $clocked_cell full_name]
        set clocked_cell_cnt [expr $clocked_cell_cnt + 1]
        echo "Info: Clock Port/Pin: $clock_name Transitive-Connected to Seq./Com. Cell: $cked_cell"  
      }
      redirect -append $rptFile { echo "Info: Transitive-Connected Seq./Com. Cells Count= $clocked_cell_cnt for $clock_name" }
      echo "Info: Transitive-Connected Seq./Com. Cells Count= $clocked_cell_cnt for $clock_name"  
      echo ""  
    }
  }
  
  redirect -append $rptFile { 
    echo ""  
    echo "" 
    echo ">> Report All Seq.(FF,Latch,MSFF)/Com.(AND,...) Cells Direct-Connected from Clock Source" 
    echo ""       
  }     
  redirect [file join $rptDir reportClockFanout_DirectConnectedCell.rpt] {
    echo "" 
    echo "  clock_list: $clockNameList"  
    echo ""   
    echo "" 
    echo ">> Report All Seq.(FF,Latch,MSFF)/Com.(AND,...) Cells Direct-Connected from Clock Source" 
        
    echo "" 
    foreach clock_name $clockList {

      # Collection Produced by all_fanout
      set clocked_cell_coll [all_fanout -from $clock_name -only_cells -flat -levels 1]
      set clocked_cell_cnt 0
  
      foreach_in_collection clocked_cell $clocked_cell_coll {
        set cked_cell [get_attribute $clocked_cell full_name]
        set clocked_cell_cnt [expr $clocked_cell_cnt + 1]
        echo "Info: Clock Port/Pin: $clock_name Direct-Connected to Seq./Com. Cell: $cked_cell"  
      }
      redirect -append $rptFile { echo "Info: Direct-Connected Seq./Com. Cells Count= $clocked_cell_cnt for $clock_name" }
      echo "Info: Direct-Connected Seq./Com. Cells Count= $clocked_cell_cnt for $clock_name"  
      echo ""  
    }  
  }
}

###############
# report design
###############
if {$rptDesignInfo == "true"} {   
  redirect [file join $rptDir reportDesign.rpt] { report_design }

  redirect [file join $rptDir reportPort.rpt] { report_port -verbose }

  redirect [file join $rptDir reportAttributePort.rpt] \
    { report_attribute -port }
    
  redirect [file join $rptDir reportNetTransitionTimes.rpt] \
    { report_net -transition_times }
    
  redirect [file join $rptDir reportCell.rpt] \
    { report_cell }        

  redirect [file join $rptDir reportHighFanoutNet.rpt] \
    { report_net_fanout -threshold 50 }
  
  if {$compileDesign == "true" } {   
    redirect [file join $rptDir reportPartitions.rpt] \
      { report_partitions }      
  }
  
  if {$padCellName != ""} { 
    redirect [file join $rptDir reportPadCell.rpt] \
    { report_cell -connections [get_cells $padCellName] }        
  }
  
  redirect [file join $rptDir checkDesign.rpt] { check_design }

  redirect [file join $rptDir problemCells.rpt] {
    echo "Info : unmapped cells"
    get_cells "*" -filter "@is_unmapped == true"
    echo ""
    echo "Info : black_box cells"
    get_cells "*" -filter "@is_black_box==true"
    echo ""
  }

  redirect [file join $rptDir link.rpt] { link }

  redirect [file join $rptDir reportResources.rpt] { report_resources }

  redirect [file join $rptDir reportQOR.rpt] { report_qor }
  
  redirect [file join $rptDir reportCompileOptions.rpt] { report_compile_options }    
}

###############
# hierarchy
###############
if {$rptHierarchy == "true"} {   
  redirect [file join $rptDir reportHierarchy.rpt] { report_hierarchy }

  redirect [file join $rptDir listInstances.rpt] {
    echo "Info : list_instances -hierarchy -max_levels 1"
    list_instances -hierarchy -max_levels 1

    echo "Info : list_instances -hierarchy -max_levels 2"
    list_instances -hierarchy -max_levels 2

    echo "Info : list_instances -hierarchy -max_levels 3"
    list_instances -hierarchy -max_levels 3

    echo "Info : list_instances -hierarchy -max_levels 4"
    list_instances -hierarchy -max_levels 4
  }
}

###############
# area
###############
if {$rptAreaInfo == "true"} {     
  redirect [file join $rptDir reportArea.rpt] { 
    report_area
    
    echo ""
    echo ""
    echo "********************************"
    echo "*  Report area for sub-blocks  *"
    echo "********************************"
    foreach_in_collection hCell [get_cells "*" -filter "@is_hierarchical == true"] {
        set count 0
        set design_name [get_attribute $hCell ref_name]
        current_design $design_name
        redirect temp.txt report_area
        set fileID [open temp.txt r]
        while {[gets $fileID line] >= 0} {
          regexp {(Total cell area:)(\s+)(.*)} $line m1 m2 m3 area
        }
        foreach_in_collection sub_item [get_cells "*" -hier] { incr count }
        echo "The cell counts of the design $design_name : $count"
        echo "The cell area is : $area"
        echo ""
        close $fileID
        file delete temp.txt
    }
  }
  current_design $topModuleName
}

###############
# timing constraint
###############
if {$rptTimingCnst == "true"} {   
  redirect [file join $rptDir reportDisableTiming.rpt] { report_disable_timing }
  
  redirect [file join $rptDir reportCaseAnalysis.rpt] { report_case_analysis }    

  redirect [file join $rptDir reportConstraint.rpt] { 
    echo "Info : report_constraint"
    report_constraint 
    echo ""
    echo "Info : report_constraint -all_violators"
    report_constraint -all_violators
    echo ""
    echo "Info : report_constraint -all_violators -verboes"
    report_constraint -all_violators -verbose
    echo ""
    echo "Info : report_constraint -max_fanout -verboes"
    report_constraint -max_fanout -verbose
    echo ""
    echo "Info : report_constraint -max_transition -verboes"
    report_constraint -max_transition -verbose
  }
}

###############
# delay path
###############
if {$rptMaxDelayPath == "true"} {   
  redirect [file join $rptDir reportTimingMaxDelay.rpt] { 
    report_timing  -nets                     \
                   -transition_time          \
                   -input_pins               \
                   -capacitance              \
                   -path      full_clock     \
                   -delay     max            \
                   -nworst  2  \
                   -max_paths 5
  }
}

if {$rptMinDelayPath == "true"} {   
  redirect [file join $rptDir reportTimingMinDelay.rpt] { 
    report_timing  -nets                     \
                   -transition_time          \
                   -input_pins               \
                   -capacitance              \
                   -path      full_clock     \
                   -delay     min            \
                   -nworst 2    \
                   -max_paths 5
  }
}  

if {$rptBufferTree == "true"} {
  redirect [file join $rptDir ClockBufferTree.rpt] {
    foreach my_clock $clockPinList {
                report_buffer_tree -from $my_clock -hier
    }
  }
  redirect [file join $rptDir ResetBufferTree.rpt] {
    foreach my_reset $resetPin {
                report_buffer_tree -from $my_reset -hier 
    }
  }
}

