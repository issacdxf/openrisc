#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      insert_sparecell.tcl
#
#      DESCRIPTION:
#         This script is used to insert sparecell in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

set clk_type ""

set designList [list]
set designList [concat $designList des]

read_file -f verilog ../../script/syn/hjtc018_sparecells.v

foreach item_name $designList {
    current_design $item_name
    if { $item_name == "des" } {    
      set  SPARE_COUNT 1
      set clk_type "hclk"
    }

   for {set x 0} {$x< $SPARE_COUNT} {incr x} {
     copy_design sparecells $item_name\_spares_$x
     current_design $item_name
     create_cell  u_$item_name\_spares_$x $item_name\_spares_$x
     if { $clk_type == "hclk" } {
       connect_net  hclk     [get_pin u_$item_name\_spares_$x/clk]
       connect_net  hresetn  [get_pin u_$item_name\_spares_$x/resetn]
     } elseif {$clk_type == "pclk"} {
       connect_net  pclk     [get_pin u_$item_name\_spares_$x/clk]
       connect_net  presetn  [get_pin u_$item_name\_spares_$x/resetn]
     }
   }
}

current_design $topModuleName 
set_dont_touch [get_cells *SPARE* -hier  -filter "is_hierarchical == false"]
