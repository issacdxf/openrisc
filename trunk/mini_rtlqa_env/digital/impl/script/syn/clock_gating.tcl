set_clock_gating_style -sequential_cell latch \
                       -positive_edge_logic integrated \
                       -minimum_bitwidth 16 \
                       -control_signal test_mode \
                       -control_point before
