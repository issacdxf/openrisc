rule_select -file $ledaScriptPath/leda_default.tcl

if { $CheckDC == "true" } {
rule_select -file $ledaScriptPath/leda_dc.tcl
}
if { $CheckDW == "true" } {
rule_select -file $ledaScriptPath/leda_designware.tcl
}
if { $CheckDFT == "true" } {
rule_select -file $ledaScriptPath/leda_dft.tcl
}
if { $CheckFM == "true" } {
rule_select -file $ledaScriptPath/leda_formality.tcl
}

set RTLFileList [exec cat $hdlFileList]
foreach rtlfile $RTLFileList {
  echo "\n\n\nPerform $rtlfile Reading ..........................\n\n\n"
  if { [file exists $hdlFilePath/$rtlfile] == 1 } {
    if { [file extension $rtlfile ] == ".v" || [file extension $rtlfile ] == ".V" || [file extension $rtlfile ] == ".vg" || [file extension $rtlfile] == ".VG" || [file extension $rtlfile] == ".inc" || [file extension $rtlfile] == ".INC"} {
      read_verilog [file join $hdlFilePath $rtlfile] +v2k
    } elseif { [file extension $rtlfile] == ".vhdl" || [file extension $rtlfile] == ".VHDL" || [file extension $rtlfile] == ".vhd" || [file extension $rtlfile] == ".VHD"} {
      read_vhdl $hdlFilePath/$rtlfile
    } else {
      echo "\n\n\nERROR: File $rtlfile can not be recognized\n\n\n"
      quit
    }
  } else {
    echo "\n\nCan not find file $rtlfile! Please check it.\n\n"
    quit
  }
}
current_design $topModuleName
elaborate 

