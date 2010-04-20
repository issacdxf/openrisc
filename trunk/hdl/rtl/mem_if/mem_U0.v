// 内存（RTL代码）
// 数据字节宽

module mem_U0 (
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
	.INIT_02( 256'h0000000000000000000000000000000000000000000015449c44a818e09ca818 ), // Address 0x100 : 256
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
	.INIT_00( 256'hd7a884d718d8848cdb84d79cd7a884d718d8848cdb84d79cd7a884d7189cd49c ), // Address 0x2000 : 8192
	.INIT_01( 256'h848cdb84d7e08c9cdb8c84d7a884d718d7a884d718d784d79cd8848cdb84d79c ), // Address 0x2080 : 8320
	.INIT_02( 256'hd79cd7b884d784d7a884d718d8848cdb84d7e08c8cdb84db84d79cd784d718d8 ), // Address 0x2100 : 8448
	.INIT_03( 256'h8c8cdb8c84db84d79cd7a884d718d7a884d718d8848cdb84d7e08c8cdb84db84 ), // Address 0x2180 : 8576
	.INIT_04( 256'ha484d78cdb8cdb8c84d7a884d718db8cdb84d79cd49c9c4484d8848cdb84d7e0 ), // Address 0x2200 : 8704
	.INIT_05( 256'hd78cdb8cdb8c84d7a884d7181510bc84d790d8848cdb8cd71815031510bc84d7 ), // Address 0x2280 : 8832
	.INIT_06( 256'ha484d78cdb8cdb8c84d7a884d718d8848cdb84d79cd71815031510bc84d7a484 ), // Address 0x2300 : 8960
	.INIT_07( 256'h84d7a484d7ac84d78cdb8cdb8c84d7a884d7189cd49c9c448415031510bc84d7 ), // Address 0x2380 : 9088
	.INIT_08( 256'hd78484d7a8181507d49cd49c9c448485d784d790db8cdb8c84d71815031510bc ), // Address 0x2400 : 9216
	.INIT_09( 256'h84d715071503d784d79c84d784150784d79084d7841510bc84d79084d784d784 ), // Address 0x2480 : 9344
	.INIT_0A( 256'h3030303030303030303021726f48009c4484851503150784d7b884d7b884d79c ), // Address 0x2500 : 9472
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
