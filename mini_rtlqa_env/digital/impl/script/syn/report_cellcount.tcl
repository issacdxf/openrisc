#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      report_cellcount.tcl
#
#      DESCRIPTION:
#         This script is used to report cell counts in design in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

set cells_collection [get_cells -hier *]
foreach_in_collection my_cell $cells_collection {
			set my_cell_is_hier [get_attribute $my_cell is_hierarchical]
			set my_cell_name [get_attribute $my_cell name]
			if {[ string match "true" $my_cell_is_hier ] == 1} {
				set cells_collection [remove_from_collection $cells_collection $my_cell]
#				echo "remove hierarchical cell $my_cell_name from collection\n"
			}
}
echo "The total cell count is "
sizeof_collection $cells_collection
#foreach_in_collection my_cell $cells_collection {
#			set my_cell_is_comb [get_attribute $my_cell is_combinational]
#			if {[ string match "true" $my_cell_is_comb ] == 1} {
#				set cells_collection [remove_from_collection $cells_collection $my_cell]
#			}
#}
#echo "The total sequential cell count is "
#sizeof_collection $cells_collection
