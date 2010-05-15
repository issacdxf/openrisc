run_build $topModuleName

if { $UserDefineProtocol == "true" } {
  if { [file exists $tmaxConstraintPath/UserDefineProtocol.tcl] == 1 } {
    source -echo -verbose $tmaxConstraintPath/UserDefineProtocol.tcl
    set_drc -remove_false_clocks
    run_drc
  } else {
    echo "Can not find protocol file $tmaxConstraintPath/UserDefineProtocol!  Plese check it\n"
    quit
  }
} else {
  if { [file exists $protocolPath/${topModuleName}.spf] == 1 } {
    set_drc -remove_false_clocks
    run_drc $protocolPath/${topModuleName}.spf
  } else {
    echo "Can not find protocol file $protocolPath/${topModuleName}.spf!! Please check it\n"
  }
}

set_faults -model stuck

if { [file exists $tmaxConstraintPath/AddNoFaults.tcl] == 1 } {
  source -echo -verbose $tmaxConstraintPath/AddNoFaults.tcl
}

add_faults -all

run_atpg -auto
