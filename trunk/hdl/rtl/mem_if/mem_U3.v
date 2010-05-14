// 内存（RTL代码）
// 数据字节宽

module mem_U3 (
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
	.INIT_02( 256'h0000000000000000000000000000000000000000000000000000500003fd5400 ), // Address 0x100 : 256
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
	.INIT_00( 256'hd803d4d40000e8dfdfe0e000e801e4e40000f8efeff0f0c7f802f4f400bc0044 ), // Address 0x2000 : 8192
	.INIT_01( 256'hc4afafb0b004b780b700bcbc03b8b800c403c0c000fcc8c84500d8cfcfd0d003 ), // Address 0x2080 : 8320
	.INIT_02( 256'h78ff84888080fc8c0188880000a89393949403a39b9ba4a39c9cffa4fca80000 ), // Address 0x2100 : 8448
	.INIT_03( 256'h5b535300605b54547f60035c5c006803646400008c6f6f7070037f7777847f78 ), // Address 0x2180 : 8576
	.INIT_04( 256'h20e4e4fefeebeb00f0f005ecec00fff7f7f8f864009cbc000000684b4b4c4c03 ), // Address 0x2200 : 8704
	.INIT_05( 256'hc4fefecbcb00d0d005cccc0000200ad4d4ff00dcdbdbffdc0000ed000400e0e0 ), // Address 0x2280 : 8832
	.INIT_06( 256'h60a4a4fefeabab00b0b005acac0000bcb7b7b8b80dbc0000ed000400c0c020c4 ), // Address 0x2300 : 8960
	.INIT_07( 256'he0e001e4e401e8e8ffffefef00f4f405f0f0003000d064000000ed000460a0a0 ), // Address 0x2380 : 9088
	.INIT_08( 256'hf400f8f8440000e8003c04c4300000f8f8d4d4fefedbdb00dcdc0000ea000400 ), // Address 0x2400 : 9216
	.INIT_09( 256'hd8d800ae00e8fcdcdc01e0e0fc0059e4e400e8e8fc001300ecec00f0f0fcfcf4 ), // Address 0x2480 : 9344
	.INIT_0A( 256'h3030303030303030303000216f6c483c00040000f10041d0d098cccc18d4d401 ), // Address 0x2500 : 9472
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
