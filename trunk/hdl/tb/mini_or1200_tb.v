//
// Reset active time for simulation
//
`define BENCH_RESET_TIME	150
//`define DUMP_FSDB
//
// Clock half period for simulation
//
`define BENCH_CLK_HALFPERIOD	10

`include "mini_or1200_defines.v"
`include "uart_defines.v"
`timescale 1ns/100ps
module mini_or1200_tb (
);

reg		clk;
reg		        rst;

// A wishbone BUS connect with WB_MASTER and UART16550
wire  [31:0]  emul_wb_adr_o;
wire  [31:0]  emul_wb_dat_i;
wire  [31:0]  emul_wb_dat_o;
wire          emul_wb_we_o;
wire          emul_wb_stb_o;
wire          emul_wb_cyc_o;
wire          emul_wb_ack_i;
wire  [3:0]   emul_wb_sel_o;
wire          int_o;
wire          uart_conn;

initial
begin
    clk = 1;
    forever
    # `BENCH_CLK_HALFPERIOD clk = ~clk;
end

initial begin
    rst = 1;
    # `BENCH_RESET_TIME
    rst = 0;
    #(1200000*`BENCH_CLK_HALFPERIOD)
    $finish;
end

wire	wb_rst = rst;

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
//wire	[31:0]		wb_rif_adr;
//reg				prefix_flash;

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
//wire				wb_rdm_ack;

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

//
// UART external i/f wires
//
wire				uart_stx;
wire				uart_srx;

//
// JTAG wires
//
wire				jtag_tdi;
wire				jtag_tms;
wire				jtag_tck;
wire				jtag_trst;
wire				jtag_tdo;

assign jtag_tdi = 1'b0;
assign jtag_tms = 1'b0;
assign jtag_tck = 1'b0;
assign jtag_trst = wb_rst;
//assign jtag_trst = ~wb_rst;


//
// Global clock
//
`ifdef OR1200_CLMODE_1TO2
reg			wb_clk;
`else
wire			wb_clk;
`endif

//
// This is purely for testing 1/2 WB clock
// This should never be used when implementing in
// an FPGA. It is used only for simulation regressions.
//
`ifdef OR1200_CLMODE_1TO2
initial wb_clk = 0;
always @(posedge clk)
	wb_clk = ~wb_clk;
`else
//
// Some Xilinx P&R tools need this
//
`ifdef TARGET_VIRTEX
IBUFG IBUFG1 (
	.O	( wb_clk ),
	.I	( clk )
);
`else
assign wb_clk = clk;
`endif
`endif // OR1200_CLMODE_1TO2


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

/*
//
// RISC Instruction address for Flash
//
// Until first access to real Flash area,
// it is always prefixed with Flash area prefix.
// This way we have flash at base address 0x0
// during reset vector execution (boot). First
// access to real Flash area will automatically
// move SRAM to 0x0.
//
always @(posedge wb_clk or negedge rstn)
	if (!rstn)
		prefix_flash <= #1 1'b1;
	else if (wb_rim_cyc_o &&
		(wb_rim_adr_o[31:32-`APP_ADDR_DEC_W] == `APP_ADDR_FLASH))
		prefix_flash <= #1 1'b0;
assign wb_rif_adr = prefix_flash ? {`APP_ADDR_FLASH, wb_rim_adr_o[31-`APP_ADDR_DEC_W:0]}
			: wb_rim_adr_o;
assign wb_rdm_ack_i = (wb_rdm_adr_o[31:28] == `APP_ADDR_FAKEMC) &&
			wb_rdm_cyc_o && wb_rdm_stb_o ? 1'b1 : wb_rdm_ack;
*/

//assign wb_rif_adr = wb_rim_adr_o;
//assign wb_rdm_ack_i = wb_rdm_ack;


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
	.trst_pad_i	( jtag_trst ),
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
	.trst_pad_i	( jtag_trst ),
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
// Instantiation of the SRAM controller
//
wbs_mem wbs_mem_top (

	// WISHBONE common
	.clk	( wb_clk ),
	.rst	( wb_rst ),

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
	.int_o		( pic_ints[`APP_INT_UART] ),

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

`ifdef DUMP_FSDB
initial
begin	
        $fsdbDumpfile("../debussy/mini_or1200.fsdb");
        $fsdbDumpvars(0,mini_or1200_tb);
        $fsdbDumpflush;
end
`endif

uart_top u_emul_uart_rx (
  .wb_clk_i   (clk),
  .wb_rst_i   (rst),
  .wb_adr_i   (emul_wb_adr_o[4:0]),
  .wb_dat_i   (emul_wb_dat_o),
  .wb_dat_o   (emul_wb_dat_i),
  .wb_we_i    (emul_wb_we_o),
  .wb_stb_i   (emul_wb_stb_o),
  .wb_cyc_i   (emul_wb_cyc_o),
  .wb_ack_o   (emul_wb_ack_i),
  .wb_sel_i   (emul_wb_sel_o),
  .int_o      (int_o),
  .stx_pad_o  (),
  .srx_pad_i  (uart_stx),
  .rts_pad_o  (),
  .cts_pad_i  (1'b0),
  .dtr_pad_o  (),
  .dsr_pad_i	(1'b0),
  .ri_pad_i   (1'b0),
  .dcd_pad_i  (1'b0)
);

wb_mast u_emul_wb_rx(
  .clk  (clk ),
  .rst  (rst ),
  .adr  (emul_wb_adr_o), 
  .din  (emul_wb_dat_i),
  .dout (emul_wb_dat_o),
  .cyc  (emul_wb_cyc_o),
  .stb  (emul_wb_stb_o),
  .sel  (emul_wb_sel_o),
  .we   (emul_wb_we_o),
  .ack  (emul_wb_ack_i),
  .err  (1'b0),
  .rty  (1'b0)
);

// UART receiver configuration
initial begin
  # `BENCH_RESET_TIME
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_FC,  4'b0010, {8'h00, 8'h00, 8'h07, 8'h00});
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_IE,  4'b0100, {8'h00, 8'h01, 8'h00, 8'h00});
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_LC,  4'b0001, {8'h00, 8'h00, 8'h00, 8'h03});
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_LC,  4'b0001, {8'h00, 8'h00, 8'h00, 8'h83}); // open DL
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_DL1, 4'b1000, {8'h45, 8'h00, 8'h00, 8'h00}); // divisor latch 1
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_DL2, 4'b0100, {8'h00, 8'h01, 8'h00, 8'h00}); // divisor latch 2
  @(posedge clk);
  u_emul_wb_rx.wb_wr1(`UART_REG_LC,  4'b0001, {8'h00, 8'h00, 8'h00, 8'h03}); // close DL
end

// Monitor
reg [31:0]  dat_o;
always @(int_o) begin
  if (int_o) begin
    u_emul_wb_rx.wb_rd1(0, 4'b1000, dat_o);
    $display("%m:%t:Data out:%c", $time, dat_o[31:24]);
  end
end
endmodule
