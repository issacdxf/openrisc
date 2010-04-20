// RESET with Debouncer
// ������ë�̵ĸ�λ
module RESET_DB(
	input	clk,
	input	rst_i,
	output	rst
);

	wire	s_rst;

RESET RESET_inst(
	.clk(clk),
	.rst_i(s_rst),
	.rst(rst) );

Debouncer DB_inst(
	.gClock(clk),
	.gReset(),
	.iBouncy(rst_i),
	.oDebounced(s_rst),
	.oPulseOnRisingEdge(),
	.oPulseOnFallingEdge() );

endmodule