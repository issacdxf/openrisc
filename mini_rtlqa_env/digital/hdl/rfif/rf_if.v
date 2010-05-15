`timescale 1ns/10ps


// if define RTL_FPGA, code use for FPGA sythsis; or use for ASIC
// if define CHIPSCOPE, add signal for CHIPSCOPE



`ifdef  RTL_FPGA
module rf_if_fpga
`else
module rf_if
`endif
 (
  //input
  nReset_i,

  CLK_RF_i,       //from RF analog circuit, 13.56MHz clock
  DIN_RF_i,       //from RF analog circuit, demodulation signal

  Clk_i,          //System clock
  En_i,           //registers select
  Addr_i,         //registers address
  Write_i,        //write registers enable
  Data_i,         //data from ARM
  Idle_Cpu_i,     //CPU in IDLE mode


  //output
  DOUT_RF_o,      //to RF analog circuit, modulation signal. low active
  OENB_RF_o,      //to RF analog circuit, 0: modulation active, close demodulation circuit  1: modulation close, open demodulation circuit
  ACB_RF_o,       //to RF analog circuit, ACB enable, high active
  ACB_VALUE_RF_o, //to RF analog circuit, ACB_VALUE[2:0]

  Data_o,         //to ARM, register data

  `ifdef  RTL_FPGA
    `ifdef  CHIPSCOPE
  Int_o,           //to ARM, interrupt signal
  //add for test
  clk_rx         ,
  clk_tx         ,
  rf_in_en       ,
//  timeout        ,
  fp             ,
  rst_fp         ,
//  tx_en          ,
  tx_rf          ,
  txosm          ,
//  rx_en          ,
  rx_rf          ,
  eof_found      ,
  egt_over       ,
  rxosm          ,
  tx_clr         ,
  rx_clr         ,
  rx_set         ,
  sof_found      ,
  sof_err_found  ,
  sof_over_time  ,
  timer_clr      ,
  rf_din_samp_d  ,
  clk_wr         ,
  fifo_rst       ,
  fifo_wr        ,
  clk_rd         ,
  fifo_rd        ,
  clk_fsm        ,
//  nrst_rf_state  ,
  int_tx_rf      ,
  int_rx_rf      ,
  CurRFState     ,
  fifo_din       ,
  fifo_dout      ,
  wptr_dout      ,
  rptr_dout      ,
  rx_data        ,
  RFSetupReg
    `else
  Int_o            //to ARM, interrupt signal
    `endif
  `else
  Int_o            //to ARM, interrupt signal
  `endif

  );

input         nReset_i;

input         CLK_RF_i;
input         DIN_RF_i;

input         Clk_i;
input         En_i;
input  [ 7:0] Addr_i;
input         Write_i;
input  [31:0] Data_i;

input         Idle_Cpu_i;

output        DOUT_RF_o;
output        OENB_RF_o;
output        ACB_RF_o;
output [ 2:0] ACB_VALUE_RF_o;

output [31:0] Data_o;
output        Int_o;

`ifdef  RTL_FPGA
  `ifdef  CHIPSCOPE
//add for test
output        clk_rx         ;
output        clk_tx         ;
output        rf_in_en       ;
//output        timeout        ;
output        fp             ;
output        rst_fp         ;
//output        tx_en          ;
output        tx_rf          ;
output        txosm          ;
//output        rx_en          ;
output        rx_rf          ;
output        eof_found      ;
output        egt_over       ;
output        rxosm          ;
output        tx_clr         ;
output        rx_clr         ;
output        rx_set         ;
output        sof_found      ;
output        sof_err_found  ;
output        sof_over_time  ;
output        timer_clr      ;
output        rf_din_samp_d  ;
output        clk_wr         ;
output        fifo_rst       ;
output        fifo_wr        ;
output        clk_rd         ;
output        fifo_rd        ;
output        clk_fsm        ;
//output        nrst_rf_state  ;
output        int_tx_rf      ;
output        int_rx_rf      ;
output  [3:0] CurRFState     ;
output  [7:0] fifo_din       ;
output  [7:0] fifo_dout      ;
output  [7:0] wptr_dout      ;
output  [7:0] rptr_dout      ;
output [12:0] rx_data        ;
output  [3:0] RFSetupReg     ;
  `endif
`endif


wire        CLK_RF_i;
wire        DIN_RF_i;

wire [31:0] Data_o;

wire [ 7:0] RFDataReg;
wire [ 7:0] RFWptrReg;
wire [ 7:0] RFRptrReg;
reg  [ 3:0] RFSetupReg;
reg  [ 7:0] RFModeReg;
reg  [15:0] RFFeatureReg;



wire        err      ;           //RFCtrlReg[ 0];
reg         acb      ;           //RFCtrlReg[ 1];
reg         arx      ;           //RFCtrlReg[ 2];
wire        f_f      ;           //RFCtrlReg[ 3];
reg         tx       ;           //RFCtrlReg[ 4];
wire        f_e      ;           //RFCtrlReg[ 5];
reg         rx       ;           //RFCtrlReg[ 6];
reg         rfp      ;           //RFCtrlReg[ 7];



reg         crcerr   ;           //RFStateReg[ 0]
wire        ferr     ;           //RFStateReg[ 1]
wire        egterr   ;           //RFStateReg[ 2]
wire        berr     ;           //RFStateReg[ 3]


wire        txosm     ;          //RFModeReg[  0]
wire        rxosm     ;          //RFModeReg[  1]
wire [ 1:0] rxosm_tim ;          //RFModeReg[3:2]
wire [ 2:0] txosm_tim ;          //RFModeReg[6:4]
wire        rfptx     ;          //RFModeReg[  7]


wire        tb_egt          ;    //RFFeatureReg[    0]
wire [ 1:0] swuptx_tim      ;    //RFFeatureReg[ 3: 2]
wire [ 3:0] trtr1           ;    //RFFeatureReg[ 7: 4]
wire        dis_int_on_err  ;    //RFFeatureReg[    8]
wire        crc_en          ;    //RFFeatureReg[    9]
wire        sof_dis         ;    //RFFeatureReg[   10]
wire        eof_dis         ;    //RFFeatureReg[   11]
wire        acb_auto_close  ;    //RFFeatureReg[   12]
wire [ 2:0] acb_value       ;    //RFFeatureReg[15:13]





//for REGISTER
//RFDataReg
wire        RFDataReg_Write;
wire        RFDataReg_Read;
wire        RFDataReg_Read_d;
wire [ 7:0] RFDataReg_Dout;

//RFWptrReg
wire        RFWptrReg_Write;
wire        RFWptrReg_Read;
wire [ 7:0] RFWptrReg_Dout;

//RFRptrReg
wire        RFRptrReg_Write;
wire        RFRptrReg_Read;
wire [ 7:0] RFRptrReg_Dout;

//RFSetupReg
wire        RFSetupReg_Write;
wire        RFSetupReg_Read;
wire [ 5:0] RFSetupReg_Dout;

//RFCtrlReg
wire        RFCtrlReg_Write;
wire        RFCtrlReg_Read;
wire [ 7:0] RFCtrlReg_Dout;

//RFStateReg
wire        RFStateReg_Read;
wire [ 3:0] RFStateReg_Dout;

//RFModeReg
wire        RFModeReg_Write;
wire        RFModeReg_Read;
wire [ 7:0] RFModeReg_Dout;

//RFFeatureReg
wire        RFFeatureReg_Write;
wire        RFFeatureReg_Read;
wire [15:0] RFFeatureReg_Dout;



//reg         nrst_rf_reg_d0;
reg  [ 1:0] nrst_rf_reg;
wire        nrst_rf;

//for RF_CTRL FSM
reg  [ 3:0] CurRFState;
reg  [ 3:0] NxtRFState;

// RF state
wire        rf_state_idle       ;    // idle
wire        rf_state_tx_delay1  ;    // for tx
wire        rf_state_tx_tr1     ;    // for tx
wire        rf_state_tx_sof     ;    // for tx
wire        rf_state_tx_data    ;    // for tx
wire        rf_state_tx_crc     ;    // for tx
wire        rf_state_tx_eof     ;    // for tx
wire        rf_state_tx_delay2  ;    // for tx

wire        rf_state_rx_delay1  ;    // for rx
wire        rf_state_rx_sof     ;    // for rx
wire        rf_state_rx_data    ;    // for rx

wire        rf_state_send_int   ;    // for int


//reg  [ 1:0] idle_cpu_rf_d2;
//wire        idle_cpu_rf;

wire        acb_clr;
reg         rx_rf_d1;
reg         rx_rf_d2;
reg         rx_rf_d3;
reg         tx_rf_d1;
reg         tx_rf_d2;
reg         tx_rf_d3;
wire        rx_rf;
wire        tx_rf;
wire        rx_rf_rise;
wire        tx_rf_rise;

wire        int_rx_rf_set;
//wire        int_tx_rf_set;
wire        rx_cpu_rise;
wire        rx_cpu_fall;
wire        rx_clr;
wire        tx_cpu_rise;
wire        tx_cpu_fall;
wire        tx_clr;

reg         rx_set;
reg         rx_set_rf2cpu_tmp;
reg  [ 1:0] rx_set_rf2cpu_d2;
wire        rx_set_cpu;

wire        time_td1_over;
wire        time_td2_over;
wire        time_tr1_over;
wire        time_rd1_over;
wire        time_sof_over;

wire        time_data_over;
wire        time_crc_over;
wire        time_eof_over;

//wire        rx_en;
//wire        tx_en;

wire [13:0] timer;
wire        timer_clr;
wire        timer_inc;

reg  [ 9:0] timer_high;
reg         timer_high_inc;
//wire        nrst_timer_high;

wire        tx_data_end;
wire        rf_fifo_sof_dis;

reg         Int_o;

reg         rf_fifo_read_en;
wire        rf_fifo_read;
wire        tx_crc_en;
wire        read_crc1;
wire        read_crc2;

wire        crc_clk     ;
wire        crc_nrst    ;
wire        crc_syn_rst ;
wire        crc_en_avail;
wire [ 7:0] crc_din;
wire [15:0] crc_dout;

wire [ 1:0] bit_rate_rx;
wire [ 1:0] bit_rate_tx;


//wire        nrst_acb;
//reg  [ 1:0] acb_clr_rf2cpu;
//wire        acb_clr_cpu;

