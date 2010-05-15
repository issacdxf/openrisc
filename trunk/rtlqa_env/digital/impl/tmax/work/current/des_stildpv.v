// Verilog STILDPV testbench written by  TetraMAX (TM)  Z-2007.03-SP1-i070413_172030 
// Date: Fri Sep 18 17:15:31 2009
// Module tested: des

`timescale 1 ns / 1 ns

module des_test;
   integer verbose;         // message verbosity level
   integer report_interval; // pattern reporting intervals
   integer diagnostic_msg;  // format miscompares for TetraMAX diagnostics
   parameter NINPUTS = 62, NOUTPUTS = 39;
   // The next two variables hold the current value of the TetraMAX pattern number
   // and vector number, while the simulation is progressing. $monitor or $display these
   // variables, or add them to waveform views, to see these values change with time
   integer pattern_number;
   integer vector_number;

   wire hclk;  reg hclk_REG ;
   wire POR;  reg POR_REG ;
   wire hresetn;  reg hresetn_REG ;
   wire hsel;  reg hsel_REG ;
   wire hwrite;  reg hwrite_REG ;
   wire hready;  reg hready_REG ;
   wire hready_resp;
   wire Test_Mode;  reg Test_Mode_REG ;
   wire Test_Se;  reg Test_Se_REG ;
   wire si0;  reg si0_REG ;
   wire si1;  reg si1_REG ;
   wire si2;  reg si2_REG ;
   wire si3;  reg si3_REG ;
   wire so0;
   wire so1;
   wire so2;
   wire so3;
   wire [31:0] hwdata;
//   reg [31:0] hwdata_REG;
   reg \hwdata_REG[0] ;
   reg \hwdata_REG[1] ;
   reg \hwdata_REG[2] ;
   reg \hwdata_REG[3] ;
   reg \hwdata_REG[4] ;
   reg \hwdata_REG[5] ;
   reg \hwdata_REG[6] ;
   reg \hwdata_REG[7] ;
   reg \hwdata_REG[8] ;
   reg \hwdata_REG[9] ;
   reg \hwdata_REG[10] ;
   reg \hwdata_REG[11] ;
   reg \hwdata_REG[12] ;
   reg \hwdata_REG[13] ;
   reg \hwdata_REG[14] ;
   reg \hwdata_REG[15] ;
   reg \hwdata_REG[16] ;
   reg \hwdata_REG[17] ;
   reg \hwdata_REG[18] ;
   reg \hwdata_REG[19] ;
   reg \hwdata_REG[20] ;
   reg \hwdata_REG[21] ;
   reg \hwdata_REG[22] ;
   reg \hwdata_REG[23] ;
   reg \hwdata_REG[24] ;
   reg \hwdata_REG[25] ;
   reg \hwdata_REG[26] ;
   reg \hwdata_REG[27] ;
   reg \hwdata_REG[28] ;
   reg \hwdata_REG[29] ;
   reg \hwdata_REG[30] ;
   reg \hwdata_REG[31] ;
   wire [9:0] haddr;
//   reg [9:0] haddr_REG;
   reg \haddr_REG[0] ;
   reg \haddr_REG[1] ;
   reg \haddr_REG[2] ;
   reg \haddr_REG[3] ;
   reg \haddr_REG[4] ;
   reg \haddr_REG[5] ;
   reg \haddr_REG[6] ;
   reg \haddr_REG[7] ;
   reg \haddr_REG[8] ;
   reg \haddr_REG[9] ;
   wire [1:0] htrans;
//   reg [1:0] htrans_REG;
   reg \htrans_REG[0] ;
   reg \htrans_REG[1] ;
   wire [2:0] hsize;
//   reg [2:0] hsize_REG;
   reg \hsize_REG[0] ;
   reg \hsize_REG[1] ;
   reg \hsize_REG[2] ;
   wire [2:0] hburst;
//   reg [2:0] hburst_REG;
   reg \hburst_REG[0] ;
   reg \hburst_REG[1] ;
   reg \hburst_REG[2] ;
   wire [1:0] hresp;
   wire [31:0] hrdata;

   // map register to wire for DUT inputs and bidis
   assign hclk = hclk_REG ;
   assign POR = POR_REG ;
   assign hresetn = hresetn_REG ;
   assign hsel = hsel_REG ;
   assign hwdata = { \hwdata_REG[31] , \hwdata_REG[30] , \hwdata_REG[29] , \hwdata_REG[28]
          , \hwdata_REG[27] , \hwdata_REG[26] , \hwdata_REG[25] , \hwdata_REG[24]
          , \hwdata_REG[23] , \hwdata_REG[22] , \hwdata_REG[21] , \hwdata_REG[20]
          , \hwdata_REG[19] , \hwdata_REG[18] , \hwdata_REG[17] , \hwdata_REG[16]
          , \hwdata_REG[15] , \hwdata_REG[14] , \hwdata_REG[13] , \hwdata_REG[12]
          , \hwdata_REG[11] , \hwdata_REG[10] , \hwdata_REG[9] , \hwdata_REG[8] ,
          \hwdata_REG[7] , \hwdata_REG[6] , \hwdata_REG[5] , \hwdata_REG[4] , \hwdata_REG[3]
          , \hwdata_REG[2] , \hwdata_REG[1] , \hwdata_REG[0]  };
   assign haddr = { \haddr_REG[9] , \haddr_REG[8] , \haddr_REG[7] , \haddr_REG[6]
          , \haddr_REG[5] , \haddr_REG[4] , \haddr_REG[3] , \haddr_REG[2] , \haddr_REG[1]
          , \haddr_REG[0]  };
   assign hwrite = hwrite_REG ;
   assign htrans = { \htrans_REG[1] , \htrans_REG[0]  };
   assign hsize = { \hsize_REG[2] , \hsize_REG[1] , \hsize_REG[0]  };
   assign hburst = { \hburst_REG[2] , \hburst_REG[1] , \hburst_REG[0]  };
   assign hready = hready_REG ;
   assign Test_Mode = Test_Mode_REG ;
   assign Test_Se = Test_Se_REG ;
   assign si0 = si0_REG ;
   assign si1 = si1_REG ;
   assign si2 = si2_REG ;
   assign si3 = si3_REG ;

   // instantiate the design into the testbench
   des dut (
      .hclk(hclk),
      .POR(POR),
      .hresetn(hresetn),
      .hsel(hsel),
      .hwdata({ hwdata[31], hwdata[30], hwdata[29], hwdata[28], hwdata[27],
          hwdata[26], hwdata[25], hwdata[24], hwdata[23], hwdata[22], hwdata[21],
          hwdata[20], hwdata[19], hwdata[18], hwdata[17], hwdata[16], hwdata[15],
          hwdata[14], hwdata[13], hwdata[12], hwdata[11], hwdata[10], hwdata[9],
          hwdata[8], hwdata[7], hwdata[6], hwdata[5], hwdata[4], hwdata[3], hwdata[2],
          hwdata[1], hwdata[0] }),
      .haddr({ haddr[9], haddr[8], haddr[7], haddr[6], haddr[5],
          haddr[4], haddr[3], haddr[2], haddr[1], haddr[0] }),
      .hwrite(hwrite),
      .htrans({ htrans[1], htrans[0]
          }),
      .hsize({ hsize[2], hsize[1], hsize[0] }),
      .hburst({ hburst[2], hburst[1], hburst[0] }),
      .hready(hready),
      .hready_resp(hready_resp),
      .hresp({
          hresp[1], hresp[0] }),
      .hrdata({ hrdata[31], hrdata[30], hrdata[29], hrdata[28],
          hrdata[27], hrdata[26], hrdata[25], hrdata[24], hrdata[23], hrdata[22],
          hrdata[21], hrdata[20], hrdata[19], hrdata[18], hrdata[17], hrdata[16],
          hrdata[15], hrdata[14], hrdata[13], hrdata[12], hrdata[11], hrdata[10],
          hrdata[9], hrdata[8], hrdata[7], hrdata[6], hrdata[5], hrdata[4], hrdata[3],
          hrdata[2], hrdata[1], hrdata[0] }),
      .Test_Mode(Test_Mode),
      .Test_Se(Test_Se),
      .si0(si0),
      .si1(si1),
      .si2(si2),
      .si3(si3),
      .so0(so0),
      .so1(so1),
      .so2(so2),
      .so3(so3)   );

   // STIL Direct Pattern Validate Access
   initial begin
      //
      // --- establish a default time format for %t
      //
      $timeformat(-9,2," ns",18);
      vector_number = 0;

      //
      // --- default verbosity to 0; use '+define+tmax_msg=N' on verilog compile line to change.
      //
      `ifdef tmax_msg
         verbose = `tmax_msg ;
      `else
         verbose = 0 ;
      `endif

      //
      // --- default pattern reporting interval is every 5 patterns;
      //     use '+define+tmax_rpt=N' on verilog compile line to change.
      //
      `ifdef tmax_rpt
         report_interval = `tmax_rpt ;
      `else
         report_interval = 5 ;
      `endif

      //
      // --- support generating Extened VCD output by using
      //     '+define+tmax_vcde' on verilog compile line.
      //
      `ifdef tmax_vcde
         // extended VCD, see Verilog specification, IEEE Std. 1364-2001 section 18.3
         if (verbose >= 1) $display("// %t : opening Extended VCD output file", $time);
         $dumpports( dut, "sim_vcde.out");
      `endif

      //
      // --- default miscompare messages are not formatted for TetraMAX diagnostics;
      //     use '+define+tmax_diag=N' on verilog compile line to format errors for diagnostics.
      //
      `ifdef tmax_diag
         diagnostic_msg = `tmax_diag ;
      `else
         diagnostic_msg = 0 ;
      `endif

      // '+define+tmax_parallel=N' on the command line overrides default simulation, using parallel load
      //   with N serial vectors at the end of each Shift
      // '+define+tmax_serial=M' on the command line forces M initial serial patterns,
      //   followed by the remainder in parallel (with N serial vectors if tmax_parallel is also specified)

      // TetraMAX serial-mode simulation requested by default
      `ifdef tmax_parallel
         `ifdef tmax_serial
            $STILDPV_parallel(`tmax_parallel,`tmax_serial);
         `else
            $STILDPV_parallel(`tmax_parallel,0);
         `endif
      `else
         `ifdef tmax_serial
            $STILDPV_parallel(0,`tmax_serial);
         `endif
      `endif

      if (verbose>3)      $STILDPV_trace(1,1,1,1,1,report_interval,diagnostic_msg); // verbose=4; + trace each Vector
      else if (verbose>2) $STILDPV_trace(1,0,1,1,1,report_interval,diagnostic_msg); // verbose=3; + trace labels
      else if (verbose>1) $STILDPV_trace(0,0,1,1,1,report_interval,diagnostic_msg); // verbose=2; + trace WFT-changes
      else if (verbose>0) $STILDPV_trace(0,0,1,0,1,report_interval,diagnostic_msg); // verbose=1; + trace proc/macro entries
      else                $STILDPV_trace(0,0,0,0,0,report_interval,diagnostic_msg); // verbose=0; only pattern-interval

      $STILDPV_setup( "/export/home/user/wangyl/rtlqa_env/digital/impl/tmax/work/current/des.stil",,,"des_test.dut" );
      while ( !$STILDPV_done()) #($STILDPV_run( pattern_number, vector_number ));
      $display("Time %t: STIL simulation data completed.",$time);
      $finish; // comment this out if you terminate the simulation from other activities
   end

   // STIL Direct Pattern Validate Trace Options
   // The STILDPV_trace() function takes '1' to enable a trace and '0' to disable.
   // Unspecified arguments maintain their current state. Tracing may be changed at any time.
   // The following arguments control tracing of:
   // 1st argument: enable or disable tracing of all STIL labels
   // 2nd argument: enable or disable tracing of each STIL Vector and current Vector count
   // 3rd argument: enable or disable tracing of each additional Thread (new Pattern)
   // 4th argument: enable or disable tracing of each WaveformTable change
   // 5th argument: enable or disable tracing of each Procedure or Macro entry
   // 6th argument: interval to print starting pattern messages; 0 to disable
   // For example, a separate initial block may be used to control these options
   // (uncomment and change time values to use):
   // initial begin
   //    #800000 $STILDPV_trace(1,1);
   //    #600000 $STILDPV_trace(,0);
   // Additional calls to $STILDPV_parallel() may also be defined to change parallel/serial
   // operation during simulation. Any additional calls need a # time value.
   // 1st integer is number of serial (flat) cycles to simulate at end of each shift
   // 2nd integer is TetraMAX pattern number (starting at zero) to start parallel load
   // 3rd optional value '1' will advance time during the load_unload the same as a serial
   //     shift operation (with no events during that time), '0' will advance minimal time
   //     (1 shift vector) during the parallel load_unload.
   // For example,
   //    #8000 $STILDPV_parallel( 2,10 );
   // end // of initial block with additional trace/parallel options
endmodule
