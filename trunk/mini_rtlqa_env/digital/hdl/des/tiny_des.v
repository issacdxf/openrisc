//////////////////////////                                                                             
//                                                                                                     
//copyright 2007, HHIC                                                                                 
//all right reserved                                                                                   
//                                                                                                     
//project name: 2605U4                                                                                 
//filename    : tiny_des.v                                                                             
//author      : Jerry                                                                                  
//data        : 2007/08/03                   
//version     : 0.1                          
//                                           
//module name : des main function module     
//                                           
//modification history                       
//---------------------------------          
//&Log&                                      
//                                           
//////////////////////////                   

`define     TINY_IDLE                    1'b0
`define     TINY_WORKING                 1'b1

                                             
                                             
module      tiny_des(
                     hclk,
                     POR,
                     hresetn,
                     encrypt,
                     edr,
                     key_in,
                     din,
                     din_valid,
                     round,
                     dout,
                     dout_valid
                    );

input                hclk;
input                POR;
input                hresetn;
input                encrypt;
input  [1:0]         edr;
input  [63:0]        key_in;
input  [63:0]        din;
input                din_valid;

output [3:0]         round;
output [63:0]        dout;
output               dout_valid;

wire                 hclk;
wire                 POR;
wire                 hresetn;
wire                 encrypt;
wire   [63:0]        key_in;
wire   [63:0]        din;
wire                 din_valid;
wire   [63:0]        dout;
reg                  dout_valid;

reg                  state;
reg    [3:0]         round;
wire                 stall;

reg    [4:0]         encrypt_shift;
reg    [4:0]         decrypt_shift;

wire   [63:0]        r_din;
wire   [63:0]        r_dout;

wire   [3:0]         last_round; // add 031123