//afifo
//reg         clk_wr     ;
wire        clk_wr     ;
wire        rst_wr     ;
wire        syn_rst_wr ;
wire        fifo_wr    ;
wire  [7:0] fifo_din   ;
wire        wptr_wr    ;
wire  [7:0] wptr_din   ;
wire        fifo_full  ;
wire  [7:0] wptr_dout  ;
wire  [8:0] in_status  ;

//reg         clk_rd     ;
wire        clk_rd     ;
wire        rst_rd     ;
wire        syn_rst_rd ;
wire        fifo_rd    ;
wire        rptr_wr    ;
wire  [7:0] rptr_din   ;
wire  [7:0] fifo_dout  ;
wire        fifo_empty ;
wire  [7:0] rptr_dout  ;
wire  [8:0] out_status ;

//wire        syn_fifo_rst;

//wire        nrst_tx_dout;
wire        fifo_rst;

wire        fifo_wr_avail ;
wire        wptr_wr_avail ;
wire        fifo_rd_avail ;
wire        rptr_wr_avail ;

reg         ferr_over;
reg         ferr_under;
//reg  [ 1:0] ferr_over_rd_d2;
//reg  [ 1:0] ferr_under_wr_d2;
//wire        ferr_over_rd;
//wire        ferr_under_wr;
//wire        ferr_wr;
//wire        ferr_rd;



reg         rfptx_rst;

wire        int_rf;
reg         int_tx_rf;
reg         int_rx_rf;
reg  [1:0]  int_tx_cpu2rf;
reg  [1:0]  int_rx_cpu2rf;
wire        int_tx_rf_clr;
wire        int_rx_rf_clr;

reg  [2:0]  int_tx_rf2cpu;
reg  [2:0]  int_rx_rf2cpu;
reg         int_rx_cpu;
reg         int_tx_cpu;
wire        int_cpu;
reg         int_cpu_d;

//wire        int_rx_rf_nrst;

wire        f_e_cpu; 
reg         fifo_empty_d1;
reg         fifo_empty_d2;
reg         fifo_empty_tx_d1;
//reg         fifo_empty_tx_d2;


// for decoder module

//wire        pause_rst;

reg         clk_6m78;
reg         clk_3m39;
reg         clk_1m7;
reg         clk_848k;
reg         clk_848k_2;

reg         fifo_wr_rf;



wire [ 7:0] rf_decode_dout;
wire        rf_decode_dout_bit;
reg         rf_in_en;

reg  [12:0] rx_data;


reg  [ 3:0] count_fs16;
reg  [ 4:0] count_etu;
//reg         in_en_delay;

reg         rf_din_samp_0;
reg         rf_din_samp_1;
reg         rf_din_samp;

//reg         clk_rx;
wire        clk_rx;
wire        clk_tx;
wire        clk_fsm;

//wire        nrst_rf_state;


//wire        rf_clk;
//wire        clk_rf;
//reg         timeout;

//wire        clk_etu;

reg         rf_din_samp_d;
//wire        rise_din_samp;
wire        fall_din_samp;

//wire        data_rst;
//wire        data_set;
reg         fp;

wire        rst_fp;

//reg         sof_err_found;
wire        sof_err_found;
reg         sof_found;
wire        sof_over_time;

reg         eof_found;

wire        crc_error;
reg         egt_over;
reg         bitend_error;




//for encoder module
wire        rf_dout_t1;
wire        rf_dout_t2;
wire        dout_rise;

//wire        out_en_tmp;
//reg         out_en;
wire        out_en;

wire        dout;
//reg          dout;

reg         dout_d1;

reg  [ 9:0] tx_dout_byte;

reg  [ 7:2] addr_d;
reg         write_d;
reg         en_d;

//wire        err_cpu;
//reg  [ 1:0] err_cpu_d2;
//reg         err_rx;
wire        nrst_err;
reg  [ 1:0] ferr_cpu_d2;
wire        ferr_cpu;

reg         tx_avail;
reg         rx_avail;


//TIMER Parameter
reg [ 8:0] numb_txosm_tim;
reg [ 8:0] numb_trtr1;
reg [ 4:0] numb_swuptx_tim;
reg [ 6:0] numb_rxosm_tim;


reg        rfp_cpu2rf_tmp;
reg  [1:0] rfp_cpu2rf_d2;
wire       rfp_rf;



always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      begin
        addr_d  <= 6'h00;
        write_d <= 1'b0;
        en_d    <= 1'b0;
      end
    //else if (En_i)
    else
      begin
        addr_d  <= Addr_i[7:2];
        write_d <= Write_i;
        en_d    <= En_i;
      end
  end



//**************************
//**** Registers define ****
//**************************

