#********************************************************************
#
#      Copyright (c) 2007 HHIC, ALL RIGHTS RESERVED
#
#********************************************************************
#
#      FILENAME:      bfCTSClk.tcl
#
#      DESCRIPTION:
#         This script is used to define clocks and resets in SYN flow
#
#      REVISION:      initial version by juxiaobo 2007/08/15
#
#--------------------------------------------------------------

#-------------------------------------#
# keywords for setting clock model  
#-------------------------------------#
set clockNameList  [list hclk]
set clockPortList  [list hclk]
set clockPinList   [list ]

#-------------------------------------#
# keywords for setting reset model
#-------------------------------------#
set resetNameList [list]
set resetPortList [list]
set resetPinList [list]

#----------------------------#
# reset signal
#----------------------------#
set resetName {POR hresetn}
set resetNameList [concat $resetNameList $resetName]

set resetPort {POR hresetn}
set resetPortList [concat $resetPortList $resetPort]

set resetPin     "" 
set resetPinList [concat $resetPinList $resetPin]

foreach reset_port $resetPortList {
    set_dont_touch_network [get_ports $reset_port]
    set_ideal_network [get_ports $reset_port]
}

foreach reset_pin $resetPinList {
    set_dont_touch_network [get_pins $reset_pin]
    set_ideal_network [get_pins $reset_pin]
}

#----------------------------#
# clk
#----------------------------#
set HCLK_PERIOD    50.0

set HCLK_PERIOD_HALF      [expr $HCLK_PERIOD/2.0]

create_clock -name hclk -period $HCLK_PERIOD -waveform "0 $HCLK_PERIOD_HALF" [get_ports hclk]

set_clock_latency -max 5.0  [get_clocks hclk]
set_clock_latency -min 5.0  [get_clocks hclk]
