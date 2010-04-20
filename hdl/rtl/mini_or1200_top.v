`include "mini_or1200_defines.v"

module mini_or1200_top (

	//
	// Global signals
	//
	input	clk,
	input	rstn,

	//
	// UART signals
	//
	output	uart_stx,
	input	uart_srx,

	//
	// JTAG signals
	//
	input	jtag_tdi,
	input	jtag_tms,
	input	jtag_tck,
	input	jtag_trst,
	output	jtag_tdo,

	//
	// LED
	//
	output	[3:0] oLED
);

//----------------------
// Internal wires
//

//
// Debug core master i/f wires
//
wire 	[31:0]		wb_dm_adr_o;
wire 	[31:0] 		wb_dm_dat_i;
wire 	[31:0] 		wb_dm_dat_o;
wire 	[3:0]		wb_dm_sel_o;
wire				wb_dm_we_o;
wire 				wb_dm_stb_o;
wire				wb_dm_cyc_o;
wire				wb_dm_cab_o;
wire				wb_dm_ack_i;
wire				wb_dm_err_i;

//
// Debug <-> RISC wires
//
wire	[3:0]		dbg_lss;
wire	[1:0]		dbg_is;
wire	[10:0]		dbg_wp;
wire				dbg_bp;
wire	[31:0]		dbg_dat_dbg;
wire	[31:0]		dbg_dat_risc;
wire	[31:0]		dbg_adr;
wire				dbg_ewt;
wire				dbg_stall;
wire	[2:0]		dbg_op;

//
// RISC instruction master i/f wires
//
wire 	[31:0]		wb_rim_adr_o;
wire				wb_rim_cyc_o;
wire 	[31:0]		wb_rim_dat_i;
wire 	[31:0]		wb_rim_dat_o;
wire 	[3:0]		wb_rim_sel_o;
wire				wb_rim_ack_i;
wire				wb_rim_err_i;
wire				wb_rim_rty_i = 1'b0;
wire				wb_rim_we_o;
wire				wb_rim_stb_o;
wire				wb_rim_cab_o;

//
// RISC data master i/f wires
//
wire 	[31:0]		wb_rdm_adr_o;
wire				wb_rdm_cyc_o;
wire 	[31:0]		wb_rdm_dat_i;
wire 	[31:0]		wb_rdm_dat_o;
wire 	[3:0]		wb_rdm_sel_o;
wire				wb_rdm_ack_i;
wire				wb_rdm_err_i;
wire				wb_rdm_rty_i = 1'b0;
wire				wb_rdm_we_o;
wire				wb_rdm_stb_o;
wire				wb_rdm_cab_o;

//
// RISC misc
//
wire	[19:0]		pic_ints;

//
// SRAM controller slave i/f wires
//
wire 	[31:0]		wb_ss_dat_i;
wire 	[31:0]		wb_ss_dat_o;
wire 	[31:0]		wb_ss_adr_i;
wire 	[3:0]		wb_ss_sel_i;
wire				wb_ss_we_i;
wire				wb_ss_cyc_i;
wire				wb_ss_stb_i;
wire				wb_ss_ack_o;
wire				wb_ss_err_o;

//
// UART16550 core slave i/f wires
//
wire	[31:0]		wb_us_dat_i;
wire	[31:0]		wb_us_dat_o;
wire	[31:0]		wb_us_adr_i;
wire	[3:0]		wb_us_sel_i;
wire				wb_us_we_i;
wire				wb_us_cyc_i;
wire				wb_us_stb_i;
wire				wb_us_ack_o;
wire				wb_us_err_o;

/*

//
// Reset debounce
//
reg			rst_r;
reg			wb_rst;


//
// Global clock
//
`ifdef OR1200_CLMODE_1TO2
reg			wb_clk;
`else
wire			wb_clk;
`endif

//
// Reset debounce
//
always @(posedge wb_clk or posedge rst)
	if (rst)
		rst_r <= 1'b1;
	else
		rst_r <= #1 1'b0;

