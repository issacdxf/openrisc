// 内存（RTL代码）
// 数据字节宽

module mem_U1 (
	input					clk,
	input					rst,
	input		[13:0]		adr,
	input		[7:0]		dat_i,
	output	reg	[7:0]		dat_o,
	input					we,
	input					en
);

	wire	[10:0]	addr = adr[10:0];

	// 按 2KB 一个区域划分
	wire en_0 = en&&(adr[13:11]==3'h0);
	wire en_1 = en&&(adr[13:11]==3'h1);
	wire en_2 = en&&(adr[13:11]==3'h2);
	wire en_3 = en&&(adr[13:11]==3'h3);
	wire en_4 = en&&(adr[13:11]==3'h4);
	wire en_5 = en&&(adr[13:11]==3'h5);
	wire en_6 = en&&(adr[13:11]==3'h6);
	wire en_7 = en&&(adr[13:11]==3'h7);

	wire	[7:0]	dat_o_0,dat_o_1,dat_o_2,dat_o_3,dat_o_4,dat_o_5,dat_o_6,dat_o_7;

	always @ (*)
		if(en)
			case(adr[13:11])
				3'h0: dat_o = dat_o_0;
				3'h1: dat_o = dat_o_1;
				3'h2: dat_o = dat_o_2;
				3'h3: dat_o = dat_o_3;
				3'h4: dat_o = dat_o_4;
				3'h5: dat_o = dat_o_5;
				3'h6: dat_o = dat_o_6;
				3'h7: dat_o = dat_o_7;
				default: dat_o = 8'h0;
			endcase
		else
			dat_o = 8'h0;

RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE
	.INIT_02( 256'h0000000000000000000000000000000000000000000000004000424021402120 ), // Address 0x100 : 256
	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_0 (
	.DO  ( dat_o_0 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_0 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE
	.INIT_00( 256'he28482e260036282e282e260e28482e260036282e282e260e28482e260410121 ), // Address 0x2000 : 8192
	.INIT_01( 256'h6282e282e2648260e26362e28482e260e28482e260e282e260036282e282e260 ), // Address 0x2080 : 8320
	.INIT_02( 256'he260e28482e262e28482e260036282e282e2846282e262e282e260e282e26003 ), // Address 0x2100 : 8448
	.INIT_03( 256'h6282e26362e282e260e28482e260e28482e260036282e282e2846282e262e282 ), // Address 0x2180 : 8576
	.INIT_04( 256'h8482e262e282e26362e28482e260e282e262e2410121210041036282e282e284 ), // Address 0x2200 : 8704
	.INIT_05( 256'he282e262e28482e26362e28000002362e282048262e262e28000ff00002362e2 ), // Address 0x2280 : 8832
	.INIT_06( 256'h6362e282e262e28482e26362e280048262e262e280e26000ff00002482e26362 ), // Address 0x2300 : 8960
	.INIT_07( 256'h62e26362e26362e262e262e26362e26362e26041012121004100ff00000482e2 ), // Address 0x2380 : 9088
	.INIT_08( 256'he26362e2636000ff0141012121004162e262e262e262e26362e26000ff000003 ), // Address 0x2400 : 9216
	.INIT_09( 256'h62e200ff00ffe262e26362e26200ff62e26362e26200000362e26362e262e262 ), // Address 0x2480 : 9344
	.INIT_0A( 256'h30303030303030303030216c2065002100412100ff00ff62e26362e26362e263 ), // Address 0x2500 : 9472
	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_1 (
	.DO  ( dat_o_1 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_1 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_2 (
	.DO  ( dat_o_2 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_2 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_3 (
	.DO  ( dat_o_3 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_3 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_4 (
	.DO  ( dat_o_4 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_4 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_5 (
	.DO  ( dat_o_5 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_5 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_6 (
	.DO  ( dat_o_6 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_6 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation
RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE

	.INITP_00( ), .INITP_01( ), .INITP_02( ), .INITP_03( ), .INITP_04( ), .INITP_05( ),	.INITP_06( ), .INITP_07( )
) MEM_7 (
	.DO  ( dat_o_7 ),   // 8-bit Data Output
	.DOP (  ),  // 1-bit parity Output
	.ADDR( addr ), // 11-bit Address Input
	.CLK ( clk ),  // Clock
	.DI  ( dat_i ),   // 8-bit Data Input
	.DIP ( 1'b0 ),  // 1-bit parity Input
	.EN  ( en_7 ),   // RAM Enable Input
	.SSR ( rst ),  // Synchronous Set/Reset Input
	.WE  ( we )    // Write Enable Input
);
// End of RAMB16_S9_inst instantiation


endmodule
