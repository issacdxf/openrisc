srcSourceCodeView
srcResizeWindow 8 56 804 500
debImport "-2001" "-f" "rwork.lst"
srcResizeWindow -4 2 1210 1000
srcHBSelect "des" -win $_nTrace1
srcSetScope -win $_nTrace1 "des" -delim "."
debReload
srcHBSelect "des" -win $_nTrace1
srcSelect -win $_nTrace1 -range {42 42 3 3}
srcHBSelect "des" -win $_nTrace1
srcSetScope -win $_nTrace1 "des" -delim "."
srcDeselectAll -win $_nTrace1
debReload
srcHBSelect "AN2" -win $_nTrace1
srcSelect -win $_nTrace1 -range {25 25 3 3}
srcHBSelect "tffsb_udp" -win $_nTrace1
srcHBSelect "DES" -win $_nTrace1
srcSetScope -win $_nTrace1 "DES" -delim "."
debReload
srcHBSelect "AN2" -win $_nTrace1
srcSelect -win $_nTrace1 -range {25 25 3 3}
srcHBSelect "des" -win $_nTrace1
srcSetScope -win $_nTrace1 "des" -delim "."
