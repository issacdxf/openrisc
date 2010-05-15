// Verilog pattern output written by  TetraMAX (TM)  Z-2007.03-SP1-i070413_172030 
// Date: Fri Sep 18 17:15:31 2009
// Module tested: des

//     Uncollapsed Stuck Fault Summary Report
// -----------------------------------------------
// fault class                     code   #faults
// ------------------------------  ----  ---------
// Detected                         DT      34438
// Possibly detected                PT          0
// Undetectable                     UD        111
// ATPG untestable                  AU        546
// Not detected                     ND         13
// -----------------------------------------------
// total faults                             35108
// test coverage                            98.40%
// -----------------------------------------------
// 
//            Pattern Summary Report
// -----------------------------------------------
// #internal patterns                         131
//     #basic_scan patterns                   131
// -----------------------------------------------
// 
// rule  severity  #fails  description
// ----  --------  ------  ---------------------------------
// N2    warning      128  unsupported construct
// N16   warning        1  overspecified UDP
// N23   warning        1  inconsistent UDP
// B8    warning       20  unconnected module input pin
// B9    warning        1  undriven module internal net
// B10   warning        4  unconnected module internal net
// 
// clock_name        off  usage
// ----------------  ---  --------------------------
// hclk               0   master shift nonscan_DLAT 
// 
// port_name         constraint_value
// ----------------  ---------------
// POR                 1
// hresetn             1
// Test_Mode           1
// 
// There are no equivalent pins
// There are no net connections

`timescale 1 ns / 1 ns

//
// --- NOTE: Remove the comment to define 'tmax_iddq' to activate processing of IDDQ events
//     Or use '+define+tmax_iddq' on the verilog compile line
//
//`define tmax_iddq

