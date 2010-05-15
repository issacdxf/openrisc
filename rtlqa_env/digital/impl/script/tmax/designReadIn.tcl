if { [file exists $FileList] == 1 } {
  set filelist [sh cat $FileList]
  foreach tmax_file $filelist {
		echo "tmax_file is $tmax_file"
		echo "file exists $tmax_file is [file exists $tmax_file]"
    if { [file exists $tmax_file] == 1 } {
      read_netlist $tmax_file
    } else {
      echo "\n\nCan not find file $tmax_file! Please check it.\n\n"
    }
  }
} else {
  echo "\n\nCan not find the List file $FileList.Please check it and run again.\n\n"
}

if { [file exists $tmaxConstraintPath/AddBlackBox.tcl] == 1 } {
  source -echo -verbose $tmaxConstraintPath/AddBlackBox.tcl
}

if { [file exists $tmaxConstraintPath/remove_analog.tmax.tcl] == 1 } {
  source -echo -verbose $tmaxConstraintPath/remove_analog.tmax.tcl
}
