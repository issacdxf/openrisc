module  sparecells (clk, resetn);

input	clk, resetn;
wire    spare_tie_low, spare_tie_high;
wire    spare_na00, spare_nb00, spare_nc00, spare_ne00;
wire    spare_na01, spare_nb01, spare_nc01, spare_nd01, spare_ne01, spare_nf01, spare_ng01;
wire    spare_na02, spare_nb02, spare_nc02, spare_ne02;
wire    spare_na03, spare_nb03, spare_nc03, spare_nd03, spare_ne03, spare_nf03, spare_ng03;

TIE0    SPARE_TIEL	(.O(spare_tie_low)  );
TIE1    SPARE_TIEH	(.O(spare_tie_high) );

NR2T	SPARE_UA00	(.I1(spare_tie_low),	.I2(spare_tie_low),	.O(spare_na00));
INV4	SPARE_UB00	(.I(spare_na00),				.O(spare_nb00));
ND2T	SPARE_UC00	(.I1(spare_tie_high),	.I2(spare_tie_high),	.O(spare_nc00));
XNR2P	SPARE_UE00	(.I1(spare_nb00),	.I2(spare_nc00),	.O(spare_ne00));

NR2T	SPARE_UA01	(.I1(spare_tie_low),	.I2(spare_tie_low),	.O(spare_na01));
INV4	SPARE_UB01	(.I(spare_na01),				.O(spare_nb01));
ND2T	SPARE_UC01	(.I1(spare_tie_high),	.I2(spare_tie_high),	.O(spare_nc01));
INV4	SPARE_UD01	(.I(spare_nc01),				.O(spare_nd01));
MUX2P	SPARE_UE01	(.A(spare_nb01),	.B(spare_nd01),		.S(spare_tie_low),	.O(spare_ne01));
DFFRBP  SPARE_UF01	(.D(spare_ne01), 	.CK(clk), 		.RB(resetn),		.Q(spare_nf01), 	.QB(spare_ng01) );

NR3T	SPARE_UA02	(.I1(spare_tie_low),	.I2(spare_tie_low),	.I3(spare_tie_low),	.O(spare_na02));
INV4	SPARE_UB02	(.I(spare_na02),							.O(spare_nb02));
ND3T	SPARE_UC02	(.I1(spare_tie_high),	.I2(spare_tie_high),	.I3(spare_tie_high),	.O(spare_nc02));
XNR2P	SPARE_UE02	(.I1(spare_nb02),	.I2(spare_nc02),				.O(spare_ne02));

NR3T	SPARE_UA03	(.I1(spare_tie_low),	.I2(spare_tie_low),	.I3(spare_tie_low),	.O(spare_na03));
INV4	SPARE_UB03	(.I(spare_na03),							.O(spare_nb03));
ND3T	SPARE_UC03	(.I1(spare_tie_high),	.I2(spare_tie_high),	.I3(spare_tie_high),	.O(spare_nc03));
INV4	SPARE_UD03	(.I(spare_nc03),							.O(spare_nd03));
MUX2P	SPARE_UE03	(.A(spare_nb03),	.B(spare_nd03),		.S(spare_tie_low),	.O(spare_ne03));
DFFRBP  SPARE_UF03	(.D(spare_ne03), 	.CK(clk), 		.RB(resetn),		.Q(spare_nf03), 	.QB(spare_ng03) );

endmodule
