// wishbone 内存模块
module wbs_mem (
	input				clk,
	input				rst,

// wishbone bus
// SYSCON
//	input				clk_i,
//	input				rst_i,
// INTERCON
	input	[31:0]		adr_i,
	input	[31:0]		dat_i,
	output	[31:0]		dat_o,
	input				we_i,
	input	[3:0]		sel_i,

// BUS
// cyc 总线占用请求 stb 选通信号
	input				cyc_i,
	input				stb_i,
// 操作应答信号  ack 成功  err 错误  rty 重试
	output				ack_o,
	output 				err_o,
	output 				rty_o
);

	// dat_o 是否有效由 ack_o 回复
	// cyc 表示从设备已经在线
	// ack err rty 需要回复 stb 信号
//	assign	ack_o = cyc_i&stb_i;
	assign	err_o = 1'b0;
	assign	rty_o = 1'b0;

	// 让 ack_o 延迟一个周期回复 stb_i
	reg	ack;

	always @(posedge clk or posedge rst)
		if (rst)
			ack <= 1'b0;
		else
			if(cyc_i & stb_i & ~ack)
				ack <= 1'b1;
			else
				ack <= 1'b0;

	assign	ack_o = ack;

	// 判断是否进行操作
	wire en = cyc_i&&stb_i&&(adr_i[31:16]==16'b0);

	// 读写操作
	wire	[13:0]	adr = adr_i[15:2];

	wire	[7:0]	dat_i_0, dat_i_1, dat_i_2, dat_i_3;
	assign {dat_i_0, dat_i_1, dat_i_2, dat_i_3} = dat_i;

	wire	[7:0]	dat_o_0, dat_o_1, dat_o_2, dat_o_3;
	assign dat_o = {dat_o_0, dat_o_1, dat_o_2, dat_o_3};

	wire	en_0, en_1, en_2, en_3;
	assign {en_0, en_1, en_2, en_3} = en?sel_i:4'b0000;

	mem_U0 mem_U0(
		.clk(clk),
		.rst(rst),
		.adr(adr),
		.dat_i(dat_i_0),
		.dat_o(dat_o_0),
		.we(we_i),
		.en(en_0)
	);

	mem_U1 mem_U1(
		.clk(clk),
		.rst(rst),
		.adr(adr),
		.dat_i(dat_i_1),
		.dat_o(dat_o_1),
		.we(we_i),
		.en(en_1)
	);

	mem_U2 mem_U2(
		.clk(clk),
		.rst(rst),
		.adr(adr),
		.dat_i(dat_i_2),
		.dat_o(dat_o_2),
		.we(we_i),
		.en(en_2)
	);

	mem_U3 mem_U3(
		.clk(clk),
		.rst(rst),
		.adr(adr),
		.dat_i(dat_i_3),
		.dat_o(dat_o_3),
		.we(we_i),
		.en(en_3)
	);

endmodule