//
// Reset debounce
//
always @(posedge wb_clk)
	wb_rst <= #1 rst_r;

//
// This is purely for testing 1/2 WB clock
// This should never be used when implementing in
// an FPGA. It is used only for simulation regressions.
//
`ifdef OR1200_CLMODE_1TO2

initial wb_clk = 0;
always @(posedge clk)
	wb_clk = ~wb_clk;

`else // OR1200_CLMODE_1TO2
//
// Some Xilinx P&R tools need this
//
`ifdef TARGET_VIRTEX
`ifdef USE_DIRECT_CLOCK

IBUFG IBUFG1 (
	.O	( wb_clk ),
	.I	( clk )
);

`else // USE_DIRECT_CLOCK

//
// Divide clock by 10
//
wire clock_feedback_output, clock_feedback_input, dll_output;
CLKDLL clkdiv (
	.CLKIN (clk),
	.CLKFB (clock_feedback_input),
	.RST (1'b0),
	.CLK0 (clock_feedback_output),
	.CLKDV (dll_output));
// synthesis attribute CLKDV_DIVIDE of clkdiv is "10.0"
BUFG clkg1 (.I (clock_feedback_output), .O (clock_feedback_input));
BUFG clkg2 (.I (dll_output), .O (wb_clk));

`endif // USE_DIRECT_CLOCK
`else // TARGET_VIRTEX

assign wb_clk = clk;

`endif // TARGET_VIRTEX
`endif // OR1200_CLMODE_1TO2
*/

/*
// 运行频率减半
reg			wb_clk;
initial wb_clk = 0;
always @(posedge clk)
	wb_clk = ~wb_clk;
*/

//wire wb_clk, clock;
wire  wb_clk;
assign  wb_clk = clk;
//clkdiv clk_U(.CLKIN_IN(clk), .CLKDV_OUT(wb_clk), .CLKIN_IBUFG_OUT(clock));


wire	wb_rst;
// 提供开机复位信号，复位信号不能过短。
RESET RESET_inst( wb_clk, ~rstn, wb_rst );

// 如果没有专门的 RESET 按键，可以用按键代替。
// 对reset按钮消颤并且提供开机复位信号
// RESET_DB RESET_DB_inst( wb_clk, ~rst_btn, wb_rst );


/*
	.t0_wb_cyc_o	( wb_ss_cyc_i ),
	.t0_wb_stb_o	( wb_ss_stb_i ),
	.t0_wb_cab_o	( wb_ss_cab_i ),
	.t0_wb_adr_o	( wb_ss_adr_i ),
	.t0_wb_sel_o	( wb_ss_sel_i ),
	.t0_wb_we_o	( wb_ss_we_i  ),
	.t0_wb_dat_o	( wb_ss_dat_i ),
	.t0_wb_dat_i	( wb_ss_dat_o ),
	.t0_wb_ack_i	( wb_ss_ack_o ),
	.t0_wb_err_i	( wb_ss_err_o ),
*/

assign oLED[0] = uart_stx;
assign oLED[1] = uart_srx;
assign oLED[2] = wb_rst;
assign oLED[3] = wb_clk;

//
// Unused interrupts
//
assign pic_ints[`APP_INT_RES1] = 'b0;
assign pic_ints[`APP_INT_RES2] = 'b0;
assign pic_ints[`APP_INT_RES3] = 'b0;
assign pic_ints[`APP_INT_ETH] = 'b0;
assign pic_ints[`APP_INT_PS2] = 'b0;

//
// Unused WISHBONE signals
//
assign wb_us_err_o = 1'b0;

