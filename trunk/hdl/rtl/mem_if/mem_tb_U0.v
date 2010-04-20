// �ڴ棨RTL���룩
// �����ֽڿ�

module mem_U0 (
	input					clk,
	input					rst,
	input		[13:0]		adr,
	input		[7:0]		dat_i,
	output		[7:0]		dat_o,
	input					we,
	input					en
);

	// �ڴ�
	reg		[7:0]	Mem	[0:16383];

	initial $readmemh("dat0.txt",Mem);

	// д����
	always @(posedge clk)
		if (en&&we)
			Mem[adr] <= dat_i;

	// ������
	assign dat_o = (en && ~we)?Mem[adr]:8'bz;

endmodule