assign last_round[3:0] = {2'b00,edr[1:0]} - 1'b1;	 
  
always @(posedge hclk or negedge hresetn) 
begin
    if(hresetn == 1'b 0)
        state <= #1 `TINY_IDLE;
    else 
        begin
            case(state)
            `TINY_IDLE :
                begin
                    if(din_valid == 1'b 1 && edr!=2'b01)
                        state <= #1 `TINY_WORKING;
                end
            `TINY_WORKING :
                begin
                    if(round[3:0]==last_round[3:0])		//change to support 123 round 
                        state <= #1 `TINY_IDLE;
                end     
            endcase
        end
end

  // Track the current DES round 
always @(posedge hclk or negedge hresetn)
begin
    if(hresetn == 1'b 0)
        round[3:0] <= #1 4'b 0000;
    else 
        begin
            if((state != `TINY_IDLE)&&(round[3:0]!=last_round[3:0])) 
                round[3:0] <= #1 round[3:0] + 1'b1;
            else if((din_valid == 1'b 1)&& (edr[1:0]!=2'b01))
                round[3:0] <= #1 round[3:0] + 1;
            else
                round[3:0] <= #1 4'b 0000;
        end
end

assign r_din[63:0] = state == `TINY_IDLE ? des_ip(din[63:0]) : r_dout[63:0];

assign stall =   ~(din_valid|(state == `TINY_WORKING));

tiny_des_round u_tiny_des_round(
                                .hclk            (hclk),
                                .POR             (POR),
                                .hresetn         (hresetn),
                                .stall           (stall),
                                .encrypt_in      (encrypt),	      
                                .encrypt_shift   (encrypt_shift),
                                .decrypt_shift   (decrypt_shift),
                                .key_in          (key_in),
                                .din             (r_din),
                                .dout            (r_dout)
                               );

// Generate the encrypt/decrypt key shift amounts:
always @(*)
begin
    case(round[3:0])	 
    4'b 0000 :
        begin
          encrypt_shift[4:0] = 5'b 00001;
          case(edr[1:0])	 
          	2'b00	:
          	decrypt_shift[4:0] = 5'b 00000;
          	2'b01 	:
          	decrypt_shift[4:0] = 5'b 00001;
          	2'b10	:
          	decrypt_shift[4:0] = 5'b 00010;
          	2'b11	:
          	decrypt_shift[4:0] = 5'b 00100;
        endcase
        end
    4'b 0001 :
        begin
          encrypt_shift = 5'b 00010;
          case(edr[1:0])	 
          	2'b10	:
          	decrypt_shift[4:0] = 5'b 00001;
          	2'b11	:
          	decrypt_shift[4:0] = 5'b 00010;
          	default:
          	decrypt_shift[4:0] = 5'b 11011;
        endcase
        end
    4'b 0010 :
        begin
          encrypt_shift[4:0] = 5'b 00100;
          if (edr[1:0] == 2'b 11) 
          	decrypt_shift[4:0] = 5'b 00001;
          else
          	decrypt_shift[4:0] = 5'b 11001;
        end
    4'b 0011 :
        begin
          encrypt_shift[4:0] = 5'b 00110;
          decrypt_shift[4:0] = 5'b 10111;
        end
    4'b 0100 :
        begin
          encrypt_shift[4:0] = 5'b 01000;
          decrypt_shift[4:0] = 5'b 10101;
        end
    4'b 0101 :
        begin
          encrypt_shift[4:0] = 5'b 01010;
          decrypt_shift[4:0] = 5'b 10011;
        end
    4'b 0110 :
        begin
          encrypt_shift[4:0] = 5'b 01100;
          decrypt_shift[4:0] = 5'b 10001;
        end
    4'b 0111 :
        begin
          encrypt_shift[4:0] = 5'b 01110;
          decrypt_shift[4:0] = 5'b 01111;
        end
    4'b 1000 :
        begin
          encrypt_shift[4:0] = 5'b 01111;
          decrypt_shift[4:0] = 5'b 01110;
        end
    4'b 1001 :
        begin
          encrypt_shift[4:0] = 5'b 10001;
          decrypt_shift[4:0] = 5'b 01100;
        end
    4'b 1010 :
        begin
          encrypt_shift[4:0] = 5'b 10011;
          decrypt_shift[4:0] = 5'b 01010;
        end
    4'b 1011 :
        begin
          encrypt_shift[4:0] = 5'b 10101;
          decrypt_shift[4:0] = 5'b 01000;
        end
    4'b 1100 :
        begin
          encrypt_shift[4:0] = 5'b 10111;
          decrypt_shift[4:0] = 5'b 00110;
        end
    4'b 1101 :
        begin
          encrypt_shift[4:0] = 5'b 11001;
          decrypt_shift[4:0] = 5'b 00100;
        end
    4'b 1110 :
        begin
          encrypt_shift[4:0] = 5'b 11011;
          decrypt_shift[4:0] = 5'b 00010;
        end
    4'b 1111 :
        begin
          encrypt_shift[4:0] = 5'b 00000;
          decrypt_shift[4:0] = 5'b 00001;
          //??encrypt_shift = "11100"
        end
//    default : 
//        begin
//          encrypt_shift[4:0] = 5'b 00001;
//          decrypt_shift[4:0] = 5'b 00000;
//        end
    endcase
end

// Generate the dout_valid signal
//hresetn needed here 040220.
always @(posedge hclk or negedge hresetn)
begin
    if(hresetn == 1'b 0)
        dout_valid <= #1 1'b 0;
    else 
        begin
            if((edr[1:0]==2'b01 && din_valid==1)||(edr[1:0]!=2'b01 && round[3:0]==last_round[3:0]))
                dout_valid <= #1 1'b 1;
            else
                dout_valid <= #1 1'b 0;
        end
end

// Output the data
assign dout[63:0] = des_fp({r_dout[31:0],r_dout[63:32]});

//-----------------------------------functions-------------------------------------------------                           
                                                                                                                          
//---------------------function des_ip---------------------------------                                                   
//Inital permutation                                                                                                      
//function des_ip(din	:std_logic_vector(63 downto 0))                                                                     
//return std_logic_vector is                                                                                              
//variable val 	:std_logic_vector (63 downto 0);                                                                          
function [63:0] des_ip;                                                                                                   
input[63:0] din;                                                                                                          
begin                                                                                                                     
    des_ip = {din[64 - 58],din[64 - 50],din[64 - 42],din[64 - 34],din[64 - 26],din[64 - 18],din[64 - 10],din[64 - 2],     
              din[64 - 60],din[64 - 52],din[64 - 44],din[64 - 36],din[64 - 28],din[64 - 20],din[64 - 12],din[64 - 4],     
              din[64 - 62],din[64 - 54],din[64 - 46],din[64 - 38],din[64 - 30],din[64 - 22],din[64 - 14],din[64 - 6],     
              din[64 - 64],din[64 - 56],din[64 - 48],din[64 - 40],din[64 - 32],din[64 - 24],din[64 - 16],din[64 - 8],     
              din[64 - 57],din[64 - 49],din[64 - 41],din[64 - 33],din[64 - 25],din[64 - 17],din[64 -  9],din[64 - 1],     
              din[64 - 59],din[64 - 51],din[64 - 43],din[64 - 35],din[64 - 27],din[64 - 19],din[64 - 11],din[64 - 3],     
              din[64 - 61],din[64 - 53],din[64 - 45],din[64 - 37],din[64 - 29],din[64 - 21],din[64 - 13],din[64 - 5],     
              din[64 - 63],din[64 - 55],din[64 - 47],din[64 - 39],din[64 - 31],din[64 - 23],din[64 - 15],din[64 - 7]      
             };                                                                                                           
end                                                                                                                       
endfunction                                                                                                               
//end des_ip;                                                                                                             
                                                                                                                          
//---------------------function des_fp---------------------------------                                                   
//Final permutation                                                                                                       
//function des_fp(din	:std_logic_vector(63 downto 0))                                                                     
//return std_logic_vector is                                                                                              
//variable val 	:std_logic_vector (63 downto 0);                                                                          
function [63:0] des_fp;                                                                                                   
input[63:0] din;                                                                                                          
begin                                                                                                                     
    des_fp = {din[64 - 40],din[64 - 8],din[64 - 48],din[64 - 16],din[64 - 56],din[64 - 24],din[64 - 64],din[64 - 32],     
              din[64 - 39],din[64 - 7],din[64 - 47],din[64 - 15],din[64 - 55],din[64 - 23],din[64 - 63],din[64 - 31],     
              din[64 - 38],din[64 - 6],din[64 - 46],din[64 - 14],din[64 - 54],din[64 - 22],din[64 - 62],din[64 - 30],     
              din[64 - 37],din[64 - 5],din[64 - 45],din[64 - 13],din[64 - 53],din[64 - 21],din[64 - 61],din[64 - 29],     
              din[64 - 36],din[64 - 4],din[64 - 44],din[64 - 12],din[64 - 52],din[64 - 20],din[64 - 60],din[64 - 28],     
              din[64 - 35],din[64 - 3],din[64 - 43],din[64 - 11],din[64 - 51],din[64 - 19],din[64 - 59],din[64 - 27],     
              din[64 - 34],din[64 - 2],din[64 - 42],din[64 - 10],din[64 - 50],din[64 - 18],din[64 - 58],din[64 - 26],     
              din[64 - 33],din[64 - 1],din[64 - 41],din[64 - 9],din[64 - 49],din[64 - 17],din[64 - 57],din[64 - 25]       
             };                                                                                                           
end                                                                                                                       
endfunction                                                                                                               
//end des_fp;                                                                                                             

endmodule