//RFDataReg
assign  RFDataReg_Write  = (Addr_i[7:2]==6'h00) && En_i && Write_i  && ~rx;       // not allow CPU write while RX
assign  RFDataReg_Read   = (Addr_i[7:2]==6'h00) && En_i && ~Write_i && ~tx;       // not allow CPU read  while TX, for read register filer signal
assign  RFDataReg_Read_d = (addr_d[7:2]==6'h00) && en_d && ~write_d && ~tx;       // not allow CPU read  while TX, for output register filer data
assign  RFDataReg_Dout   = RFDataReg_Read_d ? fifo_dout : 8'h00;
assign  RFDataReg        = fifo_dout;



//RFWptrReg
assign  RFWptrReg_Write = (Addr_i[7:2]==6'h01) && En_i && Write_i  && ~rx;     // not allow write while RX
assign  RFWptrReg_Read  = (addr_d[7:2]==6'h01) && en_d && ~write_d;            // allow read  while RX, but data maybe invalid
assign  RFWptrReg_Dout  = RFWptrReg_Read ? RFWptrReg : 8'h00;
assign  RFWptrReg       = wptr_dout;



//RFRptrReg
assign  RFRptrReg_Write = (Addr_i[7:2]==6'h02) && En_i && Write_i  && ~tx;     // not allow write while TX
assign  RFRptrReg_Read  = (addr_d[7:2]==6'h02) && en_d && ~write_d;            // allow read  while TX, but data maybe invalid
assign  RFRptrReg_Dout  = RFRptrReg_Read ? RFRptrReg : 8'h00;
assign  RFRptrReg       = rptr_dout;



//RFSetupReg
assign  RFSetupReg_Write = (Addr_i[7:2]==6'h03) && En_i && Write_i;
assign  RFSetupReg_Read  = (addr_d[7:2]==6'h03) && en_d && ~write_d;
assign  RFSetupReg_Dout  = RFSetupReg_Read ? {RFSetupReg[3:2], 2'b00, RFSetupReg[1:0]} : 6'h00;

always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      RFSetupReg <= 4'h0;
    else if (RFSetupReg_Write)
      RFSetupReg <= {Data_i[5:4], Data_i[1:0]};
  end


assign  bit_rate_rx = RFSetupReg[1:0];
assign  bit_rate_tx = RFSetupReg[3:2];



//RFCtrlReg
assign  RFCtrlReg_Write = (Addr_i[7:2]==6'h4) && En_i && Write_i;
assign  RFCtrlReg_Read  = (addr_d[7:2]==6'h4) && en_d && ~write_d;
assign  RFCtrlReg_Dout  = RFCtrlReg_Read ? {1'b0, rx, f_e, tx, f_f, arx, acb, err} : 8'h00;


// err - RFCtrlReg[0]
/*
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      err_cpu_d2 <= 2'b0;
    else
//      err_cpu_d2 <= {err_cpu_d2[0], err_rx};
      err_cpu_d2 <= {err_cpu_d2[0], err};
  end

assign  err_cpu = err_cpu_d2[1];
*/
/*
always @ (posedge clk_rx or negedge nrst_err)
begin
  if (~nrst_err)
    err_rx <= 1'b0;
  else
    err_rx <= (crcerr | ferr_wr | egterr | berr);
end
*/
//assign  err = err_rx;
assign  err = crcerr | ferr | egterr | berr;


// acb - RFCtrlReg[1]
//assign  nrst_acb = nReset_i & ~acb_clr;
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      acb <= 1'b0;
    else if (acb_clr)
      acb <= 1'b0;
    else if (RFCtrlReg_Write)
      acb <= Data_i[1];
  end

assign  ACB_RF_o = acb;


// arx - RFCtrlReg[2]
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      arx <= 1'b0;
    else if (RFCtrlReg_Write)
      arx <= Data_i[2];
  end

// f_f - RFCtrlReg[3]
assign  f_f = fifo_full;

// tx - RFCtrlReg[4]
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      tx <= 1'b0;
    else if (RFCtrlReg_Write && ~Data_i[6] && ~((f_e || ferr) && ~txosm && ~tx))
      tx <= Data_i[4];
    else if ((tx_clr && (~arx || (arx && (err || f_e)))) || (rx_clr && arx))
      tx <= 1'b0;
  end

// f_e - RFCtrlReg[5]
/*
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      begin
        fifo_empty_d1 <= 1'b0;
        fifo_empty_d2 <= 1'b0;
      end
    else
      begin
        fifo_empty_d1 <= fifo_empty;
        fifo_empty_d2 <= fifo_empty_d1;
      end
  end
*/
assign  f_e = fifo_empty;
//assign  f_e_cpu = fifo_empty_d2;




// rx - RFCtrlReg[6]
//always @ (posedge Clk_i or negedge nReset_i or posedge rx_set)
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      rx <= 1'b0;
    else if (RFCtrlReg_Write)
      rx <= Data_i[6];
    else if (rx_set_cpu)
      rx <= 1'b1;
    else if (rx_clr)
      rx <= 1'b0;
  end

// rfp - RFCtrlReg[7]
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      rfp <= 1'b0;
    else if (RFCtrlReg_Write)
      rfp <= Data_i[7];
    else
      rfp <= 1'b0;
  end


//RFStateReg -- read only
assign  RFStateReg_Read  = (addr_d[7:2]==6'h5) && en_d && ~write_d;
assign  RFStateReg_Dout  = RFStateReg_Read ? {berr, egterr, ferr, crcerr} : 4'h0;


/*
always @ (posedge clk_rf or posedge rfp)
  begin
    if (rfp)
      rfp_cpu2rf_tmp <= 1'b1;
    else
      rfp_cpu2rf_tmp <= 1'b0;
  end

always @ (posedge clk_rf or negedge nrst_err)
  begin
    if (~nrst_err)
      rfp_cpu2rf_d2 <= 2'b00;
    else
      rfp_cpu2rf_d2 <= {rfp_cpu2rf_d2[0], rfp_cpu2rf_tmp};
  end

assign  rfp_rf = rfp_cpu2rf_d2[1];
*/

//assign  nrst_err = nReset_i & ~(rfp | (rfptx & ((tx & rx_set) | rfptx_rst)) | (rf_state_rx_sof & rst_fp));
assign  nrst_err = nReset_i & ~(rfp | (rfptx & ((tx & rx_set) | rfptx_rst)) | (rf_state_rx_sof & rst_fp));


//crc error
assign  crc_error = (crc_en & rf_state_rx_data & (crc_dout != 16'h0f47));

//always @ (posedge clk_rx or negedge nrst_err)
always @ (posedge clk_fsm or negedge nrst_err)
  begin
    if (~nrst_err)
      crcerr <= 1'b0;
    else if (crc_error && (eof_found || egt_over))
      crcerr <= 1'b1;
  end


//fifo err
/*
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      ferr_cpu_d2 <= 2'b0;
    else
      ferr_cpu_d2 <= {ferr_cpu_d2[0], ferr_wr};
  end
*/
//assign  ferr_cpu = ferr_cpu_d2[1];
assign  ferr = ferr_over | ferr_under;


//egt_timeout
//always @ (posedge clk_rx or negedge nrst_err)
always @ (posedge clk_fsm or negedge nrst_err)
begin
  if (~nrst_err)
    egt_over <= 1'b0;
  else if ((count_etu == 5'h0f) && rf_state_rx_data && rf_din_samp_d)
    egt_over <= 1'b1;
end

assign  egterr =  egt_over ;


// bitend_error
//always @ (posedge clk_rx or negedge nrst_err)
always @ (posedge clk_fsm or negedge nrst_err)
begin
  if (~nrst_err)
    bitend_error <= 1'b0;
  else if ( ~bitend_error && rf_state_rx_data && (count_etu == 5'h8) && (count_fs16 == 4'h7) && (rx_data[8:1]!=8'h00))
    bitend_error <= ~rf_din_samp_d;
end

assign  berr   =  bitend_error ;



/*
always @ (posedge CLK_RF_i or negedge nReset_i)
  begin
    if (~nReset_i)
      nrst_rf_reg_d0 <= 1'b0;
    else
      nrst_rf_reg_d0 <= 1'b1;
  end


always @ (posedge CLK_RF_i or negedge nReset_i)
  begin
    if (~nReset_i)
      nrst_rf_reg <= 2'b00;
    else
      nrst_rf_reg <= {nrst_rf_reg[0], 1'b1};
  end

assign  nrst_rf = nrst_rf_reg[1];
*/

//RFModeReg
assign  RFModeReg_Write = (Addr_i[7:2]==6'h6) && En_i && Write_i;
assign  RFModeReg_Read  = (addr_d[7:2]==6'h6) && en_d && ~write_d;
assign  RFModeReg_Dout  = RFModeReg_Read ? RFModeReg : 8'h00;

always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      RFModeReg <= 8'h00;
    else if (RFModeReg_Write)
      RFModeReg <= Data_i[7:0];
  end

assign  txosm     = RFModeReg[  0];
assign  rxosm     = RFModeReg[  1];
assign  rxosm_tim = RFModeReg[3:2];
assign  txosm_tim = RFModeReg[6:4];
assign  rfptx     = RFModeReg[  7];



//RFFeatureReg
assign  RFFeatureReg_Write = (Addr_i[7:2]==6'h7) && En_i && Write_i;
assign  RFFeatureReg_Read  = (addr_d[7:2]==6'h7) && en_d && ~write_d;
assign  RFFeatureReg_Dout  = RFFeatureReg_Read ? {RFFeatureReg[15:2], 1'b0, RFFeatureReg[0]} : 16'h0000;

always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      RFFeatureReg <= 16'h6200;
    else if (RFFeatureReg_Write)
      RFFeatureReg <= Data_i[15:0];
  end

assign  tb_egt          = RFFeatureReg[    0];
assign  swuptx_tim      = RFFeatureReg[ 3: 2];
assign  trtr1           = RFFeatureReg[ 7: 4];
assign  dis_int_on_err  = RFFeatureReg[    8];
assign  crc_en          = RFFeatureReg[    9];
assign  sof_dis         = RFFeatureReg[   10];
assign  eof_dis         = RFFeatureReg[   11];
assign  acb_auto_close  = RFFeatureReg[   12];
assign  acb_value       = RFFeatureReg[15:13];


assign  ACB_VALUE_RF_o = acb_value;





//**** rx from cpu to rf ****//


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      tx_avail <= 1'b0;
    else if (~rx && ((tx && ~txosm) || (tx && txosm && Idle_Cpu_i)))
      tx_avail <= 1'b1;
    else
      tx_avail <= 1'b0;
  end

//always @ (posedge clk_tx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      begin
        tx_rf_d1 <= 1'b0;
        tx_rf_d2 <= 1'b0;
        tx_rf_d3 <= 1'b0;
      end
    else
      begin
        tx_rf_d1 <= tx_avail;
        tx_rf_d2 <= tx_rf_d1;
        tx_rf_d3 <= tx_rf_d2;
      end
  end

assign  tx_rf = tx_rf_d2;

assign  tx_rf_rise = tx_rf_d2 & ~tx_rf_d3;


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      rx_avail <= 1'b0;
    else if ((rx && ~rxosm) || (rx && rxosm && Idle_Cpu_i))
      rx_avail <= 1'b1;
    else
      rx_avail <= 1'b0;
  end



//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      begin
        rx_rf_d1 <= 1'b0;
        rx_rf_d2 <= 1'b0;
        rx_rf_d3 <= 1'b0;
      end
    else
      begin
        rx_rf_d1 <= rx_avail;
        rx_rf_d2 <= rx_rf_d1;
        rx_rf_d3 <= rx_rf_d2;
      end
  end
  

//assign  rx_rf = rx_rf_d2 | rx_rf_d3;
assign  rx_rf = rx_rf_d2;

assign  rx_rf_rise = rx_rf_d2 & ~rx_rf_d3;





//TIMER Parameter

always @ (txosm or bit_rate_tx or txosm_tim)
  begin
    if(txosm)
      begin
       case ({bit_rate_tx, txosm_tim})
         5'b00_000 : numb_txosm_tim = 9'h0  ;
         5'b00_001 : numb_txosm_tim = 9'h0  ;
         5'b00_010 : numb_txosm_tim = 9'h1  ;
         5'b00_011 : numb_txosm_tim = 9'h3  ;
         5'b00_100 : numb_txosm_tim = 9'h7  ;
         5'b00_101 : numb_txosm_tim = 9'hf  ;
         5'b00_110 : numb_txosm_tim = 9'h1f ;
         5'b00_111 : numb_txosm_tim = 9'h3f ;

         5'b01_000 : numb_txosm_tim = 9'h0  ;
         5'b01_001 : numb_txosm_tim = 9'h1  ;
         5'b01_010 : numb_txosm_tim = 9'h3  ;
         5'b01_011 : numb_txosm_tim = 9'h7  ;
         5'b01_100 : numb_txosm_tim = 9'hf  ;
         5'b01_101 : numb_txosm_tim = 9'h1f ;
         5'b01_110 : numb_txosm_tim = 9'h3f ;
         5'b01_111 : numb_txosm_tim = 9'h7f ;

         5'b10_000 : numb_txosm_tim = 9'h0  ;
         5'b10_001 : numb_txosm_tim = 9'h3  ;
         5'b10_010 : numb_txosm_tim = 9'h7  ;
         5'b10_011 : numb_txosm_tim = 9'hf  ;
         5'b10_100 : numb_txosm_tim = 9'h1f ;
         5'b10_101 : numb_txosm_tim = 9'h3f ;
         5'b10_110 : numb_txosm_tim = 9'h7f ;
         5'b10_111 : numb_txosm_tim = 9'hff ;

         5'b11_000 : numb_txosm_tim = 9'h0  ;
         5'b11_001 : numb_txosm_tim = 9'h7  ;
         5'b11_010 : numb_txosm_tim = 9'hf  ;
         5'b11_011 : numb_txosm_tim = 9'h1f ;
         5'b11_100 : numb_txosm_tim = 9'h3f ;
         5'b11_101 : numb_txosm_tim = 9'h7f ;
         5'b11_110 : numb_txosm_tim = 9'hff ;
         5'b11_111 : numb_txosm_tim = 9'h1ff;

         default   : numb_txosm_tim = 9'h0  ;

       endcase
     end
   else
       numb_txosm_tim = 0;
  end

always @ (bit_rate_tx or trtr1)
  begin
    case ({bit_rate_tx, trtr1})
      6'b00_0000 : numb_trtr1 = 9'h1  ;
      6'b00_0001 : numb_trtr1 = 9'h3  ;
      6'b00_0010 : numb_trtr1 = 9'h5  ;
      6'b00_0011 : numb_trtr1 = 9'h7  ;
      6'b00_0100 : numb_trtr1 = 9'h9  ;
      6'b00_0101 : numb_trtr1 = 9'hb  ;
      6'b00_0110 : numb_trtr1 = 9'hf  ;
      6'b00_0111 : numb_trtr1 = 9'h13 ;
      6'b00_1000 : numb_trtr1 = 9'h18 ;
      6'b00_1001 : numb_trtr1 = 9'h1f ;
      6'b00_1010 : numb_trtr1 = 9'h27 ;
      6'b00_1011 : numb_trtr1 = 9'h31 ;
      6'b00_1100 : numb_trtr1 = 9'h3f ;
      6'b00_1101 : numb_trtr1 = 9'h3f ;
      6'b00_1110 : numb_trtr1 = 9'h3f ;
      6'b00_1111 : numb_trtr1 = 9'h3f ;

      6'b01_0000 : numb_trtr1 = 9'h3  ;
      6'b01_0001 : numb_trtr1 = 9'h7  ;
      6'b01_0010 : numb_trtr1 = 9'hB  ;
      6'b01_0011 : numb_trtr1 = 9'hF  ;
      6'b01_0100 : numb_trtr1 = 9'h13 ;
      6'b01_0101 : numb_trtr1 = 9'h17 ;
      6'b01_0110 : numb_trtr1 = 9'h1F ;
      6'b01_0111 : numb_trtr1 = 9'h27 ;
      6'b01_1000 : numb_trtr1 = 9'h31 ;
      6'b01_1001 : numb_trtr1 = 9'h3F ;
      6'b01_1010 : numb_trtr1 = 9'h4F ;
      6'b01_1011 : numb_trtr1 = 9'h63 ;
      6'b01_1100 : numb_trtr1 = 9'h7F ;
      6'b01_1101 : numb_trtr1 = 9'h7F ;
      6'b01_1110 : numb_trtr1 = 9'h7F ;
      6'b01_1111 : numb_trtr1 = 9'h7F ;

      6'b10_0000 : numb_trtr1 = 9'h7  ;
      6'b10_0001 : numb_trtr1 = 9'hF  ;
      6'b10_0010 : numb_trtr1 = 9'h17 ;
      6'b10_0011 : numb_trtr1 = 9'h1F ;
      6'b10_0100 : numb_trtr1 = 9'h27 ;
      6'b10_0101 : numb_trtr1 = 9'h2F ;
      6'b10_0110 : numb_trtr1 = 9'h3F ;
      6'b10_0111 : numb_trtr1 = 9'h4F ;
      6'b10_1000 : numb_trtr1 = 9'h63 ;
      6'b10_1001 : numb_trtr1 = 9'h7F ;
      6'b10_1010 : numb_trtr1 = 9'h9F ;
      6'b10_1011 : numb_trtr1 = 9'hC7 ;
      6'b10_1100 : numb_trtr1 = 9'hFF ;
      6'b10_1101 : numb_trtr1 = 9'hFF ;
      6'b10_1110 : numb_trtr1 = 9'hFF ;
      6'b10_1111 : numb_trtr1 = 9'hFF ;

      6'b11_0000 : numb_trtr1 = 9'hF  ;
      6'b11_0001 : numb_trtr1 = 9'h1F ;
      6'b11_0010 : numb_trtr1 = 9'h2F ;
      6'b11_0011 : numb_trtr1 = 9'h3F ;
      6'b11_0100 : numb_trtr1 = 9'h4F ;
      6'b11_0101 : numb_trtr1 = 9'h5F ;
      6'b11_0110 : numb_trtr1 = 9'h7F ;
      6'b11_0111 : numb_trtr1 = 9'h9F ;
      6'b11_1000 : numb_trtr1 = 9'hC7 ;
      6'b11_1001 : numb_trtr1 = 9'hFF ;
      6'b11_1010 : numb_trtr1 = 9'h13F;
      6'b11_1011 : numb_trtr1 = 9'h18F;
      6'b11_1100 : numb_trtr1 = 9'h1FF;
      6'b11_1101 : numb_trtr1 = 9'h1FF;
      6'b11_1110 : numb_trtr1 = 9'h1FF;
      6'b11_1111 : numb_trtr1 = 9'h1FF;

      default    : numb_trtr1 = 9'h3f ;

    endcase
  end

always @ (txosm or bit_rate_tx or swuptx_tim)
  begin
    if (txosm)
      begin
        case ({bit_rate_tx, swuptx_tim})
          4'b00_00 : numb_swuptx_tim = 5'h0 ;
          4'b00_01 : numb_swuptx_tim = 5'h0 ;
          4'b00_10 : numb_swuptx_tim = 5'h1 ;
          4'b00_11 : numb_swuptx_tim = 5'h3 ;

          4'b01_00 : numb_swuptx_tim = 5'h0 ;
          4'b01_01 : numb_swuptx_tim = 5'h1 ;
          4'b01_10 : numb_swuptx_tim = 5'h3 ;
          4'b01_11 : numb_swuptx_tim = 5'h7 ;

          4'b10_00 : numb_swuptx_tim = 5'h0 ;
          4'b10_01 : numb_swuptx_tim = 5'h3 ;
          4'b10_10 : numb_swuptx_tim = 5'h7 ;
          4'b10_11 : numb_swuptx_tim = 5'hf ;

          4'b11_00 : numb_swuptx_tim = 5'h0 ;
          4'b11_01 : numb_swuptx_tim = 5'h7 ;
          4'b11_10 : numb_swuptx_tim = 5'hf ;
          4'b11_11 : numb_swuptx_tim = 5'h1f;

          default  : numb_swuptx_tim = 5'h0 ;

        endcase
      end
    else
      numb_swuptx_tim = 0;
  end

always @ (rxosm or bit_rate_rx or rxosm_tim)
  begin
    if (rxosm)
      begin
        case ({bit_rate_rx, rxosm_tim})
          4'b00_00 : numb_rxosm_tim = 7'h0 ;
          4'b00_01 : numb_rxosm_tim = 7'h1 ;
          4'b00_10 : numb_rxosm_tim = 7'h7 ;
          4'b00_11 : numb_rxosm_tim = 7'hf ;

          4'b01_00 : numb_rxosm_tim = 7'h0 ;
          4'b01_01 : numb_rxosm_tim = 7'h3 ;
          4'b01_10 : numb_rxosm_tim = 7'hF ;
          4'b01_11 : numb_rxosm_tim = 7'h1F;

          4'b10_00 : numb_rxosm_tim = 7'h0 ;
          4'b10_01 : numb_rxosm_tim = 7'h7 ;
          4'b10_10 : numb_rxosm_tim = 7'h1F;
          4'b10_11 : numb_rxosm_tim = 7'h3F;

          4'b11_00 : numb_rxosm_tim = 7'h0 ;
          4'b11_01 : numb_rxosm_tim = 7'hF ;
          4'b11_10 : numb_rxosm_tim = 7'h3F;
          4'b11_11 : numb_rxosm_tim = 7'h7F;

          default  : numb_rxosm_tim = 7'h0 ;

        endcase
      end
    else
        numb_rxosm_tim = 0;
  end


//TIMER

assign  timer = {timer_high, count_fs16};

assign  timer_clr = time_td1_over  | time_tr1_over | time_rd1_over | time_sof_over |
                    time_data_over | time_crc_over | time_eof_over | time_td2_over | rf_state_idle;

//assign  time_td1_over  = rf_state_tx_delay1 ? (timer_high == numb_txosm_tim && timer_high_inc) : 1'b0;       //tx_delay1
//assign  time_tr1_over  = rf_state_tx_tr1    ? ( timer_high == numb_trtr1 && timer_high_inc) : 1'b0;          //tx_tr1
//assign  time_td2_over  = rf_state_tx_delay2 ? ((arx && ~acb_auto_close) ? 1'b1 : ((timer_high >= numb_swuptx_tim && timer_high_inc) || (swuptx_tim==0))) : 1'b0;     //tx_delay2
//assign  time_rd1_over  = rf_state_rx_delay1 ? (timer_high == numb_rxosm_tim  && timer_high_inc) : 1'b0;      //rx_delay1
//assign  time_data_over = tb_egt ? (rf_state_tx_data & (timer_high[3:0] == 4'hb ) & timer_high_inc)
//                                : (rf_state_tx_data & (timer_high[3:0] == 4'h9 ) & timer_high_inc);
//assign  time_crc_over  = tb_egt ? (rf_state_tx_crc && (timer_high[5:0] == 6'h23) & timer_high_inc)
//                                : (rf_state_tx_crc && (timer_high[5:0] == 6'h1d) & timer_high_inc);

assign  time_td1_over  = rf_state_tx_delay1 & timer_high_inc & (timer_high == numb_txosm_tim) ;       //tx_delay1
assign  time_tr1_over  = rf_state_tx_tr1    & timer_high_inc & (timer_high == numb_trtr1    ) ;       //tx_tr1
assign  time_td2_over  = rf_state_tx_delay2 & ((arx & ~acb_auto_close) | ((timer_high >= numb_swuptx_tim & timer_high_inc) | (swuptx_tim == 0)));     //tx_delay2
assign  time_rd1_over  = rf_state_rx_delay1 & timer_high_inc & (timer_high == numb_rxosm_tim) ;       //rx_delay1
assign  time_sof_over  = rf_state_tx_sof    & timer_high_inc & (timer_high[3:0] == 4'hb     ) ;
assign  time_eof_over  = rf_state_tx_eof    & timer_high_inc & (timer_high[4:0] == 5'h0b    ) ;
assign  time_data_over = rf_state_tx_data   & timer_high_inc & ((tb_egt & timer_high[3:0]==6'hb ) | (~tb_egt & timer_high[3:0]==4'h9 ));
assign  time_crc_over  = rf_state_tx_crc    & timer_high_inc & ((tb_egt & timer_high[5:0]==6'h23) | (~tb_egt & timer_high[5:0]==6'h1d));


//always @ (posedge clk_tx or posedge rst_rd)
always @ (posedge clk_fsm or posedge fifo_rst)
  begin
    if (fifo_rst)
      begin
        fifo_empty_tx_d1 <= 1'b0;
        //fifo_empty_tx_d2 <= 1'b0;
      end
    else
      begin
        fifo_empty_tx_d1 <= fifo_empty;
        //fifo_empty_tx_d2 <= fifo_empty_tx_d1;
      end
  end

//assign  tx_data_end    = time_data_over & ((crc_en & f_e) | (~crc_en & f_e_d1));
assign  tx_data_end    = time_data_over & ((crc_en & fifo_empty) | (~crc_en & fifo_empty_tx_d1));


//assign  rf_fifo_sof_dis  = rf_state_tx_tr1 ? ( timer_high == (numb_trtr1 - 1) && timer_high_inc) : 1'b0;          //tx_tr1
assign  rf_fifo_sof_dis  = rf_state_tx_tr1 & ( timer_high == (numb_trtr1 - 1) && timer_high_inc);          //tx_tr1

assign  rf_fifo_read = tb_egt ? (rf_fifo_sof_dis && sof_dis) || ((rf_state_tx_sof || rf_state_tx_data) && (timer_high[3:0]==4'hb) && rf_fifo_read_en)
                              : (rf_fifo_sof_dis && sof_dis) || (((rf_state_tx_sof && (timer_high[3:0]==4'hb)) || (rf_state_tx_data && (timer_high[3:0]==4'h9))) && rf_fifo_read_en);

assign  tx_crc_en = tb_egt ? (time_tr1_over && sof_dis) || ((rf_state_tx_sof || rf_state_tx_data) && (timer_high[3:0]==4'hb) && timer_high_inc)
                           : (time_tr1_over && sof_dis) || (((rf_state_tx_sof && (timer_high[3:0]==4'hb)) || (rf_state_tx_data && (timer_high[3:0]==4'h9))) && timer_high_inc);


//assign  read_crc1 = tb_egt ? (rf_state_tx_crc && (timer_high[4:0]==5'h0b) && timer_high_inc)
//                           : (rf_state_tx_crc && (timer_high[4:0]==5'h09) && timer_high_inc);
//assign  read_crc2 = tb_egt ? (rf_state_tx_crc && (timer_high[4:0]==5'h17) && timer_high_inc)
//                           : (rf_state_tx_crc && (timer_high[4:0]==5'h13) && timer_high_inc);
assign  read_crc1 = rf_state_tx_crc & timer_high_inc & ((tb_egt & timer_high[4:0]==5'h0b) | (~tb_egt & timer_high[4:0]==5'h09));
assign  read_crc2 = rf_state_tx_crc & timer_high_inc & ((tb_egt & timer_high[4:0]==5'h17) | (~tb_egt & timer_high[4:0]==5'h13));



//timer_inc
assign  timer_inc = rf_state_tx_delay1 | rf_state_tx_tr1  | rf_state_tx_delay2 | rf_state_rx_delay1 |
                    rf_state_tx_sof    | rf_state_tx_data | rf_state_tx_crc    | rf_state_tx_eof;

//timer_high_inc
always @ (rx_rf or rf_state_rx_delay1 or tx_rf or count_fs16 or bit_rate_tx)
  begin
    if (rx_rf || rf_state_rx_delay1)
        timer_high_inc = (count_fs16[3:0]==4'hf);
    else if (tx_rf)
      begin
        case (bit_rate_tx)
          2'b00   : timer_high_inc = (count_fs16[3:0]==4'hf);
          2'b01   : timer_high_inc = (count_fs16[2:0]==3'h7);
          2'b10   : timer_high_inc = (count_fs16[1:0]==2'h3);
          2'b11   : timer_high_inc = (count_fs16[  0]==1'h1);
          default : timer_high_inc = (count_fs16[3:0]==4'hf);
        endcase
      end
    else
        timer_high_inc = 1'b0;
  end


//always @ (tx_rf or f_e or count_fs16 or bit_rate_tx)
always @ (rx_rf or tx_rf or fifo_empty or count_fs16 or bit_rate_tx)
  begin
//    if (tx_rf && ~f_e)
    if (~rx_rf && tx_rf && ~fifo_empty)
      begin
        case (bit_rate_tx)
          2'b00   : rf_fifo_read_en = (count_fs16[3:0]==4'he);
          2'b01   : rf_fifo_read_en = (count_fs16[2:0]==3'h6);
          2'b10   : rf_fifo_read_en = (count_fs16[1:0]==2'h2);
          2'b11   : rf_fifo_read_en = (count_fs16[  0]==1'h0);
          default : rf_fifo_read_en = (count_fs16[3:0]==4'he);
        endcase
      end
    else
        rf_fifo_read_en = 1'b0;
  end



//assign  nrst_timer_high = nrst_rf_state;

//always @ (posedge clk_fsm or negedge nrst_timer_high)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      timer_high <= 10'h000;
    else if (timer_clr || eof_found)
      timer_high <= 10'h000;
    else if (timer_high_inc)
      timer_high <= timer_high + 1;
  end


//======================
//         FSM
//======================
parameter  IDLE       = 4'b0000 ;    // 0
parameter  TX_DELAY1  = 4'b0001 ;    // 1
parameter  TX_TR1     = 4'b0010 ;    // 2
parameter  TX_SOF     = 4'b0011 ;    // 3
parameter  TX_DATA    = 4'b0100 ;    // 4
parameter  TX_CRC     = 4'b0101 ;    // 5
parameter  TX_EOF     = 4'b0110 ;    // 6
parameter  TX_DELAY2  = 4'b0111 ;    // 7
parameter  RX_DELAY1  = 4'b1000 ;    // 8
parameter  RX_SOF     = 4'b1001 ;    // 9
parameter  RX_DATA    = 4'b1010 ;    // a
parameter  SEND_INT   = 4'b1011 ;    // b



//assign  tx_en  = tx_rf && ((txosm && idle_cpu_rf) || ~txosm);
//assign  rx_en  = rx_rf && ~(eof_found || egt_over) && ((rxosm && idle_cpu_rf) || ~rxosm);
//assign  tx_en  = tx_rf ;
//assign  rx_en  = rx_rf && ~(eof_found || egt_over) ;


always @ ( * )
  begin
    case(CurRFState)
      IDLE    : begin
//                  if ((tx_rf_rise && (fifo_empty || ferr) && ~int_tx_rf_clr) ||        //go to TX mode  //at sleep model, if fifo error then send INT
//                      (rx_rf_rise && ~(eof_found || egt_over) && ferr && ~int_rx_rf_clr))     //go to RX mode  //at sleep model, if fifo error then send INT
                  if ((tx_rf_rise && (fifo_empty || ferr)) ||        //go to TX mode  //at sleep model, if fifo error then send INT
                      (rx_rf_rise && ~(eof_found || egt_over) && ferr))     //go to RX mode  //at sleep model, if fifo error then send INT
                      NxtRFState = SEND_INT;
 //                 else if (rx_rf && ~(eof_found || egt_over) && ((rxosm && idle_cpu_rf && rxosm_tim==0) || ~rxosm))  //go to Rx mode
                  else if (rx_rf_rise && ~(eof_found || egt_over) && ((rxosm_tim==0) || ~rxosm))  //go to Rx mode
                      NxtRFState = RX_SOF;                                                //at query model or rxosm_tim=0, goto RX_SOF
                  else if (rx_rf_rise && ~(eof_found || egt_over) )      //or goto rx_delay1
                      NxtRFState = RX_DELAY1;
//                  else if (~rx_rf && tx_rf && ((txosm && idle_cpu_rf && txosm_tim==0) || ~txosm) && ~int_tx_rf_clr)   //at query model or txosm_tim=0, goto TX_TR1
                  else if (tx_rf_rise && ((txosm_tim==0) || ~txosm) && ~int_tx_rf_clr)   //at query model or txosm_tim=0, goto TX_TR1
                      NxtRFState = TX_TR1;
                  else if (tx_rf_rise && ~int_tx_rf_clr)     //or goto tx_delay1
                      NxtRFState = TX_DELAY1;
                  else
                      NxtRFState = IDLE;
                end
    TX_DELAY1 : begin                   //satisfying  TXOSM_TIM
                  if (time_td1_over)
                      NxtRFState = TX_TR1;
                  else if (~tx_rf)
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_DELAY1;
                end
    TX_TR1    : begin
                  if (time_tr1_over)
                     begin
                       if ( fifo_empty && sof_dis && crc_en )
                           NxtRFState = TX_CRC;
//                       else if ((fifo_empty && sof_dis) || sof_dis)
                       else if ( sof_dis )
                           NxtRFState = TX_DATA;
                       else
                           NxtRFState = TX_SOF;
                     end
                  else if (~tx_rf)
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_TR1;
                end
    TX_SOF    : begin
                  if ( time_sof_over )
                    begin
                      if ( fifo_empty && crc_en )
                          NxtRFState = TX_CRC;
                      else
                          NxtRFState = TX_DATA;
                    end
                  else if ( ~tx_rf )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_SOF;
                end
    TX_DATA   : begin
                  if ( tx_data_end )
                    begin
                      if ( crc_en )
                          NxtRFState = TX_CRC;
                      else if ( ~eof_dis )
                          NxtRFState = TX_EOF;
                      else
                          NxtRFState = TX_DELAY2;
                    end
                  else if ( ferr )
                      NxtRFState = SEND_INT;
                  else if ( ~tx_rf )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_DATA;
                end
    TX_CRC    : begin
                  if ( time_crc_over )
                    begin
                      if ( ~eof_dis )
                          NxtRFState = TX_EOF;
                      else
                          NxtRFState = TX_DELAY2;
                    end
                  else if ( ~tx_rf )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_CRC;
                end
    TX_EOF    : begin
                  if ( time_eof_over )
                      NxtRFState = TX_DELAY2;
                  else if ( ~tx_rf )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = TX_EOF;
                end
    TX_DELAY2 : begin
                  if ( tx_rf && arx && time_td2_over )
                    begin
                      if ( rxosm_tim==0 )
                        NxtRFState = RX_SOF;
                      else
                        NxtRFState = RX_DELAY1;
                    end
                  else if ( ~tx_rf )
                      NxtRFState = IDLE;
                  else if ((~arx && time_td2_over) || ~txosm)
                      NxtRFState = SEND_INT;
                  else
                      NxtRFState = TX_DELAY2;
                end
    RX_DELAY1 : begin
                  if ( time_rd1_over )
                      NxtRFState = RX_SOF;
                  else if ( ~rx_rf && ~(arx && tx_rf) )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = RX_DELAY1;
                end
    RX_SOF    : begin
                  if ( rx_rf && sof_found && rst_fp )
                      NxtRFState = RX_DATA;
                  else if ( ~rx_rf && ~(arx && tx_rf) )
                      NxtRFState = IDLE;
                  else
                      NxtRFState = RX_SOF;
                end
    RX_DATA   : begin
                  if ( ~rx_rf )
                      NxtRFState = IDLE;
                  else if ((eof_found || egt_over) && (~dis_int_on_err || (dis_int_on_err && ~(crcerr || crc_error || ferr))))
                      NxtRFState = SEND_INT;
                  else if ( (dis_int_on_err && (eof_found || egt_over) && (crcerr || crc_error || ferr)) || sof_over_time )
                      NxtRFState = RX_SOF;
                  else
                      NxtRFState = RX_DATA;
                end
    SEND_INT  : begin
                  if (~(rx_rf || tx_rf)  || int_tx_rf_clr || int_rx_rf_clr)
                      NxtRFState = IDLE;
                  else
                      NxtRFState = SEND_INT;
                end
    default   : begin
                      NxtRFState = IDLE;
                end
    endcase
  end


/*
assign  clk_fsm = rx_rf ? clk_rx : (tx_rf ? clk_tx : 1'b0);
//assign  clk_fsm = rx_rf ? clk_rx : (tx_rf ? clk_tx : 1'b1);
//assign  clk_fsm = (~rx_rf | clk_rx) & ( ~(~rx_rf & tx_rf) | clk_tx);
*/


ClkMux2  u_ClkMux2_clk_fsm_sel(
  .nReset_i  ( nrst_rf           ),
  .Sel_i     ( rx_rf             ),
  .Clkin1_i  ( clk_rx            ),
  .Clkin2_i  ( clk_tx            ),
  .Clkout_o  ( clk_fsm           )
  );



//assign  nrst_rf_state = (rx_rf | tx_rf);
//assign  nrst_rf_state = (rx | tx);

//always @ (posedge clk_fsm or negedge nrst_rf_state)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
      if (~nReset_i)
        CurRFState <= IDLE;
//      else if (~(rx_rf || tx_rf))
//        CurRFState <= IDLE;
      else
        CurRFState <= NxtRFState;
  end



assign  rf_state_idle      = ( CurRFState == IDLE      );
assign  rf_state_tx_delay1 = ( CurRFState == TX_DELAY1 );
assign  rf_state_tx_tr1    = ( CurRFState == TX_TR1    );
assign  rf_state_tx_sof    = ( CurRFState == TX_SOF    );
assign  rf_state_tx_data   = ( CurRFState == TX_DATA   );
assign  rf_state_tx_crc    = ( CurRFState == TX_CRC    );
assign  rf_state_tx_eof    = ( CurRFState == TX_EOF    );
assign  rf_state_tx_delay2 = ( CurRFState == TX_DELAY2 );
assign  rf_state_rx_delay1 = ( CurRFState == RX_DELAY1 );
assign  rf_state_rx_sof    = ( CurRFState == RX_SOF    );
assign  rf_state_rx_data   = ( CurRFState == RX_DATA   );
assign  rf_state_send_int  = ( CurRFState == SEND_INT  );



//assign  int_tx_rf_set = time_td2_over;// | (rf_state_idle & f_e & tx_rf & txosm);
assign  int_rx_rf_set = ((eof_found | egt_over) & ( ~dis_int_on_err | (dis_int_on_err & ~(crcerr | crc_error | ferr)))) |
                        ( tx_rf & (fifo_empty | ferr)) |
                        ( rx_rf & ~(eof_found | egt_over) & txosm & ferr & rf_state_send_int);
//                        (~rx_rf & tx_rf & (fifo_empty | ferr_rd)) |
//                        ( rx_en & txosm & ferr_wr  & rf_state_send_int);


//assign   tx_clr = ~int_tx_rf2cpu[0] & int_tx_rf2cpu[1];
//assign   tx_clr = ~int_tx_rf2cpu[1] & int_tx_rf2cpu[2];
assign   tx_cpu_rise =  int_tx_rf2cpu[1] & ~int_tx_rf2cpu[2];
assign   tx_cpu_fall = ~int_tx_rf2cpu[1] &  int_tx_rf2cpu[2];
assign   tx_clr      = tx_cpu_rise;

//assign   rx_clr = ~int_rx_rf2cpu[0] & int_rx_rf2cpu[1];
//assign   rx_clr = ~int_rx_rf2cpu[1] & int_rx_rf2cpu[2];
assign   rx_cpu_rise =  int_rx_rf2cpu[1] & ~int_rx_rf2cpu[2];
assign   rx_cpu_fall = ~int_rx_rf2cpu[1] &  int_rx_rf2cpu[2];
assign   rx_clr      = rx_cpu_rise;



//always @ (posedge clk_tx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      rx_set <= 1'b0;
    else
      rx_set <= arx && time_td2_over;
  end

//always @ (posedge Clk_i or negedge nReset_i or posedge rx_set)
always @ (posedge Clk_i or posedge rx_set)
  begin
    if (rx_set)
      rx_set_rf2cpu_tmp <= 1'b1;
    else
      rx_set_rf2cpu_tmp <= 1'b0;
  end

always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      rx_set_rf2cpu_d2 <= 2'b00;
//    else if (arx)
    else
      rx_set_rf2cpu_d2 <= {rx_set_rf2cpu_d2[0], rx_set_rf2cpu_tmp} ;
  end


assign  rx_set_cpu = rx_set_rf2cpu_d2[1];


assign  acb_clr = rx_set_cpu & acb_auto_close;


/*
always @ (posedge clk_fsm or negedge nrst_rf)
  begin
    if (~nrst_rf)
      idle_cpu_rf_d2 <= 2'b00;
    else
      idle_cpu_rf_d2 <= {idle_cpu_rf_d2[0], Idle_Cpu_i};
  end

assign  idle_cpu_rf = idle_cpu_rf_d2[1];
*/



assign  int_tx_rf_clr = int_tx_cpu2rf[1];
assign  int_rx_rf_clr = int_rx_cpu2rf[1];


//int_tx_rf signal
//always @ (posedge clk_tx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      int_tx_rf <= 1'b0;
    else if (int_tx_rf_clr)
      int_tx_rf <= 1'b0;
    else if (rf_state_send_int && tx_rf && ~rx_rf)    //tx  finished
      int_tx_rf <= 1'b1;
  end

//int_rx_rf signal
//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      int_rx_rf <= 1'b0;
    else if (int_rx_rf_clr)
      int_rx_rf <= 1'b0;
    else if (rf_state_send_int && rx_rf)    //rx  finished
      int_rx_rf <= 1'b1;
  end


assign  int_rf = int_tx_rf || int_rx_rf;



//int_rf_tmp signal
//wire    nrst_int_tx_rf;
//assign  nrst_int_tx_rf = nrst_rf && tx_rf;

//always @ (posedge clk_tx or negedge nrst_int_tx_rf)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      int_tx_cpu2rf <= 2'b00;
    else
      int_tx_cpu2rf <= {int_tx_cpu2rf[0], int_tx_rf2cpu[1]};
  end

//assign  int_rx_rf_nrst = nrst_rf && rx_rf;

//always @ (posedge clk_rx or negedge int_rx_rf_nrst)
always @ (posedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      int_rx_cpu2rf <= 2'b00;
    else
      //int_rx_cpu2rf <= {int_rx_cpu2rf[0], int_rx_cpu};
      int_rx_cpu2rf <= {int_rx_cpu2rf[0], int_rx_rf2cpu[1]};
  end



//Int_o signal
always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      int_tx_rf2cpu <= 3'b000;
    else
      int_tx_rf2cpu <= {int_tx_rf2cpu[1:0], int_tx_rf};
  end


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      int_rx_rf2cpu <= 3'b00;
    else
      int_rx_rf2cpu <= {int_rx_rf2cpu[1:0], int_rx_rf};
  end


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      int_tx_cpu <= 1'b0;
//    else if (int_tx_rf2cpu[1] && ~int_tx_rf2cpu[2])
    else if (tx_cpu_rise)
      int_tx_cpu <= 1'b1;
//    else if (~int_tx_rf2cpu[1] && int_tx_rf2cpu[2])
    else
      int_tx_cpu <= 1'b0;
  end


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      int_rx_cpu <= 1'b0;
//    else if (int_rx_rf2cpu[1] && ~int_rx_rf2cpu[2])
    else if (rx_cpu_rise)
      int_rx_cpu <= 1'b1;
//    else if (~int_rx_rf2cpu[1] && int_rx_rf2cpu[2])
    else
      int_rx_cpu <= 1'b0;
  end


assign  int_cpu = (int_tx_cpu & (~arx | (arx & (err | f_e)))) | int_rx_cpu;

always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      int_cpu_d <= 1'b0;
    else
      int_cpu_d <= int_cpu;
  end


always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      Int_o <= 1'b0;
    else if (RFCtrlReg_Write && ((~Data_i[6] && rx) || (~Data_i[4] && tx)))   //CPU cancel RX/TX
      Int_o <= 1'b1;
    else if (~int_cpu && int_cpu_d )
      Int_o <= 1'b1;
    else
      Int_o <= 1'b0;
  end



always @ (posedge Clk_i or negedge nReset_i)
  begin
    if (~nReset_i)
      rfptx_rst <= 1'b0;
    else if (RFCtrlReg_Write && ~Data_i[4] && tx)   //CPU cancel TX
      rfptx_rst <= 1'b1;
    else
      rfptx_rst <= 1'b0;
  end


/*
assign  nrst_acb = nReset_i & ~acb_clr;

always @ (posedge Clk_i or negedge nrst_acb)
  begin
    if (~nrst_acb)
      acb_clr_rf2cpu <= 2'b00;
    else
      acb_clr_rf2cpu <= {acb_clr_rf2cpu[0], 1'b1};
  end

assign  acb_clr_cpu = acb_clr_rf2cpu[1];
*/


// ******  decoder module ******

//assign  data_rst = ~nReset_i | fall_din_samp;
//assign  data_set = rise_din_samp;


// clock dividor part


/*
`ifdef  RTL_FPGA
  assign rf_clk = CLK_RF_i;                                //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
`else
  //assign rf_clk = (tx_rf | rx_rf) ? CLK_RF_i : 1'b1;      //rtl source
  assign rf_clk = (tx_rf | rx_rf) ? CLK_RF_i : 1'b0;      //rtl source
`endif


// demodular
//bit_rate_rx --  2'b00: 106k;  2'b01: 212k;  2'b10: 424k;  2'b11: 848k
//bit_rate_tx --  2'b00: 106k;  2'b01: 212k;  2'b10: 424k;  2'b11: 848k

always @ (rx_rf or eof_found or bit_rate_rx or rf_clk or clk_6m78 or clk_3m39 or clk_1m7 )
begin
  if (rx_rf || eof_found)
    begin
      case (bit_rate_rx)
        2'b00:  clk_rx = clk_1m7;
        2'b01:  clk_rx = clk_3m39;
        2'b10:  clk_rx = clk_6m78;
        2'b11:  clk_rx = rf_clk;
      endcase
    end
  else
    begin
      `ifdef  RTL_FPGA
        clk_rx = rf_clk;        //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
      `else
        //clk_rx <= 1'b1;          //rtl source
        clk_rx = 1'b0;          //rtl source
      `endif
    end
end


`ifdef  RTL_FPGA
  assign  clk_tx = clk_1m7;                       //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
`else
  //assign  clk_tx = tx_rf ? clk_1m7 : 1'b1;        //rtl source
  assign  clk_tx = tx_rf ? clk_1m7 : 1'b0;        //rtl source
`endif


always @ (posedge rf_clk or negedge nReset_i)
begin
  if (~nReset_i)
    clk_6m78 <= 1'b1;
  `ifdef  RTL_FPGA
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_6m78 <= ~clk_6m78;
  `else
  else if (tx_rf || rx_rf)    //rtl source
    clk_6m78 <= ~clk_6m78;
  `endif
end

always @ (posedge clk_6m78 or negedge nReset_i)
begin
  if (~nReset_i)
    clk_3m39 <= 1'b1;
  `ifdef  RTL_FPGA
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_3m39 <= ~clk_3m39;
  `else
  else if (tx_rf || rx_rf)    //rtl source
    clk_3m39 <= ~clk_3m39;
  `endif
end

always @ (posedge clk_3m39 or negedge nReset_i)
begin
  if (~nReset_i)
    clk_1m7 <= 1'b0;
  `ifdef  RTL_FPGA
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_1m7 <= ~clk_1m7;
  `else
  else if (tx_rf || rx_rf)    //rtl source
    clk_1m7 <= ~clk_1m7;
  `endif
end
*/

// demodular
//bit_rate_rx --  2'b00: 106k;  2'b01: 212k;  2'b10: 424k;  2'b11: 848k
//bit_rate_tx --  2'b00: 106k;  2'b01: 212k;  2'b10: 424k;  2'b11: 848k

//assign  clk_rf = CLK_RF_i;
/*
always @ (rx_rf or eof_found or bit_rate_rx or clk_rf or clk_6m78 or clk_3m39 or clk_1m7 )
begin
  if (rx_rf || eof_found)
    begin
      case (bit_rate_rx)
        2'b00:  clk_rx = clk_1m7;
        2'b01:  clk_rx = clk_3m39;
        2'b10:  clk_rx = clk_6m78;
        2'b11:  clk_rx = clk_rf;
      endcase
    end
  else
      clk_rx = clk_rf;        //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
end
*/

//assign  clk_rx_sel_div1 =  ((rx_rf | eof_found) & (bit_rate_rx==2'b11)) | ~(rx_rf | eof_found) ;
//assign  clk_rx_sel_div2 =   (rx_rf | eof_found) & (bit_rate_rx==2'b10);
//assign  clk_rx_sel_div4 =   (rx_rf | eof_found) & (bit_rate_rx==2'b01);
//assign  clk_rx_sel_div8 =   (rx_rf | eof_found) & (bit_rate_rx==2'b00);

assign  clk_rx_sel_0 =  (bit_rate_rx[0]==1'b1);
assign  clk_rx_sel_1 =  (bit_rate_rx[0]==1'b1);
assign  clk_rx_sel_2 =  (bit_rate_rx[1]==1'b1);

//assign  clk_rx_out0 =  clk_rx_sel_0 ? clk_3m39    : clk_1m7    ;
//assign  clk_rx_out1 =  clk_rx_sel_1 ? clk_rf      : clk_6m78   ;
//assign  clk_rx      =  clk_rx_sel_2 ? clk_rx_out1 : clk_rx_out0;

ClkMux2  u_ClkMux2_clk_rx_sel_0(
  .nReset_i  ( nReset_i          ),
  .Sel_i     ( clk_rx_sel_0      ),
  .Clkin1_i  ( clk_3m39          ),
  .Clkin2_i  ( clk_1m7           ),
  .Clkout_o  ( clk_rx_out0       )
  );

ClkMux2  u_ClkMux2_clk_rx_sel_1(
  .nReset_i  ( nReset_i          ),
  .Sel_i     ( clk_rx_sel_1      ),
  .Clkin1_i  ( CLK_RF_i          ),
  .Clkin2_i  ( clk_6m78          ),
  .Clkout_o  ( clk_rx_out1       )
  );

ClkMux2  u_ClkMux2_clk_rx_sel_2(
  .nReset_i  ( nReset_i          ),
  .Sel_i     ( clk_rx_sel_2      ),
  .Clkin1_i  ( clk_rx_out1       ),
  .Clkin2_i  ( clk_rx_out0       ),
  .Clkout_o  ( clk_rx            )
  );



  assign  clk_tx = clk_1m7;                       //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
/*
`ifdef  RTL_FPGA
  assign  clk_tx = clk_1m7;                       //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
`else
  //assign  clk_tx = tx_rf ? clk_1m7 : 1'b1;        //rtl source
  assign  clk_tx = tx_rf ? clk_1m7 : 1'b0;        //rtl source
`endif
*/

//always @ (posedge clk_rf or negedge nReset_i)
always @ (posedge CLK_RF_i or negedge nReset_i)
begin
  if (~nReset_i)
    clk_6m78 <= 1'b1;
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_6m78 <= ~clk_6m78;
end

//always @ (posedge clk_6m78 or negedge nReset_i)
always @ (posedge clk_6m78 or negedge nReset_i)
begin
  if (~nReset_i)
    clk_3m39 <= 1'b1;
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_3m39 <= ~clk_3m39;
end

//always @ (posedge clk_3m39 or negedge nReset_i)
always @ (posedge clk_3m39 or negedge nReset_i)
begin
  if (~nReset_i)
    clk_1m7 <= 1'b0;
  else                          //fix clkmux bug when fpga synthsis by heyuming @ 2008.01.29
    clk_1m7 <= ~clk_1m7;
end



//always @ (posedge clk_tx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    clk_848k <= 1'b0;
//  else if (time_td1_over || (rf_state_idle && ~rx_rf && tx_rf && ((txosm && idle_cpu_rf && txosm_tim==0) || ~txosm) && ~int_tx_rf_clr))
  else if (time_td1_over || (rf_state_idle && ~rx_rf && tx_rf && ((txosm_tim==0) || ~txosm) && ~int_tx_rf_clr))
    clk_848k <= 1'b1;
  else if (out_en)
    clk_848k <= ~clk_848k;
  else
    clk_848k <= 1'b0;
end


//always @ (negedge clk_tx or negedge nrst_rf)
always @ (negedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    clk_848k_2 <= 1'b0;
  else if (~out_en)
    clk_848k_2 <= 1'b0;
  else
    clk_848k_2 <= clk_848k;
end


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    fifo_wr_rf <= 1'b0;
  else if (rf_state_rx_data && (count_etu == 8) && (count_fs16==4'h7) && ~((rx_data[8:0]==9'h000) && ~rf_din_samp_d))
    fifo_wr_rf <= 1'b1;
  else
    fifo_wr_rf <= 1'b0;
end

/*
assign  pause_rst = ~nrst_rf | ~DIN_RF_i;

always @ (posedge clk_rx or posedge pause_rst)
begin
  if (pause_rst )
    timeout <= 1'b0;
  else if (!rf_in_en && rf_din_samp)
    timeout <= 1'b1;
end
*/

//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i )
    rf_din_samp_0 <= 1'b1;
  else
    rf_din_samp_0 <= DIN_RF_i;
end


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i )
    rf_din_samp_1 <= 1'b1;
  else
    rf_din_samp_1 <= rf_din_samp_0;
end


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    rf_din_samp <= 1'b1;
  else
    rf_din_samp <= rf_din_samp_1;
end


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    rf_din_samp_d <= 1'b1;
  else if (rx_rf && (rf_din_samp == rf_din_samp_1))
    rf_din_samp_d <= rf_din_samp;
end


//assign  rise_din_samp = ~rf_din_samp_d &  rf_din_samp;
assign  fall_din_samp =  rf_din_samp_d & ~rf_din_samp;

assign  rst_fp = fp & fall_din_samp;


//always @ (posedge clk_fsm or negedge nrst_timer_high)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    count_fs16 <= 4'h0;
  else if (rst_fp || sof_err_found || eof_found || timer_clr)
    count_fs16 <= 4'h0;
  else if (rf_in_en || timer_inc)
    count_fs16 <= count_fs16 + 1;
end


//assign  clk_etu = ~count_fs16[3];


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    count_etu <= 5'h1f;
  else if (rst_fp || sof_err_found || eof_found)
    count_etu <= 5'h1f;
  else if (count_etu == 5'h0f)
    count_etu <= 5'h0f;
  else if (rf_in_en && count_fs16==4'hf)
    count_etu <= count_etu + 1;
end



// fp -- first pause
//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    fp <= 1'b1;
  else if (sof_found || sof_err_found)
    fp <= 1'b1;
  else if (count_etu >= 5'h8)
    fp <= 1'b1;
  else
    fp <= 1'b0;
end



// data decode

//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    rx_data <= 13'h000;
//  else if (rst_fp || int_rx_rf_set || sof_over_time || (eof_found && ((~dis_int_on_err && err_rx) || (dis_int_on_err && (crcerr || crc_error || ferr_wr)))))
  else if (rst_fp || int_rx_rf_set || sof_over_time || eof_found || ~rx_rf)
    rx_data <= 13'h000;
  else if (count_fs16 == 4'h7)
    begin
      case (count_etu)
      5'h1f  : rx_data[ 0] <= rf_din_samp_d;
      5'h00  : rx_data[ 1] <= rf_din_samp_d;
      5'h01  : rx_data[ 2] <= rf_din_samp_d;
      5'h02  : rx_data[ 3] <= rf_din_samp_d;
      5'h03  : rx_data[ 4] <= rf_din_samp_d;
      5'h04  : rx_data[ 5] <= rf_din_samp_d;
      5'h05  : rx_data[ 6] <= rf_din_samp_d;
      5'h06  : rx_data[ 7] <= rf_din_samp_d;
      5'h07  : rx_data[ 8] <= rf_din_samp_d;
      5'h08  : rx_data[ 9] <= rf_din_samp_d;
      5'h09  : rx_data[10] <= rf_din_samp_d;
      5'h0a  : rx_data[11] <= rf_din_samp_d;
      5'h0b  : rx_data[12] <= rf_din_samp_d;
      default: rx_data     <= rx_data;
     endcase
   end
end

assign  rf_decode_dout  = rx_data[8:1];

assign  rf_decode_dout_bit = rf_din_samp_d;


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    rf_in_en <= 1'b0;
  else if ( rf_state_rx_sof && rst_fp)
    rf_in_en <= 1'b1;
  else if ( sof_err_found || egt_over || int_rx_rf_clr || ((count_etu == 5'h1f) && (count_fs16 == 4'h7) && rf_din_samp_d))
    rf_in_en <= 1'b0;
end

/*
always @ (posedge clk_rx or negedge nrst_rf)
begin
  if (~nrst_rf)
    in_en_delay <= 1'b0;
  else
    in_en_delay <= rf_in_en;
end
*/


// detect sof
//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    sof_found <= 1'b0;
  else if (rst_fp || sof_over_time)
    sof_found <= 1'b0;
  else if (rf_state_rx_sof && ~eof_found && (rx_data[9:0]==10'h000) && (((rx_data[12:10]==3'b110)&&(count_etu >= 5'hb)) || ((rx_data[11:10]==2'b11)&&(count_etu >= 5'ha))))
    sof_found <= 1'b1;
end

assign  sof_over_time = sof_found && (((rx_data[12:10]==3'b110)&&(count_etu > 5'hc)) || ((rx_data[11:10]==2'b11)&&(count_etu > 5'hb)));

assign  sof_err_found = rf_state_rx_sof & (count_etu < 8) & rf_din_samp_d;


//always @ (posedge clk_rx or negedge nrst_rf)
always @ (posedge clk_fsm or negedge nReset_i)
begin
  if (~nReset_i)
    eof_found <= 1'b0;
  else if (rst_fp || int_rx_rf_clr || (eof_found && ((~dis_int_on_err && err) || (dis_int_on_err && (crcerr || crc_error || ferr)))))
    eof_found <= 1'b0;
  else if ( rf_state_rx_data && (rx_data[9:0]==10'h000) && (((rx_data[11:10]==2'b10)||(rx_data[11:10]==2'b11))&&(count_etu == 5'ha)) )
    eof_found <= 1'b1;
end



// *****************************
// ******  encoder module ******
// *****************************

//assign  nrst_tx_dout = nrst_rf & tx_rf;

//always @ (negedge clk_tx or negedge nrst_tx_dout)
//always @ (negedge clk_tx or negedge nrst_rf)
always @ (negedge clk_fsm or negedge nReset_i)
  begin
    if (~nReset_i)
      tx_dout_byte <= 10'h3ff;
//    else if (~tx_rf)
    else if (~tx_rf_d3)
      tx_dout_byte <= 10'h3ff;
//    else if ((time_tr1_over && ~sof_dis) || (~eof_dis && crc_en && time_crc_over) || (~eof_dis && ~crc_en && tx_data_end))
//    else if ((time_tr1_over && ~sof_dis) || (crc_en && time_crc_over) || (~crc_en && tx_data_end))
    else if ((time_tr1_over && ~sof_dis) || (~eof_dis && crc_en && time_crc_over) || (~eof_dis && ~crc_en && tx_data_end))
      tx_dout_byte <= 10'h000;
    else if (tx_crc_en && ~(tx_data_end && ~crc_en && eof_dis))
      tx_dout_byte <= {1'b1, fifo_dout, 1'b0};
    else if (read_crc1)
      tx_dout_byte <= {1'b1, crc_dout[7:0], 1'b0};
    else if (read_crc2)
      tx_dout_byte <= {1'b1, crc_dout[15:8], 1'b0};
    else if (timer_high_inc)
      tx_dout_byte <= {1'b1, tx_dout_byte[9:1]} ;     //synchronous Reset
  end


assign  dout = tx_dout_byte[0];
/*
always @ (posedge clk_tx or negedge nrst_rf)
begin
  if ( ~nrst_rf )
    dout <= 1'b0;
  else
    dout <= tx_dout_byte[0];
end
*/

//always @ (posedge clk_848k_2 or negedge nrst_tx_dout)
always @ (posedge clk_848k_2 or negedge nReset_i)
begin
  if ( ~nReset_i )
    dout_d1 <= 1'b1;
  else if (~tx_rf)
    dout_d1 <= 1'b0;
  else if (out_en)
    dout_d1 <= dout;
end


assign  out_en = rf_state_tx_tr1 | rf_state_tx_sof | rf_state_tx_data | rf_state_tx_crc | (rf_state_tx_eof & ~time_eof_over);

/*
always @ (posedge clk_tx or negedge nrst_rf)
begin
  if ( ~nrst_rf )
    out_en <= 1'b0;
  else if (tx_rf)
    out_en <= out_en_tmp;
  else
    out_en <= 1'b0;
end
*/


assign  rf_dout_t1 =  clk_848k &  dout;
assign  rf_dout_t2 = ~clk_848k & ~dout_d1;
assign  dout_rise  =  dout     & ~dout_d1;

//assign  DOUT_RF_o  = out_en ? (rf_dout_t1 | rf_dout_t2 | dout_rise) : 1'b0;
assign  DOUT_RF_o  = out_en & (rf_dout_t1 | rf_dout_t2 | dout_rise);




// *****************************
// ******  FIFO module ******
// *****************************


assign  fifo_rst = ~(nReset_i & ~(rfp | (rfptx & ((tx & rx_set) | rfptx_rst)) | (sof_found)));

//assign  syn_fifo_rst = rfp;
assign  syn_rst_wr   = 1'b0;
assign  syn_rst_rd   = 1'b0;
assign  rst_wr       = fifo_rst;
assign  rst_rd       = fifo_rst;


/*
assign  clk_wr  = rx_rf ? clk_rx : Clk_i;
assign  clk_rd  = tx_rf ? clk_tx : Clk_i;
*/


ClkMux2  u_ClkMux2_clk_wr_sel (
  .nReset_i  ( nReset_i          ),
  .Sel_i     ( rx_rf             ),
  .Clkin1_i  ( clk_rx            ),
  .Clkin2_i  ( Clk_i             ),
  .Clkout_o  ( clk_wr            )
  );


ClkMux2  u_ClkMux2_clk_rd_sel (
  .nReset_i  ( nReset_i          ),
  .Sel_i     ( tx_rf             ),
  .Clkin1_i  ( clk_tx            ),
  .Clkin2_i  ( Clk_i             ),
  .Clkout_o  ( clk_rd            )
  );




//assign  #1 fifo_wr   = rx_rf ? fifo_wr_rf : RFDataReg_Write;
assign  fifo_wr   = rx_rf ? fifo_wr_rf : RFDataReg_Write;
assign  fifo_din  = rx_rf ? (rf_in_en ? rf_decode_dout : 8'h00) : (RFDataReg_Write ? Data_i[7:0] : 8'h00);
assign  wptr_wr   = rx_rf ? 1'b0           : RFWptrReg_Write;
assign  wptr_din  = (~rx_rf & RFWptrReg_Write) ? Data_i[7:0] : 8'h00;

assign  fifo_rd   = tx_rf ? rf_fifo_read   : RFDataReg_Read;
assign  rptr_wr   = tx_rf ? 1'b0           : RFRptrReg_Write;
assign  rptr_din  = (~tx_rf & RFRptrReg_Write) ? Data_i[7:0] : 8'h00;


assign  fifo_wr_avail = fifo_wr & ~(ferr | fifo_full);
assign  wptr_wr_avail = wptr_wr & ~ferr;
assign  fifo_rd_avail = fifo_rd & ~(ferr | fifo_empty);
assign  rptr_wr_avail = rptr_wr & ~ferr;



always @( posedge clk_wr or posedge rst_wr)
  begin
    if ( rst_wr )
        ferr_over <= 1'b0;
    else if ( syn_rst_wr )
        ferr_over <= 1'b0;
    else if ( fifo_full && fifo_wr)
        ferr_over <= 1'b1;
  end
/*
always @( posedge clk_wr or posedge rst_wr)
  begin
    if ( rst_wr )
        ferr_under_wr_d2 <= 2'b00;
    else if ( syn_rst_wr )
        ferr_under_wr_d2 <= 2'b00;
    else
        ferr_under_wr_d2 <= {ferr_under_wr_d2[0], ferr_under};
  end
*/
//assign  ferr_under_wr = ferr_under_wr_d2[1];
//assign  ferr_wr = ferr_over | ferr_under_wr;


always @( posedge clk_rd or posedge rst_rd)
  begin
    if ( rst_rd )
        ferr_under <= 1'b0;
    else if ( syn_rst_rd )
        ferr_under <= 1'b0;
    else if (fifo_empty && fifo_rd)
        ferr_under <= 1'b1;
  end
/*
always @( posedge clk_rd or posedge rst_rd)
  begin
    if ( rst_rd )
        ferr_over_rd_d2 <= 2'b00;
    else if ( syn_rst_rd )
        ferr_over_rd_d2 <= 2'b00;
    else
        ferr_over_rd_d2 <= {ferr_over_rd_d2[0], ferr_over};
  end

assign  ferr_over_rd = ferr_over_rd_d2[1];
assign  ferr_rd = ferr_under | ferr_over_rd;
*/



`ifdef  RTL_FPGA
afifo_fpga  u_afifo_fpga(
`else
afifo  u_afifo(
`endif
// write side
  //input
  .clk_wr               ( clk_wr        ),
  .rst_wr               ( rst_wr        ),
  .syn_rst_wr           ( syn_rst_wr    ),
  .fifo_wr              ( fifo_wr_avail ),
  .fifo_din             ( fifo_din      ),
  .wptr_wr              ( wptr_wr_avail ),
  .wptr_din             ( wptr_din      ),
  //output
  .fifo_full            ( fifo_full     ),
  .wptr_dout            ( wptr_dout     ),
  .in_status            ( in_status     ),

// read side
  //input
  .clk_rd               ( clk_rd        ),
  .rst_rd               ( rst_rd        ),
  .syn_rst_rd           ( syn_rst_rd    ),
  .fifo_rd              ( fifo_rd_avail ),
  .rptr_wr              ( rptr_wr_avail ),
  .rptr_din             ( rptr_din      ),
  //output
  .fifo_dout            ( fifo_dout     ),
  .fifo_empty           ( fifo_empty    ),
  .rptr_dout            ( rptr_dout     ),
  .out_status           ( out_status    )

//error flag
//  .ferr                 ( ferr          )
);



assign  crc_clk      = clk_fsm;
//assign  crc_clk      = ~crc_en | clk_fsm;

//assign  crc_nrst     = nReset_i & ~rfp & ~sof_found;
assign  crc_nrst     = nReset_i & ~rfp_rf & ~sof_found;

assign  crc_syn_rst  = rf_fifo_sof_dis;

assign  crc_en_avail = crc_en & ((rf_state_rx_data & fifo_wr_rf) | tx_crc_en);

assign  crc_din      = (rx_rf & crc_en) ? rf_decode_dout : ( (tx_rf & crc_en) ? fifo_dout : 8'h00 );



crc_logic_rf  u_crc_logic_rf(
  .clk_i                ( crc_clk       ),
  .nrst_i               ( crc_nrst      ),
  .syn_rst_i            ( crc_syn_rst   ),
  .en_i                 ( crc_en_avail  ),
  .din_i                ( crc_din       ),
  .dout_o               ( crc_dout      )
);



//======================
//    RF_IF signals
//======================
//read/write selector

assign  Data_o =  RFDataReg_Dout  | RFWptrReg_Dout | RFRptrReg_Dout    | RFSetupReg_Dout | RFCtrlReg_Dout |
                  RFStateReg_Dout | RFModeReg_Dout | RFFeatureReg_Dout | 32'h00;

assign  OENB_RF_o = rx_rf;


endmodule