module AAA_tmax_testbench_1_16 ;
   parameter NAMELENGTH = 200; // max length of names reported in fails
   parameter LENMAX = 112, NSHIFTS = 112; // LENMAX for serial
   parameter LENSERIAL = 112, NCHAINS = 4;
   parameter SHBEG = 0, SHEND = 0;
   integer nofails, bit, cbit, pattern, lastpattern, chain, idx;
   integer error_banner; // flag for tracking displayed error banner
   integer loads;        // number of load_unloads for current pattern
   integer patm1;        // pattern - 1
   integer patp1;        // pattern + lastpattern
   integer prev_pat;     // previous pattern number
   integer report_interval; // report pattern progress every Nth pattern
   integer verbose;      // message verbosity level
   parameter NINPUTS = 62, NOUTPUTS = 39;
   wire [0:NOUTPUTS-1] PO; reg [0:NOUTPUTS-1] ALLPOS, XPCT, MASK;
   reg [0:NINPUTS-1] PI, ALLPIS;
   reg [0:8*(NAMELENGTH-1)] POnames [0:NOUTPUTS-1];
   reg [0:8*(NAMELENGTH-1)] CHAINnames [0:NCHAINS-1];
   reg [0:8*(NAMELENGTH-1)] CHAINpins [0:NCHAINS-1];
   reg [0:LENSERIAL-1] LOAD0, LOADSH0, LOAD1, LOADSH1, LOAD2, LOADSH2, LOAD3,
   LOADSH3;
   reg [0:LENMAX-1] UNL, UNLOAD[0:NCHAINS-1];
   reg [0:LENMAX-1] UNLM, UNLMSK[0:NCHAINS-1], SHBEGM[0:NCHAINS-1];
   reg [0:LENMAX-1] SERIALM;
   reg [0:LENMAX-1] INPINV[0:NCHAINS-1], OUTINV[0:NCHAINS-1];
   wire [0:NCHAINS-1] SCANOUT;
   event IDDQ;

   wire hclk;
   wire POR;
   wire hresetn;
   wire hsel;
   wire hwrite;
   wire hready;
   wire hready_resp;
   wire Test_Mode;
   wire Test_Se;
   wire si0;
   wire si1;
   wire si2;
   wire si3;
   wire so0;
   wire so1;
   wire so2;
   wire so3;
   wire [31:0] hwdata;
   wire [9:0] haddr;
   wire [1:0] htrans;
   wire [2:0] hsize;
   wire [2:0] hburst;
   wire [1:0] hresp;
   wire [31:0] hrdata;

   // map PI[] vector to DUT inputs and bidis
   assign hclk = PI[0];
   assign POR = PI[1];
   assign hresetn = PI[2];
   assign hsel = PI[3];
   assign hwdata = PI[4:35];
   assign haddr = PI[36:45];
   assign hwrite = PI[46];
   assign htrans = PI[47:48];
   assign hsize = PI[49:51];
   assign hburst = PI[52:54];
   assign hready = PI[55];
   assign Test_Mode = PI[56];
   assign Test_Se = PI[57];
   assign si0 = PI[58];
   assign si1 = PI[59];
   assign si2 = PI[60];
   assign si3 = PI[61];

   // map DUT outputs and bidis to PO[] vector
   assign
      PO[0] = hready_resp ,
      PO[1] = hresp[1] ,
      PO[2] = hresp[0] ,
      PO[3] = hrdata[31] ,
      PO[4] = hrdata[30] ,
      PO[5] = hrdata[29] ,
      PO[6] = hrdata[28] ,
      PO[7] = hrdata[27] ,
      PO[8] = hrdata[26] ,
      PO[9] = hrdata[25] ,
      PO[10] = hrdata[24] ,
      PO[11] = hrdata[23] ,
      PO[12] = hrdata[22] ,
      PO[13] = hrdata[21] ,
      PO[14] = hrdata[20] ,
      PO[15] = hrdata[19] ,
      PO[16] = hrdata[18] ,
      PO[17] = hrdata[17] ,
      PO[18] = hrdata[16] ,
      PO[19] = hrdata[15] ,
      PO[20] = hrdata[14] ,
      PO[21] = hrdata[13] ,
      PO[22] = hrdata[12] ,
      PO[23] = hrdata[11] ,
      PO[24] = hrdata[10] ,
      PO[25] = hrdata[9] ,
      PO[26] = hrdata[8] ,
      PO[27] = hrdata[7] ,
      PO[28] = hrdata[6] ,
      PO[29] = hrdata[5] ,
      PO[30] = hrdata[4] ,
      PO[31] = hrdata[3] ;
   assign
      PO[32] = hrdata[2] ,
      PO[33] = hrdata[1] ,
      PO[34] = hrdata[0] ,
      PO[35] = so0 ,
      PO[36] = so1 ,
      PO[37] = so2 ,
      PO[38] = so3 ;

   // instantiate the design into the testbench
   des dut (
      .hclk(hclk),
      .POR(POR),
      .hresetn(hresetn),
      .hsel(hsel),
      .hwdata(hwdata),
      .haddr(haddr),
      .hwrite(hwrite),
      .htrans(htrans),
      .hsize(hsize),
      .hburst(hburst),
      .hready(hready),
      .hready_resp(hready_resp),
      .hresp(hresp),
      .hrdata(hrdata),
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

   event pulse_hclk;
   always @ pulse_hclk begin
      #45 PI[0] = 1; #10 PI[0] = 0;   // hclk
   end


   integer errshown;
   event measurePO;
   always @ measurePO begin
      if (((XPCT&MASK) !== (ALLPOS&MASK)) || (XPCT !== (~(~XPCT)))) begin
         errshown = 0;
         for (bit = 0; bit < NOUTPUTS; bit=bit + 1) begin
            if (MASK[bit]==1'b1) begin
               if (XPCT[bit] !== ALLPOS[bit]) begin
                  if (errshown==0) $display("\n// *** ERROR during capture pattern %0d, T=%t", pattern, $time);
                  $display("  %0d %0s (exp=%b, got=%b)", pattern, POnames[bit], XPCT[bit], ALLPOS[bit]);
                  nofails = nofails + 1; errshown = 1;
               end
            end
         end
      end
   end

   event forcePI_default_WFT;
   always @ forcePI_default_WFT begin
      PI = ALLPIS;
   end
   event measurePO_default_WFT;
   always @ measurePO_default_WFT begin
      #40;
      ALLPOS = PO;
      #0; #0 -> measurePO;
      `ifdef tmax_iddq
         #0; ->IDDQ;
      `endif
   end

   event force_scanin;
   always @ force_scanin begin
      PI[58] <= LOAD0[bit];
      PI[59] <= LOAD1[bit];
      PI[60] <= LOAD2[bit];
      PI[61] <= LOAD3[bit];
   end

   assign SCANOUT[0] = so0,  SCANOUT[1] = so1,  SCANOUT[2] = so2,  SCANOUT[3] = so3;

   event measure_scanout;
   always @ measure_scanout begin
      if ((NSHIFTS < LENMAX) && (bit >= SHBEG)) cbit = bit - LENMAX + NSHIFTS + 1 + SHBEG;
      else cbit = bit; // because parallel does NSHIFTS + 1 shifts
      idx = cbit + 0;
      for (chain = 0; chain < 4; chain=chain + 1) begin
         UNL = UNLOAD[chain]; UNLM = UNLMSK[chain];
         if ((UNL[idx]&UNLM[idx]) !== (SCANOUT[chain]&UNLM[idx])) begin
            patp1 = pattern + lastpattern;  patm1 = patp1 - 1;
            if (error_banner != pattern) begin
               if (lastpattern == 0) $display("\n// *** ERROR during scan pattern %0d (detected during load of pattern %0d)", patm1, patp1);
               else $display("\n// *** ERROR during scan pattern %0d (detected during final pattern unload)", patm1);
               error_banner = pattern;
            end
            $display("  %0d %0s %0d (exp=%b, got=%b)  // pin %0s, scan cell %0d, T=%t",
               patm1, CHAINnames[chain], cbit, UNL[idx], SCANOUT[chain], CHAINpins[chain], cbit, $time);
            nofails = nofails + 1;
         end
      end
   end


   always @ IDDQ begin
   `ifdef tmax_iddq
      $ssi_iddq("strobe_try");
      $ssi_iddq("status drivers leaky AAA_tmax_testbench_1_16.leaky");
   `endif
   end

   event capture;
   always @ capture begin
      ->forcePI_default_WFT;
      #100; ->measurePO_default_WFT;
   end

   event capture_hclk;
   always @ capture_hclk begin
      ->forcePI_default_WFT;
      #100; ->measurePO_default_WFT;
      #145 PI[0] = 1; // hclk
      #10 PI[0] = 0; // hclk
   end

   task shift;
   begin
      if (verbose >= 4) $display("// %t :    shift %0d", $time, bit);
      ->force_scanin;
      #40; ->measure_scanout;
      #5 PI[0] = 1; // hclk
      #10 PI[0] = 0; // hclk
      #45;
   end
   endtask

   event test_setup;
   always @ test_setup begin
      #0 PI[1] = 1; // POR
      #0 PI[56] = 1; // Test_Mode
      #0 PI[0] = 0; // hclk
      #0 PI[2] = 1; // hresetn
      #0 PI[45] = 1'bX; // haddr[0]
      #0 PI[44] = 1'bX; // haddr[1]
      #0 PI[43] = 1'bX; // haddr[2]
      #0 PI[42] = 1'bX; // haddr[3]
      #0 PI[41] = 1'bX; // haddr[4]
      #0 PI[40] = 1'bX; // haddr[5]
      #0 PI[39] = 1'bX; // haddr[6]
      #0 PI[38] = 1'bX; // haddr[7]
      #0 PI[37] = 1'bX; // haddr[8]
      #0 PI[36] = 1'bX; // haddr[9]
      #0 PI[54] = 1'bX; // hburst[0]
      #0 PI[53] = 1'bX; // hburst[1]
      #0 PI[52] = 1'bX; // hburst[2]
      #0 PI[55] = 1'bX; // hready
      #0 PI[3] = 1'bX; // hsel
      #0 PI[51] = 1'bX; // hsize[0]
      #0 PI[50] = 1'bX; // hsize[1]
      #0 PI[49] = 1'bX; // hsize[2]
      #0 PI[48] = 1'bX; // htrans[0]
      #0 PI[47] = 1'bX; // htrans[1]
      #0 PI[35] = 1'bX; // hwdata[0]
      #0 PI[25] = 1'bX; // hwdata[10]
      #0 PI[24] = 1'bX; // hwdata[11]
      #0 PI[23] = 1'bX; // hwdata[12]
      #0 PI[22] = 1'bX; // hwdata[13]
      #0 PI[21] = 1'bX; // hwdata[14]
      #0 PI[20] = 1'bX; // hwdata[15]
      #0 PI[19] = 1'bX; // hwdata[16]
      #0 PI[18] = 1'bX; // hwdata[17]
      #0 PI[17] = 1'bX; // hwdata[18]
      #0 PI[16] = 1'bX; // hwdata[19]
      #0 PI[34] = 1'bX; // hwdata[1]
      #0 PI[15] = 1'bX; // hwdata[20]
      #0 PI[14] = 1'bX; // hwdata[21]
      #0 PI[13] = 1'bX; // hwdata[22]
      #0 PI[12] = 1'bX; // hwdata[23]
      #0 PI[11] = 1'bX; // hwdata[24]
      #0 PI[10] = 1'bX; // hwdata[25]
      #0 PI[9] = 1'bX; // hwdata[26]
      #0 PI[8] = 1'bX; // hwdata[27]
      #0 PI[7] = 1'bX; // hwdata[28]
      #0 PI[6] = 1'bX; // hwdata[29]
      #0 PI[33] = 1'bX; // hwdata[2]
      #0 PI[5] = 1'bX; // hwdata[30]
      #0 PI[4] = 1'bX; // hwdata[31]
      #0 PI[32] = 1'bX; // hwdata[3]
      #0 PI[31] = 1'bX; // hwdata[4]
      #0 PI[30] = 1'bX; // hwdata[5]
      #0 PI[29] = 1'bX; // hwdata[6]
      #0 PI[28] = 1'bX; // hwdata[7]
      #0 PI[27] = 1'bX; // hwdata[8]
      #0 PI[26] = 1'bX; // hwdata[9]
      #0 PI[46] = 1'bX; // hwrite
      #0 PI[57] = 1'bX; // Test_Se
      #0 PI[58] = 1'bX; // si0
      #0 PI[59] = 1'bX; // si1
      #0 PI[60] = 1'bX; // si2
      #0 PI[61] = 1'bX; // si3
   end


   task multiple_shift;
   begin
      bit = bit-1;
      error_banner = -2;
      while (bit+1 < LENMAX-SHEND) begin
         bit = bit+1;
         shift;
      end
   end
   endtask

   event load_unload;
   always @ load_unload begin
      if (pattern != prev_pat) begin
         loads = 1;
         prev_pat = pattern;
         if ((verbose >= 2) && (pattern % report_interval == 0))
            $display("// %t : ...begin scan load for pattern %0d", $time, pattern);
         end
      else begin
         loads = loads + 1;
         if ((verbose >= 2) && (pattern % report_interval == 0))
            $display("// %t : ...begin scan load for pattern %0d, load %0d", $time, pattern, loads);
      end

      #0 PI[0] = 0; // hclk
      #0 PI[58] = 1'bX; // si0
      #0 PI[59] = 1'bX; // si1
      #0 PI[60] = 1'bX; // si2
      #0 PI[61] = 1'bX; // si3
      #0 PI[57] = 1; // Test_Se
      #0 PI[1] = 1; // POR
      #0 PI[56] = 1; // Test_Mode
      #0 PI[2] = 1; // hresetn
      #100;
      // end of load_unload preamble
      bit = SHBEG; multiple_shift;
   end


   initial begin

      //
      // --- establish a default time format for %t
      //
      $timeformat(-9,2," ns",18);

      //
      // --- default verbosity to 2 but also allow user override by
      //     using '+define+tmax_msg=N' on verilog compile line.
      //
      `ifdef tmax_msg
         verbose = `tmax_msg ;
      `else
         verbose = 2 ;
      `endif

      //
      // --- default pattern reporting interval to 5 but also allow user
      //     override by using '+define+tmax_rpt=N' on verilog compile line.
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
         // extended VCD, see IEEE Verilog P1364.1-1999 Draft 2
         if (verbose >= 2) $display("// %t : opening Extended VCD output file", $time);
         $dumpports( dut, "sim_vcde.out");
      `endif

      //
      // --- IDDQ PLI initialization
      //     User may activite by using '+define+tmax_iddq' on verilog compile line.
      //     Or by defining `tmax_iddq in this file.
      //
      `ifdef tmax_iddq
         if (verbose >= 3) $display("// %t : Initializing IDDQ PLI", $time);
         $ssi_iddq("dut AAA_tmax_testbench_1_16.dut");
         $ssi_iddq("verb on");
         $ssi_iddq("cycle 0");
         //
         // --- User may select one of the following two methods for fault seeding:
         //     #1 faults seeded by PLI (default)
         //     #2 faults supplied in a file
         //     Comment out the unused lines as needed (precede with '//').
         //     Replace the 'FAULTLIST_FILE' string with the actual file pathname.
         //
         $ssi_iddq("seed SA AAA_tmax_testbench_1_16.dut");   // no file, faults seeded by PLI
         //
         // $ssi_iddq("scope AAA_tmax_testbench_1_16.dut");   // set scope for faults from a file
         // $ssi_iddq("read_tmax FAULTLIST_FILE"); // read faults from a file
         //
      `endif

      POnames[0] = "hready_resp";
      POnames[1] = "hresp[1]";
      POnames[2] = "hresp[0]";
      POnames[3] = "hrdata[31]";
      POnames[4] = "hrdata[30]";
      POnames[5] = "hrdata[29]";
      POnames[6] = "hrdata[28]";
      POnames[7] = "hrdata[27]";
      POnames[8] = "hrdata[26]";
      POnames[9] = "hrdata[25]";
      POnames[10] = "hrdata[24]";
      POnames[11] = "hrdata[23]";
      POnames[12] = "hrdata[22]";
      POnames[13] = "hrdata[21]";
      POnames[14] = "hrdata[20]";
      POnames[15] = "hrdata[19]";
      POnames[16] = "hrdata[18]";
      POnames[17] = "hrdata[17]";
      POnames[18] = "hrdata[16]";
      POnames[19] = "hrdata[15]";
      POnames[20] = "hrdata[14]";
      POnames[21] = "hrdata[13]";
      POnames[22] = "hrdata[12]";
      POnames[23] = "hrdata[11]";
      POnames[24] = "hrdata[10]";
      POnames[25] = "hrdata[9]";
      POnames[26] = "hrdata[8]";
      POnames[27] = "hrdata[7]";
      POnames[28] = "hrdata[6]";
      POnames[29] = "hrdata[5]";
      POnames[30] = "hrdata[4]";
      POnames[31] = "hrdata[3]";
      POnames[32] = "hrdata[2]";
      POnames[33] = "hrdata[1]";
      POnames[34] = "hrdata[0]";
      POnames[35] = "so0";
      POnames[36] = "so1";
      POnames[37] = "so2";
      POnames[38] = "so3";
      CHAINnames[0] = "chain_1";
      CHAINnames[1] = "chain_2";
      CHAINnames[2] = "chain_3";
      CHAINnames[3] = "chain_4";
      CHAINpins[0] = "so0";
      CHAINpins[1] = "so1";
      CHAINpins[2] = "so2";
      CHAINpins[3] = "so3";
      SERIALM = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      nofails = 0; pattern = -1; lastpattern = 0;
      prev_pat = -2; error_banner = -2;

      if (verbose >=1) $display("// %t : Begin test_setup", $time);
      ->test_setup;
      #200; // 200


      /*** Scan test ***/

      if (verbose >= 1) $display("// %t : Begin patterns, first pattern = 0", $time);
pattern = 0; // 200
LOAD0 = 112'b0011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011;
LOAD1 = 112'b0001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001;
LOAD2 = 112'b0001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001;
LOAD3 = 112'b0001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001;
UNLMSK[0] = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
UNLMSK[1] = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
UNLMSK[2] = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
UNLMSK[3] = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
#0 ->load_unload;
#11300; // 11500
ALLPIS = 62'b0110100011110100010111010000111100111001111100011111111011XXXX;
XPCT = 39'b100000000000000000000000000001001100000;
MASK = 39'b111111111111111111111111111111111111111;
#0 ->capture;
#200; // 11700

lastpattern = 1;
LOAD0 = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
LOAD1 = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
LOAD2 = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
LOAD3 = 112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
UNLOAD[0] = 112'b0011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011;
UNLMSK[0] = 112'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
UNLOAD[1] = 112'b001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001x;
UNLMSK[1] = 112'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110;
UNLOAD[2] = 112'b001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001x;
UNLMSK[2] = 112'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110;
UNLOAD[3] = 112'b001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001x;
UNLMSK[3] = 112'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110;
#0 ->load_unload;
#11300; // 23000
      $display("// %t : Simulation of %0d patterns completed with %0d errors\n", $time, pattern+1, nofails);
      if (verbose >=2) $finish(2);
      /* else */ $finish(0);
   end
endmodule
