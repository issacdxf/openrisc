#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      parasiticsReadIn.tcl
#
#      DESCRIPTION:
#         This TCL script is used to generate reports in PP flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------
if  { $parasiticsFileFormat == "WLM"} {
  if { $WireLoadModel == "AUTO" } {
        echo "Using Auto Wireload Selection\n"
        set auto_wire_load_selection true
      } elseif { $WireLoadModel == "NONE" } {
        echo "Using No Wireload Model\n"
        remove_wire_load_model
        remove_wire_load_selection_group
        set auto_wire_load_selection false
      } else {
        echo "Using Wireload model $WireLoadModel"
        set auto_wire_load_selection false
        set_wire_load_mode top
        set_wire_load_model -name $WireLoadModel [current_design]
      }
} elseif { $OperatingCondition == "WC" } {
  if { [file exists $parasiticsFilePath/$MaxparasiticsFileName] == 1 } {
    echo "read_parasitics $parasiticsFilePath/$MaxparasiticsFileName -format $parasiticsFileFormat\n"
    read_parasitics $parasiticsFilePath/$MaxparasiticsFileName -format $parasiticsFileFormat
  } else {
    echo    "Can not find design parasitics $MaxparasiticsFileName\n"
    quit
  }
} elseif { $OperatingCondition == "BC" } {
  if { [file exists $parasiticsFilePath/$MinparasiticsFileName] == 1 } {
    echo "read_parasitics $parasiticsFilePath/$MinparasiticsFileName -format $parasiticsFileFormat\n"
    read_parasitics $parasiticsFilePath/$MinparasiticsFileName -format $parasiticsFileFormat
  } else {
    echo    "Can not find design parasitics $MinparasiticsFileName\n"
    quit
  }
}

if { $ToggleFileType == "vcd" } {
	if { [file exists $vcdFileName] == 1 } {
		echo "read_vcd -strip_path $vcdStripPath $vcdFileName\n"
		read_vcd -strip_path $vcdStripPath $vcdFileName
	} else {
  	echo "Can not find VCD file $vcdFileName\n"
	}
} elseif { $ToggleFileType == "saif" } {
	if { [file exists $saifFileName] == 1 } {
		echo "read_saif -strip_path $saifStripPath $saifFileName\n"
		read_saif -strip_path $saifStripPath $saifFileName
	} else {
  	echo "Can not find SAIF file $saifFileName\n"
	}
} elseif { $ToggleFileType == "none" } {
		echo "Using default Toggle Rate to propapate\n"
}
