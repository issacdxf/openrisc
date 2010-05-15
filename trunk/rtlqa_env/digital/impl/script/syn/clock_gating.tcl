set_clock_gating_style -sequential_cell latch \
                       -minimum_bitwidth 4 \
                       -control_signal test_mode \
                       -control_point after \
                       -observation_point true