//
// Instantiation of the development i/f model
//
// Used only for simulations.
//
`ifdef DBG_IF_MODEL
dbg_if_model dbg_if_model  (

	// JTAG pins
	.tms_pad_i	( jtag_tms ),
	.tck_pad_i	( jtag_tck ),
	.trst_pad_i	( ~jtag_trst ),
	.tdi_pad_i	( jtag_tdi ),
	.tdo_pad_o	( jtag_tdo ),

	// Boundary Scan signals
	.capture_dr_o	( ),
	.shift_dr_o	( ),
	.update_dr_o	( ),
	.extest_selected_o ( ),
	.bs_chain_i	( 1'b0 ),

	// RISC signals
	.risc_clk_i	( wb_clk ),
	.risc_data_i	( dbg_dat_risc ),
	.risc_data_o	( dbg_dat_dbg ),
	.risc_addr_o	( dbg_adr ),
	.wp_i		( dbg_wp ),
	.bp_i		( dbg_bp ),
	.opselect_o	( dbg_op ),
	.lsstatus_i	( dbg_lss ),
	.istatus_i	( dbg_is ),
	.risc_stall_o	( dbg_stall ),
	.reset_o	( ),

	// WISHBONE common
	.wb_clk_i	( wb_clk ),
	.wb_rst_i	( wb_rst ),

	// WISHBONE master interface
	.wb_adr_o	( wb_dm_adr_o ),
	.wb_dat_i	( wb_dm_dat_i ),
	.wb_dat_o	( wb_dm_dat_o ),
	.wb_sel_o	( wb_dm_sel_o ),
	.wb_we_o	( wb_dm_we_o  ),
	.wb_stb_o	( wb_dm_stb_o ),
	.wb_cyc_o	( wb_dm_cyc_o ),
	.wb_cab_o	( wb_dm_cab_o ),
	.wb_ack_i	( wb_dm_ack_i ),
	.wb_err_i	( wb_dm_err_i )
);
`else
//
// Instantiation of the development i/f
//
dbg_top dbg_top  (

	// JTAG pins
	.tms_pad_i	( jtag_tms ),
	.tck_pad_i	( jtag_tck ),
	.trst_pad_i	( ~jtag_trst ),
	.tdi_pad_i	( jtag_tdi ),
	.tdo_pad_o	( jtag_tdo ),
	.tdo_padoen_o	( ),

	// Boundary Scan signals
	.capture_dr_o	( ),
	.shift_dr_o	( ),
	.update_dr_o	( ),
	.extest_selected_o ( ),
	.bs_chain_i	( 1'b0 ),
	.bs_chain_o	( ),

	// RISC signals
	.risc_clk_i	( wb_clk ),
	.risc_addr_o	( dbg_adr ),
	.risc_data_i	( dbg_dat_risc ),
	.risc_data_o	( dbg_dat_dbg ),
	.wp_i		( dbg_wp ),
	.bp_i		( dbg_bp ),
	.opselect_o	( dbg_op ),
	.lsstatus_i	( dbg_lss ),
	.istatus_i	( dbg_is ),
	.risc_stall_o	( dbg_stall ),
	.reset_o	( ),

	// WISHBONE common
	.wb_clk_i	( wb_clk ),
	.wb_rst_i	( wb_rst ),

	// WISHBONE master interface
	.wb_adr_o	( wb_dm_adr_o ),
	.wb_dat_i	( wb_dm_dat_i ),
	.wb_dat_o	( wb_dm_dat_o ),
	.wb_sel_o	( wb_dm_sel_o ),
	.wb_we_o	( wb_dm_we_o  ),
	.wb_stb_o	( wb_dm_stb_o ),
	.wb_cyc_o	( wb_dm_cyc_o ),
	.wb_cab_o	( wb_dm_cab_o ),
	.wb_ack_i	( wb_dm_ack_i ),
	.wb_err_i	( wb_dm_err_i )
);
`endif

//
// Instantiation of the OR1200 RISC
//
or1200_top or1200_top (

	// Common
	.rst_i		( wb_rst ),
	.clk_i		( wb_clk ),
`ifdef OR1200_CLMODE_1TO2
	.clmode_i	( 2'b01 ),
`else
`ifdef OR1200_CLMODE_1TO4
	.clmode_i	( 2'b11 ),
`else
	.clmode_i	( 2'b00 ),
`endif
`endif

	// WISHBONE Instruction Master
	.iwb_clk_i	( wb_clk ),
	.iwb_rst_i	( wb_rst ),
	.iwb_cyc_o	( wb_rim_cyc_o ),
	.iwb_adr_o	( wb_rim_adr_o ),
	.iwb_dat_i	( wb_rim_dat_i ),
	.iwb_dat_o	( wb_rim_dat_o ),
	.iwb_sel_o	( wb_rim_sel_o ),
	.iwb_ack_i	( wb_rim_ack_i ),
	.iwb_err_i	( wb_rim_err_i ),
	.iwb_rty_i	( wb_rim_rty_i ),
	.iwb_we_o	( wb_rim_we_o  ),
	.iwb_stb_o	( wb_rim_stb_o ),
	.iwb_cab_o	( wb_rim_cab_o ),

	// WISHBONE Data Master
	.dwb_clk_i	( wb_clk ),
	.dwb_rst_i	( wb_rst ),
	.dwb_cyc_o	( wb_rdm_cyc_o ),
	.dwb_adr_o	( wb_rdm_adr_o ),
	.dwb_dat_i	( wb_rdm_dat_i ),
	.dwb_dat_o	( wb_rdm_dat_o ),
	.dwb_sel_o	( wb_rdm_sel_o ),
	.dwb_ack_i	( wb_rdm_ack_i ),
	.dwb_err_i	( wb_rdm_err_i ),
	.dwb_rty_i	( wb_rdm_rty_i ),
	.dwb_we_o	( wb_rdm_we_o  ),
	.dwb_stb_o	( wb_rdm_stb_o ),
	.dwb_cab_o	( wb_rdm_cab_o ),

	// Debug
	.dbg_stall_i	( dbg_stall ),
	.dbg_dat_i	( dbg_dat_dbg ),
	.dbg_adr_i	( dbg_adr ),
	.dbg_ewt_i	( 1'b0 ),
	.dbg_lss_o	( dbg_lss ),
	.dbg_is_o	( dbg_is ),
	.dbg_wp_o	( dbg_wp ),
	.dbg_bp_o	( dbg_bp ),
	.dbg_dat_o	( dbg_dat_risc ),
	.dbg_ack_o	( ),
	.dbg_stb_i	( dbg_op[2] ),
	.dbg_we_i	( dbg_op[0] ),

	// Power Management
	.pm_clksd_o	( ),
	.pm_cpustall_i	( 1'b0 ),
	.pm_dc_gate_o	( ),
	.pm_ic_gate_o	( ),
	.pm_dmmu_gate_o	( ),
	.pm_immu_gate_o	( ),
	.pm_tt_gate_o	( ),
	.pm_cpu_gate_o	( ),
	.pm_wakeup_o	( ),
	.pm_lvolt_o	( ),

	// Interrupts
	.pic_ints_i	( pic_ints )
);

//
// Instantiation of the RAM controller
//
wbs_mem wbs_mem_top (
	// WISHBONE common
	.clk	( wb_clk ),
	.rst	( wb_rst ),
//	.rst	( 1'b0 ),

	// WISHBONE slave
	.dat_i	( wb_ss_dat_i ),
	.dat_o	( wb_ss_dat_o ),
	.adr_i	( wb_ss_adr_i ),
	.sel_i	( wb_ss_sel_i ),
	.we_i	( wb_ss_we_i  ),
	.cyc_i	( wb_ss_cyc_i ),
	.stb_i	( wb_ss_stb_i ),
	.ack_o	( wb_ss_ack_o ),
	.err_o	( wb_ss_err_o ),
	.rty_o  (  )
);

//
// Instantiation of the UART16550
//
uart_top uart_top (

	// WISHBONE common
	.wb_clk_i	( wb_clk ),
	.wb_rst_i	( wb_rst ),

	// WISHBONE slave
	.wb_adr_i	( wb_us_adr_i[4:0] ),
	.wb_dat_i	( wb_us_dat_i ),
	.wb_dat_o	( wb_us_dat_o ),
	.wb_we_i	( wb_us_we_i  ),
	.wb_stb_i	( wb_us_stb_i ),
	.wb_cyc_i	( wb_us_cyc_i ),
	.wb_ack_o	( wb_us_ack_o ),
	.wb_sel_i	( wb_us_sel_i ),

	// Interrupt request
//	.int_o		( pic_ints[`APP_INT_UART] ),
	.int_o		(  ),

	// UART signals
	// serial input/output
	.stx_pad_o	( uart_stx ),
	.srx_pad_i	( uart_srx ),

	// modem signals
	.rts_pad_o	( ),
	.cts_pad_i	( 1'b0 ),
	.dtr_pad_o	( ),
	.dsr_pad_i	( 1'b0 ),
	.ri_pad_i	( 1'b0 ),
	.dcd_pad_i	( 1'b0 )
);

//
// Instantiation of the Traffic COP
//
tc_top #(`APP_ADDR_DEC_W,
	 `APP_ADDR_SRAM,
	 `APP_ADDR_DEC_W,
	 `APP_ADDR_FLASH,
	 `APP_ADDR_DECP_W,
	 `APP_ADDR_PERIP,
	 `APP_ADDR_DEC_W,
	 `APP_ADDR_VGA,
	 `APP_ADDR_ETH,
	 `APP_ADDR_AUDIO,
	 `APP_ADDR_UART,
	 `APP_ADDR_PS2,
	 `APP_ADDR_RES1,
	 `APP_ADDR_RES2
	) tc_top (

	// WISHBONE common
	.wb_clk_i	( wb_clk ),
	.wb_rst_i	( wb_rst ),

	// WISHBONE Initiator 0
	.i0_wb_cyc_i	( 1'b0 ),
	.i0_wb_stb_i	( 1'b0 ),
	.i0_wb_cab_i	( 1'b0 ),
	.i0_wb_adr_i	( 32'h0000_0000 ),
	.i0_wb_sel_i	( 4'b0000 ),
	.i0_wb_we_i	( 1'b0 ),
	.i0_wb_dat_i	( 32'h0000_0000 ),
	.i0_wb_dat_o	( ),
	.i0_wb_ack_o	( ),
	.i0_wb_err_o	( ),

	// WISHBONE Initiator 1
	.i1_wb_cyc_i	( 1'b0 ),
	.i1_wb_stb_i	( 1'b0 ),
	.i1_wb_cab_i	( 1'b0 ),
	.i1_wb_adr_i	( 32'h0000_0000 ),
	.i1_wb_sel_i	( 4'b0000 ),
	.i1_wb_we_i	( 1'b0 ),
	.i1_wb_dat_i	( 32'h0000_0000 ),
	.i1_wb_dat_o	( ),
	.i1_wb_ack_o	( ),
	.i1_wb_err_o	( ),

	// WISHBONE Initiator 2
	.i2_wb_cyc_i	( 1'b0 ),
	.i2_wb_stb_i	( 1'b0 ),
	.i2_wb_cab_i	( 1'b0 ),
	.i2_wb_adr_i	( 32'h0000_0000 ),
	.i2_wb_sel_i	( 4'b0000 ),
	.i2_wb_we_i	( 1'b0 ),
	.i2_wb_dat_i	( 32'h0000_0000 ),
	.i2_wb_dat_o	( ),
	.i2_wb_ack_o	( ),
	.i2_wb_err_o	( ),

	// WISHBONE Initiator 3
	.i3_wb_cyc_i	( wb_dm_cyc_o ),
	.i3_wb_stb_i	( wb_dm_stb_o ),
	.i3_wb_cab_i	( wb_dm_cab_o ),
	.i3_wb_adr_i	( wb_dm_adr_o ),
	.i3_wb_sel_i	( wb_dm_sel_o ),
	.i3_wb_we_i	( wb_dm_we_o  ),
	.i3_wb_dat_i	( wb_dm_dat_o ),
	.i3_wb_dat_o	( wb_dm_dat_i ),
	.i3_wb_ack_o	( wb_dm_ack_i ),
	.i3_wb_err_o	( wb_dm_err_i ),

	// WISHBONE Initiator 4
	.i4_wb_cyc_i	( wb_rdm_cyc_o ),
	.i4_wb_stb_i	( wb_rdm_stb_o ),
	.i4_wb_cab_i	( wb_rdm_cab_o ),
	.i4_wb_adr_i	( wb_rdm_adr_o ),
	.i4_wb_sel_i	( wb_rdm_sel_o ),
	.i4_wb_we_i	( wb_rdm_we_o  ),
	.i4_wb_dat_i	( wb_rdm_dat_o ),
	.i4_wb_dat_o	( wb_rdm_dat_i ),
	.i4_wb_ack_o	( wb_rdm_ack_i ),
	.i4_wb_err_o	( wb_rdm_err_i ),

	// WISHBONE Initiator 5
	.i5_wb_cyc_i	( wb_rim_cyc_o ),
	.i5_wb_stb_i	( wb_rim_stb_o ),
	.i5_wb_cab_i	( wb_rim_cab_o ),
	.i5_wb_adr_i	( wb_rim_adr_o ),
	.i5_wb_sel_i	( wb_rim_sel_o ),
	.i5_wb_we_i	( wb_rim_we_o  ),
	.i5_wb_dat_i	( wb_rim_dat_o ),
	.i5_wb_dat_o	( wb_rim_dat_i ),
	.i5_wb_ack_o	( wb_rim_ack_i ),
	.i5_wb_err_o	( wb_rim_err_i ),

	// WISHBONE Initiator 6
	.i6_wb_cyc_i	( 1'b0 ),
	.i6_wb_stb_i	( 1'b0 ),
	.i6_wb_cab_i	( 1'b0 ),
	.i6_wb_adr_i	( 32'h0000_0000 ),
	.i6_wb_sel_i	( 4'b0000 ),
	.i6_wb_we_i	( 1'b0 ),
	.i6_wb_dat_i	( 32'h0000_0000 ),
	.i6_wb_dat_o	( ),
	.i6_wb_ack_o	( ),
	.i6_wb_err_o	( ),

	// WISHBONE Initiator 7
	.i7_wb_cyc_i	( 1'b0 ),
	.i7_wb_stb_i	( 1'b0 ),
	.i7_wb_cab_i	( 1'b0 ),
	.i7_wb_adr_i	( 32'h0000_0000 ),
	.i7_wb_sel_i	( 4'b0000 ),
	.i7_wb_we_i	( 1'b0 ),
	.i7_wb_dat_i	( 32'h0000_0000 ),
	.i7_wb_dat_o	( ),
	.i7_wb_ack_o	( ),
	.i7_wb_err_o	( ),

	// WISHBONE Target 0
	.t0_wb_cyc_o	( wb_ss_cyc_i ),
	.t0_wb_stb_o	( wb_ss_stb_i ),
	.t0_wb_cab_o	( wb_ss_cab_i ),
	.t0_wb_adr_o	( wb_ss_adr_i ),
	.t0_wb_sel_o	( wb_ss_sel_i ),
	.t0_wb_we_o	( wb_ss_we_i  ),
	.t0_wb_dat_o	( wb_ss_dat_i ),
	.t0_wb_dat_i	( wb_ss_dat_o ),
	.t0_wb_ack_i	( wb_ss_ack_o ),
	.t0_wb_err_i	( wb_ss_err_o ),

	// WISHBONE Target 1
	.t1_wb_cyc_o	( ),
	.t1_wb_stb_o	( ),
	.t1_wb_cab_o	( ),
	.t1_wb_adr_o	( ),
	.t1_wb_sel_o	( ),
	.t1_wb_we_o	( ),
	.t1_wb_dat_o	( ),
	.t1_wb_dat_i	( 32'h0000_0000 ),
	.t1_wb_ack_i	( 1'b0 ),
	.t1_wb_err_i	( 1'b1 ),

	// WISHBONE Target 2
	.t2_wb_cyc_o	( ),
	.t2_wb_stb_o	( ),
	.t2_wb_cab_o	( ),
	.t2_wb_adr_o	( ),
	.t2_wb_sel_o	( ),
	.t2_wb_we_o	( ),
	.t2_wb_dat_o	( ),
	.t2_wb_dat_i	( 32'h0000_0000 ),
	.t2_wb_ack_i	( 1'b0 ),
	.t2_wb_err_i	( 1'b1 ),

	// WISHBONE Target 3
	.t3_wb_cyc_o	( ),
	.t3_wb_stb_o	( ),
	.t3_wb_cab_o	( ),
	.t3_wb_adr_o	( ),
	.t3_wb_sel_o	( ),
	.t3_wb_we_o	( ),
	.t3_wb_dat_o	( ),
	.t3_wb_dat_i	( 32'h0000_0000 ),
	.t3_wb_ack_i	( 1'b0 ),
	.t3_wb_err_i	( 1'b1 ),

	// WISHBONE Target 4
	.t4_wb_cyc_o	( ),
	.t4_wb_stb_o	( ),
	.t4_wb_cab_o	( ),
	.t4_wb_adr_o	( ),
	.t4_wb_sel_o	( ),
	.t4_wb_we_o	( ),
	.t4_wb_dat_o	( ),
	.t4_wb_dat_i	( 32'h0000_0000 ),
	.t4_wb_ack_i	( 1'b0 ),
	.t4_wb_err_i	( 1'b1 ),

	// WISHBONE Target 5
	.t5_wb_cyc_o	( wb_us_cyc_i ),
	.t5_wb_stb_o	( wb_us_stb_i ),
	.t5_wb_cab_o	( wb_us_cab_i ),
	.t5_wb_adr_o	( wb_us_adr_i ),
	.t5_wb_sel_o	( wb_us_sel_i ),
	.t5_wb_we_o	( wb_us_we_i  ),
	.t5_wb_dat_o	( wb_us_dat_i ),
	.t5_wb_dat_i	( wb_us_dat_o ),
	.t5_wb_ack_i	( wb_us_ack_o ),
	.t5_wb_err_i	( wb_us_err_o ),

	// WISHBONE Target 6
	.t6_wb_cyc_o	( ),
	.t6_wb_stb_o	( ),
	.t6_wb_cab_o	( ),
	.t6_wb_adr_o	( ),
	.t6_wb_sel_o	( ),
	.t6_wb_we_o	( ),
	.t6_wb_dat_o	( ),
	.t6_wb_dat_i	( 32'h0000_0000 ),
	.t6_wb_ack_i	( 1'b0 ),
	.t6_wb_err_i	( 1'b1 ),

	// WISHBONE Target 7
	.t7_wb_cyc_o	( ),
	.t7_wb_stb_o	( ),
	.t7_wb_cab_o	( ),
	.t7_wb_adr_o	( ),
	.t7_wb_sel_o	( ),
	.t7_wb_we_o	( ),
	.t7_wb_dat_o	( ),
	.t7_wb_dat_i	( 32'h0000_0000 ),
	.t7_wb_ack_i	( 1'b0 ),
	.t7_wb_err_i	( 1'b1 ),

	// WISHBONE Target 8
	.t8_wb_cyc_o	( ),
	.t8_wb_stb_o	( ),
	.t8_wb_cab_o	( ),
	.t8_wb_adr_o	( ),
	.t8_wb_sel_o	( ),
	.t8_wb_we_o	( ),
	.t8_wb_dat_o	( ),
	.t8_wb_dat_i	( 32'h0000_0000 ),
	.t8_wb_ack_i	( 1'b0 ),
	.t8_wb_err_i	( 1'b1 )
);

//initial begin
//  $dumpvars(0);
//  $dumpfile("dump.vcd");
//end

endmodule
