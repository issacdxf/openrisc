// Testbench Code
module RESET_TB ();

	reg		clk;
	reg		rst_i;
	wire	rst;

	// Clock generator
	always #1 clk = ~clk;

	initial begin
		clk = 1;
		rst_i = 0;
		#20	rst_i=1;
		#30 rst_i=0;
	end

	// Connect the DUT
	RESET U( clk, rst_i, rst );

endmodule
