//////////////////////////                                                
//                                                                        
//copyright 2007, HHIC                                                    
//all right reserved                                                      
//                                                                        
//project name: 2605U4                                                    
//filename    : des.v                                          
//author      : Jerry                                                     
//data        : 2007/08/03                                                
//version     : 0.1                                                       
//                                                                        
//module name : des with AHB_SLAVE IF                
//                                                                        
//modification history                                                    
//---------------------------------                                      
//&Log&                                                                   
//                                                                        
//////////////////////////                                                
               

//-------------------------------------------------------------------------              
// AMBA definitions - local parameters                                                   
//-------------------------------------------------------------------------              
                                                                                         
`define                   DES_WRAPPER_IDLE                2'b00    // AMBA HTRANS 
`define                   DES_WRAPPER_BUSY                2'b01 
`define                   DES_WRAPPER_NONSEQ  2'b10   
`define                   DES_WRAPPER_SEQ                 2'b11   
                                                                                         
`define                   DES_WRAPPER_BYTE                3'b000   //HSIZE 
`define                   DES_WRAPPER_HALFWORD            3'b001                        
`define                   DES_WRAPPER_WORD                3'b010                        
`define                   DES_WRAPPER_DOUBLEWORD          3'b011                        
`define                   DES_WRAPPER_FOURWORD            3'b100                        
                                                                                         

`define                   DES_WRAPPER_OKAY                2'b00    // AMBA HRESP 
`define                   DES_WRAPPER_ERROR               2'b01   
`define                   DES_WRAPPER_RETRY               2'b10  
`define                   DES_WRAPPER_SPLIT               2'b11   

module  des         (
                     hclk,
                     POR,
                     hresetn,
                     hsel,                     
                     hwdata,                     
                     haddr,
                     hwrite,
                     htrans,
                     hsize,
                     hburst,
                     hready,
                     hready_resp,
                     hresp,                     
                     hrdata
                    );     

//AHB_SLAVE IF                     
input                hclk;
input                POR;
input                hresetn;                     
input                hsel;
input    [31:0]      hwdata;
input    [ 9:0]      haddr;
input                hwrite;
input    [1:0]       htrans;
input    [2:0]       hsize;
input    [2:0]       hburst;
input                hready;
output               hready_resp;
output   [1:0]       hresp;
output   [31:0]      hrdata;

wire                 hclk;
wire                 POR;
wire                 hresetn;
wire                 hsel;
wire     [31:0]      hwdata;
wire     [ 9:0]      haddr;
wire                 hwrite;
wire                 hready; //From AHB BUS
wire     [1:0]       htrans;
wire     [2:0]       hsize;
wire     [2:0]       hburst;
reg                  hready_resp;
wire     [1:0]       hresp;
reg      [31:0]      hrdata;

reg      [31:0]      data_in;
wire     [31:0]      data_out;
reg                  desctrl_sel;                             
reg                  desdat_sel;
reg                  deskey_sel;
reg                  desiv_sel;
reg                  rw;

wire                 desctrl_sel_current; 
wire                 desdat_sel_current ;                                   
wire                 deskey_sel_current ;                                   
wire                 desiv_sel_current  ;                

reg                  desctrl_sel_d1; 
reg                  desdat_sel_d1 ; 
reg                  deskey_sel_d1 ; 
reg                  desiv_sel_d1  ; 
     
wire                 ahb_nonseq;                   
wire                 ahb_seq;                      
wire                 ahb_act_mem_op;              
//reg                  ahb_act_mem_op_d1;  

reg                  hsel_d1;                    //latch hsel  
reg     [7:0]        haddr_d1;                   //latch haddr 
reg                  hwrite_d1;                  //latch hwrite
reg     [2:0]        hsize_d1;                   //latch hsize 
reg     [1:0]        htrans_d1;                  //latch htrans

wire    [31:0]       dbusin;
wire                 desctrl_rd;
wire                 desctrl_wr;
reg     [7:0]        desctrl;
reg                  run_delay;
 
wire                 deskey_wr;
wire    [63:0]       deskey1_64_out;
wire    [63:0]       deskey2_64_out;
wire    [63:0]       deskey3_64_out;
 
wire                 desdat_rd;
wire                 desdat_wr;
wire                 desdat_ready;
wire    [63:0]       desdat_64_in;
wire    [31:0]       desdat_8_out;
wire    [63:0]       desdat_64_out;
wire                 desdat_full;
wire                 des_start;
 
wire                 clr_ptr;
wire                 encrypt_whole;
wire                 dt_sel;
wire                 mode_sel;
wire                 key23_sel;
wire    [1:0]        edr;
wire                 iv_sel;
 
wire    [63:0]       desiv_64_out;
wire                 desiv_wr;
wire                 nextiv_ready;
reg                  nextiv_ready_en;
 
assign  dbusin[31:0]       =  data_in[31:0];

//desctrl, deskey, desdat_decoder
assign  desctrl_rd         =  (desctrl_sel == 1 && rw ==1)? 1'b1: 1'b0;
assign  desctrl_wr         =  (desctrl_sel == 1 && rw ==0)? 1'b1: 1'b0;
assign  encrypt_whole      =  desctrl[6];
assign  dt_sel             =  desctrl[5];
assign  key23_sel          =  desctrl[4];
assign  edr                =  desctrl[3:2];
assign  mode_sel           =  desctrl[1];
assign  iv_sel             =  desctrl[0];
 
assign  clr_ptr            =  (desctrl[7] == 1 && run_delay == 0)? 1'b0 : 1'b1;
assign  desiv_wr           =  (desiv_sel  == 1 && rw ==0)? 1'b1: 1'b0;
assign  deskey_wr          =  (deskey_sel == 1 && rw ==0)? 1'b1: 1'b0;
assign  desdat_rd          =  (desdat_sel == 1 && rw ==1)? 1'b1: 1'b0;
assign  desdat_wr          =  (desdat_sel == 1 && rw ==0)? 1'b1: 1'b0;
//end decoder

assign  ahb_nonseq         =   (htrans == `DES_WRAPPER_NONSEQ); 
assign  ahb_seq            =   (htrans == `DES_WRAPPER_SEQ);  
assign  ahb_act_mem_op     =   ( ahb_nonseq || ahb_seq ) && hsel && hready && (haddr[9:4] == 6'b0); 

assign  data_out[31:0]     =   (desctrl_rd == 1'b1) ? {24'b0,desctrl[7:0]} : desdat_8_out[31:0];
assign  des_start          =   (desctrl[7]==1'b1)? desdat_full:1'b0;
assign  nextiv_ready = (mode_sel==1'b0)? 1'b0:(encrypt_whole==1'b0)? nextiv_ready_en : desdat_ready;

always @(posedge hclk or negedge hresetn)
begin
    if (hresetn == 1'b0)
        begin
            nextiv_ready_en <= #1 1'b0;
            run_delay       <= #1 1'b0;
        end
    else
        begin
            nextiv_ready_en <= #1 desdat_ready;
            run_delay       <= #1 desctrl[7];
        end
end
 
always @(posedge hclk or negedge hresetn)
begin
    if(hresetn == 1'b0)
        desctrl[7:0] <= #1 8'b0;
    else if (desdat_ready == 1'b1)
        desctrl <= #1 {1'b0, desctrl[6:0]};
    else if (desctrl_wr == 1'b1)
        desctrl[7:0] <= #1 dbusin[7:0];
end

des_key         deskey_unit(
                            .hclk(hclk),
                            .hresetn(hresetn),
                            .clrptr(clr_ptr),
                            .wr(deskey_wr),
                            .data(dbusin),
                            .q1_all(deskey1_64_out),
                            .q2_all(deskey2_64_out),
                            .q3_all(deskey3_64_out)
                           );

des_iv          desiv_unit (
                            .POR(POR),
                            .hclk(hclk),
                            .hresetn(hresetn),
                            .clrptr(clr_ptr),
                            .wr(desiv_wr),
                            .deswr(nextiv_ready),
                            .data(dbusin),
                            .data_all(desdat_64_out),
                            .q_all(desiv_64_out)
                           );
 
des_dat         desdat_unit(
                            .POR(POR),
                            .hclk(hclk),
                            .hresetn(hresetn),
                            .clrptr(clr_ptr),
                            .rd(desdat_rd),
                            .wr(desdat_wr),
                            .deswr(desdat_ready),
                            .data(dbusin),
                            .data_all(desdat_64_in),
                            .full_pulse(desdat_full),
                            .q(desdat_8_out),
                            .q_all(desdat_64_out)
                           );

des_cop         des_cop_unit(
                             .hclk(hclk),
                             .POR(POR),
                             .hresetn(hresetn),
                             .encrypt_whole(encrypt_whole),
                             .dt_sel(dt_sel),
                             .key23_sel(key23_sel),
                             .edr(edr),
                             .mode_sel(mode_sel),
                             .iv_sel(iv_sel),
                             .iv(desiv_64_out),
                             .key1(deskey1_64_out),
                             .key2(deskey2_64_out),
                             .key3(deskey3_64_out),
                             .din(desdat_64_out),
                             .din_valid_whole(des_start),
                             .dout(desdat_64_in),
                             .dout_valid(desdat_ready)
                            );

//delay 1 cycle control and address siganls                                                             
always @(posedge hclk or negedge hresetn)
begin      
    if (hresetn == 1'b0) 
        begin   
            hsel_d1            <= #1  1'b0;
            haddr_d1[7:0]      <= #1  8'h0;
            hwrite_d1          <= #1  1'b0;
            hsize_d1[2:0]      <= #1  `DES_WRAPPER_WORD; 
            htrans_d1[1:0]     <= #1  `DES_WRAPPER_NONSEQ;
            desctrl_sel_d1     <= #1  1'b0; 
            desdat_sel_d1      <= #1  1'b0;
            deskey_sel_d1      <= #1  1'b0;
            desiv_sel_d1       <= #1  1'b0;
//            ahb_act_mem_op_d1  <= #1  1'b0;
        end
    else if (ahb_act_mem_op == 1'b1) 
        begin            
            hsel_d1            <= #1  hsel; 
            haddr_d1[7:0]      <= #1  haddr[7:0];
            hwrite_d1          <= #1  hwrite;
            hsize_d1[2:0]      <= #1  hsize[2:0]; 
            htrans_d1[1:0]     <= #1  htrans[1:0];
            desctrl_sel_d1     <= #1  desctrl_sel_current;
            desdat_sel_d1      <= #1  desdat_sel_current ;
            deskey_sel_d1      <= #1  deskey_sel_current ;
            desiv_sel_d1       <= #1  desiv_sel_current  ;
//            ahb_act_mem_op_d1  <= #1  ahb_act_mem_op;
        end     
    else
        begin
            hsel_d1            <= #1  1'b0;
            haddr_d1[7:0]      <= #1  8'h0;
            hwrite_d1          <= #1  1'b0;
            hsize_d1[2:0]      <= #1  `DES_WRAPPER_WORD;
            htrans_d1[1:0]     <= #1  `DES_WRAPPER_NONSEQ;
            desctrl_sel_d1     <= #1  1'b0;
            desdat_sel_d1      <= #1  1'b0;
            deskey_sel_d1      <= #1  1'b0;
            desiv_sel_d1       <= #1  1'b0;
//            ahb_act_mem_op_d1  <= #1  1'b0;
        end
end 

assign desctrl_sel_current = (haddr[3:0]==4'h0  && ahb_act_mem_op==1'b1)? 1'b1:1'b0;
assign desdat_sel_current  = (haddr[3:0]==4'h4  && ahb_act_mem_op==1'b1)? 1'b1:1'b0;
assign deskey_sel_current  = (haddr[3:0]==4'h8  && ahb_act_mem_op==1'b1)? 1'b1:1'b0;
assign desiv_sel_current   = (haddr[3:0]==4'hc  && ahb_act_mem_op==1'b1)? 1'b1:1'b0;


//des SFR sel 
always @(posedge hclk or negedge hresetn)
begin
    if (hresetn == 1'b0)
        begin
                    desctrl_sel        <= #1 1'b0;
                    desdat_sel         <= #1 1'b0;
                    deskey_sel         <= #1 1'b0;
                    desiv_sel          <= #1 1'b0;
                    data_in[31:0]      <= #1 32'b0;
                    rw                 <= #1 1'b1;   
        end   
    else
        if (hwrite_d1 == 1'b1)
               begin
                   desctrl_sel         <= #1 desctrl_sel_d1; 
                   desdat_sel          <= #1 desdat_sel_d1 ;
                   deskey_sel          <= #1 deskey_sel_d1 ;
                   desiv_sel           <= #1 desiv_sel_d1  ;
                   data_in[31:0]       <= #1 hwdata[31:0];
                   rw                  <= #1 ~hwrite_d1;
               end
        else if (ahb_act_mem_op == 1'b1)
            begin
                if(hwrite==1'b0)
                    begin
                       desctrl_sel     <= #1 desctrl_sel_current; 
                       desdat_sel      <= #1 desdat_sel_current ;
                       deskey_sel      <= #1 deskey_sel_current ;
                       desiv_sel       <= #1 desiv_sel_current  ;
                       data_in[31:0]   <= #1 32'b0;
                       rw              <= #1 ~hwrite;       
                    end
                else
                    begin
                        desctrl_sel    <= #1 1'b0;
                        desdat_sel     <= #1 1'b0;
                        deskey_sel     <= #1 1'b0;
                        desiv_sel      <= #1 1'b0;
                        data_in[31:0]  <= #1 32'b0;
                        rw             <= #1 ~hwrite; 
                    end
            end
        else
            begin
                desctrl_sel   <=  #1 1'b0;
                desdat_sel    <=  #1 1'b0;
                deskey_sel    <=  #1 1'b0;
                desiv_sel     <=  #1 1'b0;
                data_in[31:0] <=  #1 32'b0;
                rw            <=  #1 rw;   
            end
end

always @(*)
begin
    if (hwrite_d1 == 1'b0)
        begin
            hrdata[31:0] = data_out[31:0]; 
        end 
    else
        begin
            hrdata[31:0] = 32'b0 ;
        end
end

//hresp                             
assign    hresp   =   `DES_WRAPPER_OKAY; 

//hready_resp                  
always @(posedge hclk or negedge hresetn)
begin
    if (hresetn == 1'b0)
        hready_resp <= #1 1'b1;
    else if (((desctrl_sel_current == 1'b1) && (hwrite == 1'b1)) || ((desctrl_sel_d1 == 1'b1) && (hwrite_d1 == 1'b1)))
        hready_resp <= #1 1'b0;
    else 
        hready_resp <= #1 1'b1;
end

endmodule
