// 内存（RTL代码）
// 数据字节宽

module mem_U2 (
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
				default: dat_o = 8'bx;
			endcase
		else
			dat_o = 8'bz;

RAMB16_S9 #(
	.INIT(9'h000),					// Value of output RAM registers at startup
	.SRVAL(9'h000),					// Output value upon SSR assertion
	.WRITE_MODE("WRITE_FIRST"),		// WRITE_FIRST, READ_FIRST or NO_CHANGE
	.INIT_02( 256'h0000000000000000000000000000000000000000000000480010240010ffa500 ), // Address 0x100 : 256
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
	.INIT_00( 256'h2700ff1f9020ffff27ff1f002700ff1f9020ffff27ff1fff2700ff1f900010ff ), // Address 0x2000 : 8192
	.INIT_01( 256'hffff27ff1f18ffff1f00ff2700ff1f902700ff1f9027ff1f0120ffff27ff1f00 ), // Address 0x2080 : 8320
	.INIT_02( 256'h1fff2700ff1fff2700ff1f9020ffff27ff2718ffff1fff27ff1fff27ff1f9020 ), // Address 0x2100 : 8448
	.INIT_03( 256'hffff1f00ff27ff1f002700ff1f902700ff1f9020ffff27ff2718ffff1fff27ff ), // Address 0x2180 : 8576
	.INIT_04( 256'h00ff1fff27ff1f00ff2700ff1f9027ff1fff1f0010ff00480020ffff27ff2718 ), // Address 0x2200 : 8704
	.INIT_05( 256'h27ff1fff2700ff1f00ff2790000000ff27ff18ffff1fff279000ff000000ff27 ), // Address 0x2280 : 8832
	.INIT_06( 256'h00ff27ff1fff2700ff1f00ff279018ffff1fff27001f9000ff000000ff1f00ff ), // Address 0x2300 : 8960
	.INIT_07( 256'hff1f00ff1f00ff1fff1fff1f00ff1f00ff1f900010ff00480000ff000000ff1f ), // Address 0x2380 : 9088
	.INIT_08( 256'h1f00ff1f250000fe480010ff004800ff1fff1fff1fff1f00ff1f9000ff000000 ), // Address 0x2400 : 9216
	.INIT_09( 256'hff5f00ff00ff1fff1f00ff1fff00ffff1f00ff1fff000000ff1f00ff1fff1fff ), // Address 0x2480 : 9344
	.INIT_0A( 256'h303030303030303030300a64776c250048000000ff00ffff1f00ff1f00ff1f00 ), // Address 0x2500 : 9472
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
