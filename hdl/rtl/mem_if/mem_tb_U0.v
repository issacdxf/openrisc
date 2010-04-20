// 内存（RTL代码）
// 数据字节宽

module mem_U0 (
	input					clk,
	input					rst,
	input		[13:0]		adr,
	input		[7:0]		dat_i,
	output		[7:0]		dat_o,
	input					we,
	input					en
);

	// 内存
	reg		[7:0]	Mem	[0:16383];

	initial $readmemh("dat0.txt",Mem);

	// 写操作
	always @(posedge clk)
		if (en&&we)
			Mem[adr] <= dat_i;

	// 读操作
	assign dat_o = (en && ~we)?Mem[adr]:8'bz;

endmodule
