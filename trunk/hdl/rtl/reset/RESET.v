// 复位电路采用：异步复位、同步释放

module RESET(
	input	clk,
	input	rst_i,
	output	rst
);

	parameter T = 3;

	reg [T:0] period;

	initial begin
		period = {(T+1){1'b1}};
	end

	assign rst = period[0];

	always @ (posedge clk or posedge rst_i)
		if (rst_i)
			period <= {(T+1){1'b1}};
		else
			period <= period>>1;

endmodule
