//////////////////////////                         
//                                                 
//copyright 2007, HHIC                             
//all right reserved                               
//                                                 
//project name: 2605U4                             
//filename    : tb_des_inter.v                     
//author      : Jerry                              
//data        : 2007/08/03                         
//version     : 0.1                                
//                                                 
//module name : testbench for des_inter module     
//                                                 
//modification history                             
//---------------------------------                
//&Log&                                            
//                                                 
//////////////////////////                                                                            
                                                   
module tiny_des_round(
                      hclk,
                      POR,
                      hresetn,
                      stall,
                      encrypt_in,
                      encrypt_shift,
                      decrypt_shift,
                      key_in,
                      din,
                      dout
                      );

input                 hclk;
input                 POR;
input                 hresetn;
input                 stall;
input                 encrypt_in;
input  [4:0]          encrypt_shift;
input  [4:0]          decrypt_shift;
input  [63:0]         key_in;
input  [63:0]         din;
output [63:0]         dout;

wire                  hclk;
wire                  POR;
wire                  hresetn;
wire                  stall;
wire                  encrypt_in;
wire   [4:0]          encrypt_shift;
wire   [4:0]          decrypt_shift;
wire   [63:0]         key_in;
wire   [63:0]         din;

reg    [63:0]         dout;
reg    [4:0]          shift;

always @(posedge hclk or negedge POR)
//begin : procedure1
begin
    if (POR == 1'b0)
        begin
            dout[63:0] <= #1 64'b0;
        end
    else if(stall == 1'b 0)
        begin
            if(encrypt_in == 1'b 0)
                dout[63:0] <= #1 {din[31:0],(des_pbox(des_sbox(des_ep(din[31:0]) ^ des_cp(des_keyshift(des_kp(key_in[63:0]),encrypt_shift[4:0])))) ^ din[63:32])};                                     
            else       
                dout[63:0] <= #1 {din[31:0],(des_pbox(des_sbox(des_ep(din[31:0]) ^ des_cp(des_keyshift(des_kp(key_in[63:0]),decrypt_shift[4:0])))) ^ din[63:32])};  
        end
end
//end

//-------------------------functions---------------------------------------------------------------
    
//-------------------------function des_kp---------------------------------------------------------
//Key permutation, converts a 64 bit key into a 56 bit key, ignoring parity
//function des_kp(din   :std_logic_vector (63 downto 0))
//return std_logic_vector is
//variable val 	:std_logic_vector (55 downto 0);
//begin
function [55:0] des_kp;
input[63:0] din;
begin
    des_kp = {din[64 - 57],din[64 - 49],din[64 - 41],din[64 - 33],din[64 - 25],din[64 - 17],din[64 -  9],
              din[64 -  1],din[64 - 58],din[64 - 50],din[64 - 42],din[64 - 34],din[64 - 26],din[64 - 18],
              din[64 - 10],din[64 -  2],din[64 - 59],din[64 - 51],din[64 - 43],din[64 - 35],din[64 - 27],
              din[64 - 19],din[64 - 11],din[64 -  3],din[64 - 60],din[64 - 52],din[64 - 44],din[64 - 36],
              din[64 - 63],din[64 - 55],din[64 - 47],din[64 - 39],din[64 - 31],din[64 - 23],din[64 - 15],
              din[64 -  7],din[64 - 62],din[64 - 54],din[64 - 46],din[64 - 38],din[64 - 30],din[64 - 22],
              din[64 - 14],din[64 -  6],din[64 - 61],din[64 - 53],din[64 - 45],din[64 - 37],din[64 - 29],
              din[64 - 21],din[64 - 13],din[64 -  5],din[64 - 28],din[64 - 20],din[64 - 12],din[64 -  4]
             };
end
endfunction
//end des_kp---------------------------------------------------------------------------------------

//-------------------------function des_cp---------------------------------------------------------
//Compression Permutation, converts a 56 bit key into a 48 bits.
//function des_cp(din   :std_logic_vector (55 downto 0))
//return std_logic_vector is
//variable val 	:std_logic_vector (47 downto 0);
//begin
function [47:0] des_cp;
input[55:0] din;
begin
    des_cp = {din[56 - 14],din[56 - 17],din[56 - 11],din[56 - 24],din[56 -  1],din[56 -  5],
              din[56 -  3],din[56 - 28],din[56 - 15],din[56 -  6],din[56 - 21],din[56 - 10],
              din[56 - 23],din[56 - 19],din[56 - 12],din[56 -  4],din[56 - 26],din[56 -  8],
              din[56 - 16],din[56 -  7],din[56 - 27],din[56 - 20],din[56 - 13],din[56 -  2],
              din[56 - 41],din[56 - 52],din[56 - 31],din[56 - 37],din[56 - 47],din[56 - 55],
              din[56 - 30],din[56 - 40],din[56 - 51],din[56 - 45],din[56 - 33],din[56 - 48],
              din[56 - 44],din[56 - 49],din[56 - 39],din[56 - 56],din[56 - 34],din[56 - 53],
              din[56 - 46],din[56 - 42],din[56 - 50],din[56 - 36],din[56 - 29],din[56 - 32]
             };
end
endfunction
//end des_cp---------------------------------------------------------------------------------------

//-------------------------function des_ep---------------------------------------------------------
//Expansion permutation
//function des_ep(din   :std_logic_vector (31 downto 0))
//return std_logic_vector is
//variable val 	:std_logic_vector (47 downto 0);
//begin
function [47:0] des_ep;
input[31:0] din;
begin
    des_ep = {din[32 - 32],din[32 -  1],din[32 -  2],din[32 -  3],din[32 -  4],din[32 -  5],
              din[32 -  4],din[32 -  5],din[32 -  6],din[32 -  7],din[32 -  8],din[32 -  9],
              din[32 -  8],din[32 -  9],din[32 - 10],din[32 - 11],din[32 - 12],din[32 - 13],
              din[32 - 12],din[32 - 13],din[32 - 14],din[32 - 15],din[32 - 16],din[32 - 17],
              din[32 - 16],din[32 - 17],din[32 - 18],din[32 - 19],din[32 - 20],din[32 - 21],
              din[32 - 20],din[32 - 21],din[32 - 22],din[32 - 23],din[32 - 24],din[32 - 25],
              din[32 - 24],din[32 - 25],din[32 - 26],din[32 - 27],din[32 - 28],din[32 - 29],
              din[32 - 28],din[32 - 29],din[32 - 30],din[32 - 31],din[32 - 32],din[32 -  1]
             };
end
endfunction
//end des_ep-----------------------------------------------------------------------------------------

//-------------------------function des_sbox---------------------------------------------------------
// S-Box Substitution, 48 bits in, 32 bits out.
//function des_sbox(din   :std_logic_vector (47 downto 0))
//return std_logic_vector is
//variable val 	:std_logic_vector (31 downto 0);
//begin
// SBOX 8
function [31:0] des_sbox;
input[47:0] din;
begin  
case(din[5:0])
6'b 000000 :
    des_sbox[3:0] = 4'b 1101;
6'b 000001 :
    des_sbox[3:0] = 4'b 0001;
6'b 000010 :
    des_sbox[3:0] = 4'b 0010;
6'b 000011 :
    des_sbox[3:0] = 4'b 1111;
6'b 000100 :
    des_sbox[3:0] = 4'b 1000;
6'b 000101 :
    des_sbox[3:0] = 4'b 1101;
6'b 000110 :
    des_sbox[3:0] = 4'b 0100;
6'b 000111 :
    des_sbox[3:0] = 4'b 1000;
6'b 001000 :
    des_sbox[3:0] = 4'b 0110;
6'b 001001 :
    des_sbox[3:0] = 4'b 1010;
6'b 001010 :
    des_sbox[3:0] = 4'b 1111;
6'b 001011 :
    des_sbox[3:0] = 4'b 0011;
6'b 001100 :
    des_sbox[3:0] = 4'b 1011;
6'b 001101 :
    des_sbox[3:0] = 4'b 0111;
6'b 001110 :
    des_sbox[3:0] = 4'b 0001;
6'b 001111 :
    des_sbox[3:0] = 4'b 0100;
6'b 010000 :
    des_sbox[3:0] = 4'b 1010;
6'b 010001 :
    des_sbox[3:0] = 4'b 1100;
6'b 010010 :
    des_sbox[3:0] = 4'b 1001;
6'b 010011 :
    des_sbox[3:0] = 4'b 0101;
6'b 010100 :
    des_sbox[3:0] = 4'b 0011;
6'b 010101 :
    des_sbox[3:0] = 4'b 0110;
6'b 010110 :
    des_sbox[3:0] = 4'b 1110;
6'b 010111 :
    des_sbox[3:0] = 4'b 1011;
6'b 011000 :
    des_sbox[3:0] = 4'b 0101;
6'b 011001 :
    des_sbox[3:0] = 4'b 0000;
6'b 011010 :
    des_sbox[3:0] = 4'b 0000;
6'b 011011 :
    des_sbox[3:0] = 4'b 1110;
6'b 011100 :
    des_sbox[3:0] = 4'b 1100;
6'b 011101 :
    des_sbox[3:0] = 4'b 1001;
6'b 011110 :
    des_sbox[3:0] = 4'b 0111;
6'b 011111 :
    des_sbox[3:0] = 4'b 0010;
6'b 100000 :
    des_sbox[3:0] = 4'b 0111;
6'b 100001 :
    des_sbox[3:0] = 4'b 0010;
6'b 100010 :
    des_sbox[3:0] = 4'b 1011;
6'b 100011 :
    des_sbox[3:0] = 4'b 0001;
6'b 100100 :
    des_sbox[3:0] = 4'b 0100;
6'b 100101 :
    des_sbox[3:0] = 4'b 1110;
6'b 100110 :
    des_sbox[3:0] = 4'b 0001;
6'b 100111 :
    des_sbox[3:0] = 4'b 0111;
6'b 101000 :
    des_sbox[3:0] = 4'b 1001;
6'b 101001 :
    des_sbox[3:0] = 4'b 0100;
6'b 101010 :
    des_sbox[3:0] = 4'b 1100;
6'b 101011 :
    des_sbox[3:0] = 4'b 1010;
6'b 101100 :
    des_sbox[3:0] = 4'b 1110;
6'b 101101 :
    des_sbox[3:0] = 4'b 1000;
6'b 101110 :
    des_sbox[3:0] = 4'b 0010;
6'b 101111 :
    des_sbox[3:0] = 4'b 1101;
6'b 110000 :
    des_sbox[3:0] = 4'b 0000;
6'b 110001 :
    des_sbox[3:0] = 4'b 1111;
6'b 110010 :
    des_sbox[3:0] = 4'b 0110;
6'b 110011 :
    des_sbox[3:0] = 4'b 1100;
6'b 110100 :
    des_sbox[3:0] = 4'b 1010;
6'b 110101 :
    des_sbox[3:0] = 4'b 1001;
6'b 110110 :
    des_sbox[3:0] = 4'b 1101;
6'b 110111 :
    des_sbox[3:0] = 4'b 0000;
6'b 111000 :
    des_sbox[3:0] = 4'b 1111;
6'b 111001 :
    des_sbox[3:0] = 4'b 0011;
6'b 111010 :
    des_sbox[3:0] = 4'b 0011;
6'b 111011 :
    des_sbox[3:0] = 4'b 0101;
6'b 111100 :
    des_sbox[3:0] = 4'b 0101;
6'b 111101 :
    des_sbox[3:0] = 4'b 0110;
6'b 111110 :
    des_sbox[3:0] = 4'b 1000;
6'b 111111 :
    des_sbox[3:0] = 4'b 1011;
//default : 
//    des_sbox[3:0] = 4'b 1011;
endcase 

// SBOX 7
case(din[11:6])
6'b 000000 :
    des_sbox[7:4] = 4'b 0100;
6'b 000001 :
    des_sbox[7:4] = 4'b 1101;
6'b 000010 :
    des_sbox[7:4] = 4'b 1011;
6'b 000011 :
    des_sbox[7:4] = 4'b 0000;
6'b 000100 :
    des_sbox[7:4] = 4'b 0010;
6'b 000101 :
    des_sbox[7:4] = 4'b 1011;
6'b 000110 :
    des_sbox[7:4] = 4'b 1110;
6'b 000111 :
    des_sbox[7:4] = 4'b 0111;
6'b 001000 :
    des_sbox[7:4] = 4'b 1111;
6'b 001001 :
    des_sbox[7:4] = 4'b 0100;
6'b 001010 :
    des_sbox[7:4] = 4'b 0000;
6'b 001011 :
    des_sbox[7:4] = 4'b 1001;
6'b 001100 :
    des_sbox[7:4] = 4'b 1000;
6'b 001101 :
    des_sbox[7:4] = 4'b 0001;
6'b 001110 :
    des_sbox[7:4] = 4'b 1101;
6'b 001111 :
    des_sbox[7:4] = 4'b 1010;
6'b 010000 :
    des_sbox[7:4] = 4'b 0011;
6'b 010001 :
    des_sbox[7:4] = 4'b 1110;
6'b 010010 :
    des_sbox[7:4] = 4'b 1100;
6'b 010011 :
    des_sbox[7:4] = 4'b 0011;
6'b 010100 :
    des_sbox[7:4] = 4'b 1001;
6'b 010101 :
    des_sbox[7:4] = 4'b 0101;
6'b 010110 :
    des_sbox[7:4] = 4'b 0111;
6'b 010111 :
    des_sbox[7:4] = 4'b 1100;
6'b 011000 :
    des_sbox[7:4] = 4'b 0101;
6'b 011001 :
    des_sbox[7:4] = 4'b 0010;
6'b 011010 :
    des_sbox[7:4] = 4'b 1010;
6'b 011011 :
    des_sbox[7:4] = 4'b 1111;
6'b 011100 :
    des_sbox[7:4] = 4'b 0110;
6'b 011101 :
    des_sbox[7:4] = 4'b 1000;
6'b 011110 :
    des_sbox[7:4] = 4'b 0001;
6'b 011111 :
    des_sbox[7:4] = 4'b 0110;
6'b 100000 :
    des_sbox[7:4] = 4'b 0001;
6'b 100001 :
    des_sbox[7:4] = 4'b 0110;
6'b 100010 :
    des_sbox[7:4] = 4'b 0100;
6'b 100011 :
    des_sbox[7:4] = 4'b 1011;
6'b 100100 :
    des_sbox[7:4] = 4'b 1011;
6'b 100101 :
    des_sbox[7:4] = 4'b 1101;
6'b 100110 :
    des_sbox[7:4] = 4'b 1101;
6'b 100111 :
    des_sbox[7:4] = 4'b 1000;
6'b 101000 :
    des_sbox[7:4] = 4'b 1100;
6'b 101001 :
    des_sbox[7:4] = 4'b 0001;
6'b 101010 :
    des_sbox[7:4] = 4'b 0011;
6'b 101011 :
    des_sbox[7:4] = 4'b 0100;
6'b 101100 :
    des_sbox[7:4] = 4'b 0111;
6'b 101101 :
    des_sbox[7:4] = 4'b 1010;
6'b 101110 :
    des_sbox[7:4] = 4'b 1110;
6'b 101111 :
    des_sbox[7:4] = 4'b 0111;
6'b 110000 :
    des_sbox[7:4] = 4'b 1010;
6'b 110001 :
    des_sbox[7:4] = 4'b 1001;
6'b 110010 :
    des_sbox[7:4] = 4'b 1111;
6'b 110011 :
    des_sbox[7:4] = 4'b 0101;
6'b 110100 :
    des_sbox[7:4] = 4'b 0110;
6'b 110101 :
    des_sbox[7:4] = 4'b 0000;
6'b 110110 :
    des_sbox[7:4] = 4'b 1000;
6'b 110111 :
    des_sbox[7:4] = 4'b 1111;
6'b 111000 :
    des_sbox[7:4] = 4'b 0000;
6'b 111001 :
    des_sbox[7:4] = 4'b 1110;
6'b 111010 :
    des_sbox[7:4] = 4'b 0101;
6'b 111011 :
    des_sbox[7:4] = 4'b 0010;
6'b 111100 :
    des_sbox[7:4] = 4'b 1001;
6'b 111101 :
    des_sbox[7:4] = 4'b 0011;
6'b 111110 :
    des_sbox[7:4] = 4'b 0010;
6'b 111111 :
    des_sbox[7:4] = 4'b 1100;
//default : 
//    des_sbox[7:4] = 4'b 1100;
endcase  

// SBOX 6
case(din[17:12])
6'b 000000 :
    des_sbox[11:8] = 4'b 1100;
6'b 000001 :
      des_sbox[11:8] = 4'b 1010;
6'b 000010 :
      des_sbox[11:8] = 4'b 0001;
6'b 000011 :
      des_sbox[11:8] = 4'b 1111;
6'b 000100 :
      des_sbox[11:8] = 4'b 1010;
6'b 000101 :
      des_sbox[11:8] = 4'b 0100;
6'b 000110 :
      des_sbox[11:8] = 4'b 1111;
6'b 000111 :
      des_sbox[11:8] = 4'b 0010;
6'b 001000 :
      des_sbox[11:8] = 4'b 1001;
6'b 001001 :
      des_sbox[11:8] = 4'b 0111;
6'b 001010 :
      des_sbox[11:8] = 4'b 0010;
6'b 001011 :
      des_sbox[11:8] = 4'b 1100;
6'b 001100 :
      des_sbox[11:8] = 4'b 0110;
6'b 001101 :
      des_sbox[11:8] = 4'b 1001;
6'b 001110 :
      des_sbox[11:8] = 4'b 1000;
6'b 001111 :
      des_sbox[11:8] = 4'b 0101;
6'b 010000 :
      des_sbox[11:8] = 4'b 0000;
6'b 010001 :
      des_sbox[11:8] = 4'b 0110;
6'b 010010 :
      des_sbox[11:8] = 4'b 1101;
6'b 010011 :
      des_sbox[11:8] = 4'b 0001;
6'b 010100 :
      des_sbox[11:8] = 4'b 0011;
6'b 010101 :
      des_sbox[11:8] = 4'b 1101;
6'b 010110 :
      des_sbox[11:8] = 4'b 0100;
6'b 010111 :
      des_sbox[11:8] = 4'b 1110;
6'b 011000 :
      des_sbox[11:8] = 4'b 1110;
6'b 011001 :
      des_sbox[11:8] = 4'b 0000;
6'b 011010 :
      des_sbox[11:8] = 4'b 0111;
6'b 011011 :
      des_sbox[11:8] = 4'b 1011;
6'b 011100 :
      des_sbox[11:8] = 4'b 0101;
6'b 011101 :
      des_sbox[11:8] = 4'b 0011;
6'b 011110 :
      des_sbox[11:8] = 4'b 1011;
6'b 011111 :
      des_sbox[11:8] = 4'b 1000;
6'b 100000 :
      des_sbox[11:8] = 4'b 1001;
6'b 100001 :
      des_sbox[11:8] = 4'b 0100;
6'b 100010 :
      des_sbox[11:8] = 4'b 1110;
6'b 100011 :
      des_sbox[11:8] = 4'b 0011;
6'b 100100 :
      des_sbox[11:8] = 4'b 1111;
6'b 100101 :
      des_sbox[11:8] = 4'b 0010;
6'b 100110 :
      des_sbox[11:8] = 4'b 0101;
6'b 100111 :
      des_sbox[11:8] = 4'b 1100;
6'b 101000 :
      des_sbox[11:8] = 4'b 0010;
6'b 101001 :
      des_sbox[11:8] = 4'b 1001;
6'b 101010 :
      des_sbox[11:8] = 4'b 1000;
6'b 101011 :
      des_sbox[11:8] = 4'b 0101;
6'b 101100 :
      des_sbox[11:8] = 4'b 1100;
6'b 101101 :
      des_sbox[11:8] = 4'b 1111;
6'b 101110 :
      des_sbox[11:8] = 4'b 0011;
6'b 101111 :
      des_sbox[11:8] = 4'b 1010;
6'b 110000 :
      des_sbox[11:8] = 4'b 0111;
6'b 110001 :
      des_sbox[11:8] = 4'b 1011;
6'b 110010 :
      des_sbox[11:8] = 4'b 0000;
6'b 110011 :
      des_sbox[11:8] = 4'b 1110;
6'b 110100 :
      des_sbox[11:8] = 4'b 0100;
6'b 110101 :
      des_sbox[11:8] = 4'b 0001;
6'b 110110 :
      des_sbox[11:8] = 4'b 1010;
6'b 110111 :
      des_sbox[11:8] = 4'b 0111;
6'b 111000 :
      des_sbox[11:8] = 4'b 0001;
6'b 111001 :
      des_sbox[11:8] = 4'b 0110;
6'b 111010 :
      des_sbox[11:8] = 4'b 1101;
6'b 111011 :
      des_sbox[11:8] = 4'b 0000;
6'b 111100 :
      des_sbox[11:8] = 4'b 1011;
6'b 111101 :
      des_sbox[11:8] = 4'b 1000;
6'b 111110 :
      des_sbox[11:8] = 4'b 0110;
6'b 111111 :
      des_sbox[11:8] = 4'b 1101;
//default : 
//      des_sbox[11:8] = 4'b 1101;
endcase

// SBOX 5
case(din[23:18])
6'b 000000 :
        des_sbox[15:12] = 4'b 0010;
6'b 000001 :
    des_sbox[15:12] = 4'b 1110;
6'b 000010 :
    des_sbox[15:12] = 4'b 1100;
6'b 000011 :
    des_sbox[15:12] = 4'b 1011;
6'b 000100 :
    des_sbox[15:12] = 4'b 0100;
6'b 000101 :
des_sbox[15:12] = 4'b 0010;
6'b 000110 :
des_sbox[15:12] = 4'b 0001;
6'b 000111 :
des_sbox[15:12] = 4'b 1100;
6'b 001000 :
des_sbox[15:12] = 4'b 0111;
6'b 001001 :
des_sbox[15:12] = 4'b 0100;
6'b 001010 :
des_sbox[15:12] = 4'b 1010;
6'b 001011 :
des_sbox[15:12] = 4'b 0111;
6'b 001100 :
des_sbox[15:12] = 4'b 1011;
6'b 001101 :
des_sbox[15:12] = 4'b 1101;
6'b 001110 :
des_sbox[15:12] = 4'b 0110;
6'b 001111 :
des_sbox[15:12] = 4'b 0001;
6'b 010000 :
des_sbox[15:12] = 4'b 1000;
6'b 010001 :
des_sbox[15:12] = 4'b 0101;
6'b 010010 :
des_sbox[15:12] = 4'b 0101;
6'b 010011 :
des_sbox[15:12] = 4'b 0000;
6'b 010100 :
des_sbox[15:12] = 4'b 0011;
6'b 010101 :
des_sbox[15:12] = 4'b 1111;
6'b 010110 :
des_sbox[15:12] = 4'b 1111;
6'b 010111 :
des_sbox[15:12] = 4'b 1010;
6'b 011000 :
des_sbox[15:12] = 4'b 1101;
6'b 011001 :
des_sbox[15:12] = 4'b 0011;
6'b 011010 :
des_sbox[15:12] = 4'b 0000;
6'b 011011 :
des_sbox[15:12] = 4'b 1001;
6'b 011100 :
des_sbox[15:12] = 4'b 1110;
6'b 011101 :
des_sbox[15:12] = 4'b 1000;
6'b 011110 :
des_sbox[15:12] = 4'b 1001;
6'b 011111 :
des_sbox[15:12] = 4'b 0110;
6'b 100000 :
des_sbox[15:12] = 4'b 0100;
6'b 100001 :
des_sbox[15:12] = 4'b 1011;
6'b 100010 :
des_sbox[15:12] = 4'b 0010;
6'b 100011 :
des_sbox[15:12] = 4'b 1000;
6'b 100100 :
des_sbox[15:12] = 4'b 0001;
6'b 100101 :
des_sbox[15:12] = 4'b 1100;
6'b 100110 :
des_sbox[15:12] = 4'b 1011;
6'b 100111 :
des_sbox[15:12] = 4'b 0111;
6'b 101000 :
des_sbox[15:12] = 4'b 1010;
6'b 101001 :
des_sbox[15:12] = 4'b 0001;
6'b 101010 :
des_sbox[15:12] = 4'b 1101;
6'b 101011 :
des_sbox[15:12] = 4'b 1110;
6'b 101100 :
des_sbox[15:12] = 4'b 0111;
6'b 101101 :
des_sbox[15:12] = 4'b 0010;
6'b 101110 :
des_sbox[15:12] = 4'b 1000;
6'b 101111 :
des_sbox[15:12] = 4'b 1101;
6'b 110000 :
des_sbox[15:12] = 4'b 1111;
6'b 110001 :
des_sbox[15:12] = 4'b 0110;
6'b 110010 :
des_sbox[15:12] = 4'b 1001;
6'b 110011 :
des_sbox[15:12] = 4'b 1111;
6'b 110100 :
des_sbox[15:12] = 4'b 1100;
6'b 110101 :
des_sbox[15:12] = 4'b 0000;
6'b 110110 :
des_sbox[15:12] = 4'b 0101;
6'b 110111 :
des_sbox[15:12] = 4'b 1001;
6'b 111000 :
des_sbox[15:12] = 4'b 0110;
6'b 111001 :
des_sbox[15:12] = 4'b 1010;
6'b 111010 :
des_sbox[15:12] = 4'b 0011;
6'b 111011 :
des_sbox[15:12] = 4'b 0100;
6'b 111100 :
des_sbox[15:12] = 4'b 0000;
6'b 111101 :
des_sbox[15:12] = 4'b 0101;
6'b 111110 :
des_sbox[15:12] = 4'b 1110;
6'b 111111 :
des_sbox[15:12] = 4'b 0011;
//default : 
//des_sbox[15:12] = 4'b 0011;
endcase  

// SBOX 4
case(din[29:24])
6'b 000000 :
begin
  des_sbox[19:16] = 4'b 0111;
end
6'b 000001 :
begin
  des_sbox[19:16] = 4'b 1101;
end
6'b 000010 :
begin
  des_sbox[19:16] = 4'b 1101;
end
6'b 000011 :
begin
  des_sbox[19:16] = 4'b 1000;
end
6'b 000100 :
begin
  des_sbox[19:16] = 4'b 1110;
end
6'b 000101 :
begin
  des_sbox[19:16] = 4'b 1011;
end
6'b 000110 :
begin
  des_sbox[19:16] = 4'b 0011;
end
6'b 000111 :
begin
  des_sbox[19:16] = 4'b 0101;
end
6'b 001000 :
begin
  des_sbox[19:16] = 4'b 0000;
end
6'b 001001 :
begin
  des_sbox[19:16] = 4'b 0110;
end
6'b 001010 :
begin
  des_sbox[19:16] = 4'b 0110;
end
6'b 001011 :
begin
  des_sbox[19:16] = 4'b 1111;
end
6'b 001100 :
begin
  des_sbox[19:16] = 4'b 1001;
end
6'b 001101 :
begin
  des_sbox[19:16] = 4'b 0000;
end
6'b 001110 :
begin
  des_sbox[19:16] = 4'b 1010;
end
6'b 001111 :
begin
  des_sbox[19:16] = 4'b 0011;
end
6'b 010000 :
begin
  des_sbox[19:16] = 4'b 0001;
end
6'b 010001 :
begin
  des_sbox[19:16] = 4'b 0100;
end
6'b 010010 :
begin
  des_sbox[19:16] = 4'b 0010;
end
6'b 010011 :
begin
  des_sbox[19:16] = 4'b 0111;
end
6'b 010100 :
begin
  des_sbox[19:16] = 4'b 1000;
end
6'b 010101 :
begin
  des_sbox[19:16] = 4'b 0010;
end
6'b 010110 :
begin
  des_sbox[19:16] = 4'b 0101;
end
6'b 010111 :
begin
  des_sbox[19:16] = 4'b 1100;
end
6'b 011000 :
begin
  des_sbox[19:16] = 4'b 1011;
end
6'b 011001 :
begin
  des_sbox[19:16] = 4'b 0001;
end
6'b 011010 :
begin
  des_sbox[19:16] = 4'b 1100;
end
6'b 011011 :
begin
  des_sbox[19:16] = 4'b 1010;
end
6'b 011100 :
begin
  des_sbox[19:16] = 4'b 0100;
end
6'b 011101 :
begin
  des_sbox[19:16] = 4'b 1110;
end
6'b 011110 :
begin
  des_sbox[19:16] = 4'b 1111;
end
6'b 011111 :
begin
  des_sbox[19:16] = 4'b 1001;
end
6'b 100000 :
begin
  des_sbox[19:16] = 4'b 1010;
end
6'b 100001 :
begin
  des_sbox[19:16] = 4'b 0011;
end
6'b 100010 :
begin
  des_sbox[19:16] = 4'b 0110;
end
6'b 100011 :
begin
  des_sbox[19:16] = 4'b 1111;
end
6'b 100100 :
begin
  des_sbox[19:16] = 4'b 1001;
end
6'b 100101 :
begin
  des_sbox[19:16] = 4'b 0000;
end
6'b 100110 :
begin
  des_sbox[19:16] = 4'b 0000;
end
6'b 100111 :
begin
  des_sbox[19:16] = 4'b 0110;
end
6'b 101000 :
begin
  des_sbox[19:16] = 4'b 1100;
end
6'b 101001 :
begin
  des_sbox[19:16] = 4'b 1010;
end
6'b 101010 :
begin
  des_sbox[19:16] = 4'b 1011;
end
6'b 101011 :
begin
  des_sbox[19:16] = 4'b 0001;
end
6'b 101100 :
begin
  des_sbox[19:16] = 4'b 0111;
end
6'b 101101 :
begin
  des_sbox[19:16] = 4'b 1101;
end
6'b 101110 :
begin
  des_sbox[19:16] = 4'b 1101;
end
6'b 101111 :
begin
  des_sbox[19:16] = 4'b 1000;
end
6'b 110000 :
begin
  des_sbox[19:16] = 4'b 1111;
end
6'b 110001 :
begin
  des_sbox[19:16] = 4'b 1001;
end
6'b 110010 :
begin
  des_sbox[19:16] = 4'b 0001;
end
6'b 110011 :
begin
  des_sbox[19:16] = 4'b 0100;
end
6'b 110100 :
begin
  des_sbox[19:16] = 4'b 0011;
end
6'b 110101 :
begin
  des_sbox[19:16] = 4'b 0101;
end
6'b 110110 :
begin
  des_sbox[19:16] = 4'b 1110;
end
6'b 110111 :
begin
  des_sbox[19:16] = 4'b 1011;
end
6'b 111000 :
begin
  des_sbox[19:16] = 4'b 0101;
end
6'b 111001 :
begin
  des_sbox[19:16] = 4'b 1100;
end
6'b 111010 :
begin
  des_sbox[19:16] = 4'b 0010;
end
6'b 111011 :
begin
  des_sbox[19:16] = 4'b 0111;
end
6'b 111100 :
begin
  des_sbox[19:16] = 4'b 1000;
end
6'b 111101 :
begin
  des_sbox[19:16] = 4'b 0010;
end
6'b 111110 :
begin
  des_sbox[19:16] = 4'b 0100;
end
6'b 111111 :
begin
  des_sbox[19:16] = 4'b 1110;
end
//default : 
//begin
//  des_sbox[19:16] = 4'b 1110;
//end
endcase
// SBOX 3
case(din[35:30])
6'b 000000 :
begin
  des_sbox[23:20] = 4'b 1010;
end
6'b 000001 :
begin
  des_sbox[23:20] = 4'b 1101;
end
6'b 000010 :
begin
  des_sbox[23:20] = 4'b 0000;
end
6'b 000011 :
begin
  des_sbox[23:20] = 4'b 0111;
end
6'b 000100 :
begin
  des_sbox[23:20] = 4'b 1001;
end
6'b 000101 :
begin
  des_sbox[23:20] = 4'b 0000;
end
6'b 000110 :
begin
  des_sbox[23:20] = 4'b 1110;
end
6'b 000111 :
begin
  des_sbox[23:20] = 4'b 1001;
end
6'b 001000 :
begin
  des_sbox[23:20] = 4'b 0110;
end
6'b 001001 :
begin
  des_sbox[23:20] = 4'b 0011;
end
6'b 001010 :
begin
  des_sbox[23:20] = 4'b 0011;
end
6'b 001011 :
begin
  des_sbox[23:20] = 4'b 0100;
end
6'b 001100 :
begin
  des_sbox[23:20] = 4'b 1111;
end
6'b 001101 :
begin
  des_sbox[23:20] = 4'b 0110;
end
6'b 001110 :
begin
  des_sbox[23:20] = 4'b 0101;
end
6'b 001111 :
begin
  des_sbox[23:20] = 4'b 1010;
end
6'b 010000 :
begin
  des_sbox[23:20] = 4'b 0001;
end
6'b 010001 :
begin
  des_sbox[23:20] = 4'b 0010;
end
6'b 010010 :
begin
  des_sbox[23:20] = 4'b 1101;
end
6'b 010011 :
begin
  des_sbox[23:20] = 4'b 1000;
end
6'b 010100 :
begin
  des_sbox[23:20] = 4'b 1100;
end
6'b 010101 :
begin
  des_sbox[23:20] = 4'b 0101;
end
6'b 010110 :
begin
  des_sbox[23:20] = 4'b 0111;
end
6'b 010111 :
begin
  des_sbox[23:20] = 4'b 1110;
end
6'b 011000 :
begin
  des_sbox[23:20] = 4'b 1011;
end
6'b 011001 :
begin
  des_sbox[23:20] = 4'b 1100;
end
6'b 011010 :
begin
  des_sbox[23:20] = 4'b 0100;
end
6'b 011011 :
begin
  des_sbox[23:20] = 4'b 1011;
end
6'b 011100 :
begin
  des_sbox[23:20] = 4'b 0010;
end
6'b 011101 :
begin
  des_sbox[23:20] = 4'b 1111;
end
6'b 011110 :
begin
  des_sbox[23:20] = 4'b 1000;
end
6'b 011111 :
begin
  des_sbox[23:20] = 4'b 0001;
end
6'b 100000 :
begin
  des_sbox[23:20] = 4'b 1101;
end
6'b 100001 :
begin
  des_sbox[23:20] = 4'b 0001;
end
6'b 100010 :
begin
  des_sbox[23:20] = 4'b 0110;
end
6'b 100011 :
begin
  des_sbox[23:20] = 4'b 1010;
end
6'b 100100 :
begin
  des_sbox[23:20] = 4'b 0100;
end
6'b 100101 :
begin
  des_sbox[23:20] = 4'b 1101;
end
6'b 100110 :
begin
  des_sbox[23:20] = 4'b 1001;
end
6'b 100111 :
begin
  des_sbox[23:20] = 4'b 0000;
end
6'b 101000 :
begin
  des_sbox[23:20] = 4'b 1000;
end
6'b 101001 :
begin
  des_sbox[23:20] = 4'b 0110;
end
6'b 101010 :
begin
  des_sbox[23:20] = 4'b 1111;
end
6'b 101011 :
begin
  des_sbox[23:20] = 4'b 1001;
end
6'b 101100 :
begin
  des_sbox[23:20] = 4'b 0011;
end
6'b 101101 :
begin
  des_sbox[23:20] = 4'b 1000;
end
6'b 101110 :
begin
  des_sbox[23:20] = 4'b 0000;
end
6'b 101111 :
begin
  des_sbox[23:20] = 4'b 0111;
end
6'b 110000 :
begin
  des_sbox[23:20] = 4'b 1011;
end
6'b 110001 :
begin
  des_sbox[23:20] = 4'b 0100;
end
6'b 110010 :
begin
  des_sbox[23:20] = 4'b 0001;
end
6'b 110011 :
begin
  des_sbox[23:20] = 4'b 1111;
end
6'b 110100 :
begin
  des_sbox[23:20] = 4'b 0010;
end
6'b 110101 :
begin
  des_sbox[23:20] = 4'b 1110;
end
6'b 110110 :
begin
  des_sbox[23:20] = 4'b 1100;
end
6'b 110111 :
begin
  des_sbox[23:20] = 4'b 0011;
end
6'b 111000 :
begin
  des_sbox[23:20] = 4'b 0101;
end
6'b 111001 :
begin
  des_sbox[23:20] = 4'b 1011;
end
6'b 111010 :
begin
  des_sbox[23:20] = 4'b 1010;
end
6'b 111011 :
begin
  des_sbox[23:20] = 4'b 0101;
end
6'b 111100 :
begin
  des_sbox[23:20] = 4'b 1110;
end
6'b 111101 :
begin
  des_sbox[23:20] = 4'b 0010;
end
6'b 111110 :
begin
  des_sbox[23:20] = 4'b 0111;
end
6'b 111111 :
begin
  des_sbox[23:20] = 4'b 1100;
end
//default : 
//begin
//  des_sbox[23:20] = 4'b 1100;
//end
endcase
// SBOX 2
case(din[41:36])
6'b 000000 :
begin
  des_sbox[27:24] = 4'b 1111;
end
6'b 000001 :
begin
  des_sbox[27:24] = 4'b 0011;
end
6'b 000010 :
begin
  des_sbox[27:24] = 4'b 0001;
end
6'b 000011 :
begin
  des_sbox[27:24] = 4'b 1101;
end
6'b 000100 :
begin
  des_sbox[27:24] = 4'b 1000;
end
6'b 000101 :
begin
  des_sbox[27:24] = 4'b 0100;
end
6'b 000110 :
begin
  des_sbox[27:24] = 4'b 1110;
end
6'b 000111 :
begin
  des_sbox[27:24] = 4'b 0111;
end
6'b 001000 :
begin
  des_sbox[27:24] = 4'b 0110;
end
6'b 001001 :
begin
  des_sbox[27:24] = 4'b 1111;
end
6'b 001010 :
begin
  des_sbox[27:24] = 4'b 1011;
end
6'b 001011 :
begin
  des_sbox[27:24] = 4'b 0010;
end
6'b 001100 :
begin
  des_sbox[27:24] = 4'b 0011;
end
6'b 001101 :
begin
  des_sbox[27:24] = 4'b 1000;
end
6'b 001110 :
begin
  des_sbox[27:24] = 4'b 0100;
end
6'b 001111 :
begin
  des_sbox[27:24] = 4'b 1110;
end
6'b 010000 :
begin
  des_sbox[27:24] = 4'b 1001;
end
6'b 010001 :
begin
  des_sbox[27:24] = 4'b 1100;
end
6'b 010010 :
begin
  des_sbox[27:24] = 4'b 0111;
end
6'b 010011 :
begin
  des_sbox[27:24] = 4'b 0000;
end
6'b 010100 :
begin
  des_sbox[27:24] = 4'b 0010;
end
6'b 010101 :
begin
  des_sbox[27:24] = 4'b 0001;
end
6'b 010110 :
begin
  des_sbox[27:24] = 4'b 1101;
end
6'b 010111 :
begin
  des_sbox[27:24] = 4'b 1010;
end
6'b 011000 :
begin
  des_sbox[27:24] = 4'b 1100;
end
6'b 011001 :
begin
  des_sbox[27:24] = 4'b 0110;
end
6'b 011010 :
begin
  des_sbox[27:24] = 4'b 0000;
end
6'b 011011 :
begin
  des_sbox[27:24] = 4'b 1001;
end
6'b 011100 :
begin
  des_sbox[27:24] = 4'b 0101;
end
6'b 011101 :
begin
  des_sbox[27:24] = 4'b 1011;
end
6'b 011110 :
begin
  des_sbox[27:24] = 4'b 1010;
end
6'b 011111 :
begin
  des_sbox[27:24] = 4'b 0101;
end
6'b 100000 :
begin
  des_sbox[27:24] = 4'b 0000;
end
6'b 100001 :
begin
  des_sbox[27:24] = 4'b 1101;
end
6'b 100010 :
begin
  des_sbox[27:24] = 4'b 1110;
end
6'b 100011 :
begin
  des_sbox[27:24] = 4'b 1000;
end
6'b 100100 :
begin
  des_sbox[27:24] = 4'b 0111;
end
6'b 100101 :
begin
  des_sbox[27:24] = 4'b 1010;
end
6'b 100110 :
begin
  des_sbox[27:24] = 4'b 1011;
end
6'b 100111 :
begin
  des_sbox[27:24] = 4'b 0001;
end
6'b 101000 :
begin
  des_sbox[27:24] = 4'b 1010;
end
6'b 101001 :
begin
  des_sbox[27:24] = 4'b 0011;
end
6'b 101010 :
begin
  des_sbox[27:24] = 4'b 0100;
end
6'b 101011 :
begin
  des_sbox[27:24] = 4'b 1111;
end
6'b 101100 :
begin
  des_sbox[27:24] = 4'b 1101;
end
6'b 101101 :
begin
  des_sbox[27:24] = 4'b 0100;
end
6'b 101110 :
begin
  des_sbox[27:24] = 4'b 0001;
end
6'b 101111 :
begin
  des_sbox[27:24] = 4'b 0010;
end
6'b 110000 :
begin
  des_sbox[27:24] = 4'b 0101;
end
6'b 110001 :
begin
  des_sbox[27:24] = 4'b 1011;
end
6'b 110010 :
begin
  des_sbox[27:24] = 4'b 1000;
end
6'b 110011 :
begin
  des_sbox[27:24] = 4'b 0110;
end
6'b 110100 :
begin
  des_sbox[27:24] = 4'b 1100;
end
6'b 110101 :
begin
  des_sbox[27:24] = 4'b 0111;
end
6'b 110110 :
begin
  des_sbox[27:24] = 4'b 0110;
end
6'b 110111 :
begin
  des_sbox[27:24] = 4'b 1100;
end
6'b 111000 :
begin
  des_sbox[27:24] = 4'b 1001;
end
6'b 111001 :
begin
  des_sbox[27:24] = 4'b 0000;
end
6'b 111010 :
begin
  des_sbox[27:24] = 4'b 0011;
end
6'b 111011 :
begin
  des_sbox[27:24] = 4'b 0101;
end
6'b 111100 :
begin
  des_sbox[27:24] = 4'b 0010;
end
6'b 111101 :
begin
  des_sbox[27:24] = 4'b 1110;
end
6'b 111110 :
begin
  des_sbox[27:24] = 4'b 1111;
end
6'b 111111 :
begin
  des_sbox[27:24] = 4'b 1001;
end
//default : 
//begin
//  des_sbox[27:24] = 4'b 1001;
//end
endcase
// SBOX 1
case(din[47:42])
6'b 000000 :
begin
  des_sbox[31:28] = 4'b 1110;
end
6'b 000001 :
begin
  des_sbox[31:28] = 4'b 0000;
end
6'b 000010 :
begin
  des_sbox[31:28] = 4'b 0100;
end
6'b 000011 :
begin
  des_sbox[31:28] = 4'b 1111;
end
6'b 000100 :
begin
  des_sbox[31:28] = 4'b 1101;
end
6'b 000101 :
begin
  des_sbox[31:28] = 4'b 0111;
end
6'b 000110 :
begin
  des_sbox[31:28] = 4'b 0001;
end
6'b 000111 :
begin
  des_sbox[31:28] = 4'b 0100;
end
6'b 001000 :
begin
  des_sbox[31:28] = 4'b 0010;
end
6'b 001001 :
begin
  des_sbox[31:28] = 4'b 1110;
end
6'b 001010 :
begin
  des_sbox[31:28] = 4'b 1111;
end
6'b 001011 :
begin
  des_sbox[31:28] = 4'b 0010;
end
6'b 001100 :
begin
  des_sbox[31:28] = 4'b 1011;
end
6'b 001101 :
begin
  des_sbox[31:28] = 4'b 1101;
end
6'b 001110 :
begin
  des_sbox[31:28] = 4'b 1000;
end
6'b 001111 :
begin
  des_sbox[31:28] = 4'b 0001;
end
6'b 010000 :
begin
  des_sbox[31:28] = 4'b 0011;
end
6'b 010001 :
begin
  des_sbox[31:28] = 4'b 1010;
end
6'b 010010 :
begin
  des_sbox[31:28] = 4'b 1010;
end
6'b 010011 :
begin
  des_sbox[31:28] = 4'b 0110;
end
6'b 010100 :
begin
  des_sbox[31:28] = 4'b 0110;
end
6'b 010101 :
begin
  des_sbox[31:28] = 4'b 1100;
end
6'b 010110 :
begin
  des_sbox[31:28] = 4'b 1100;
end
6'b 010111 :
begin
  des_sbox[31:28] = 4'b 1011;
end
6'b 011000 :
begin
  des_sbox[31:28] = 4'b 0101;
end
6'b 011001 :
begin
  des_sbox[31:28] = 4'b 1001;
end
6'b 011010 :
begin
  des_sbox[31:28] = 4'b 1001;
end
6'b 011011 :
begin
  des_sbox[31:28] = 4'b 0101;
end
6'b 011100 :
begin
  des_sbox[31:28] = 4'b 0000;
end
6'b 011101 :
begin
  des_sbox[31:28] = 4'b 0011;
end
6'b 011110 :
begin
  des_sbox[31:28] = 4'b 0111;
end
6'b 011111 :
begin
  des_sbox[31:28] = 4'b 1000;
end
6'b 100000 :
begin
  des_sbox[31:28] = 4'b 0100;
end
6'b 100001 :
begin
  des_sbox[31:28] = 4'b 1111;
end
6'b 100010 :
begin
  des_sbox[31:28] = 4'b 0001;
end
6'b 100011 :
begin
  des_sbox[31:28] = 4'b 1100;
end
6'b 100100 :
begin
  des_sbox[31:28] = 4'b 1110;
end
6'b 100101 :
begin
  des_sbox[31:28] = 4'b 1000;
end
6'b 100110 :
begin
  des_sbox[31:28] = 4'b 1000;
end
6'b 100111 :
begin
  des_sbox[31:28] = 4'b 0010;
end
6'b 101000 :
begin
  des_sbox[31:28] = 4'b 1101;
end
6'b 101001 :
begin
  des_sbox[31:28] = 4'b 0100;
end
6'b 101010 :
begin
  des_sbox[31:28] = 4'b 0110;
end
6'b 101011 :
begin
  des_sbox[31:28] = 4'b 1001;
end
6'b 101100 :
begin
  des_sbox[31:28] = 4'b 0010;
end
6'b 101101 :
begin
  des_sbox[31:28] = 4'b 0001;
end
6'b 101110 :
begin
  des_sbox[31:28] = 4'b 1011;
end
6'b 101111 :
begin
  des_sbox[31:28] = 4'b 0111;
end
6'b 110000 :
begin
  des_sbox[31:28] = 4'b 1111;
end
6'b 110001 :
begin
  des_sbox[31:28] = 4'b 0101;
end
6'b 110010 :
begin
  des_sbox[31:28] = 4'b 1100;
end
6'b 110011 :
begin
  des_sbox[31:28] = 4'b 1011;
end
6'b 110100 :
begin
  des_sbox[31:28] = 4'b 1001;
end
6'b 110101 :
begin
  des_sbox[31:28] = 4'b 0011;
end
6'b 110110 :
begin
  des_sbox[31:28] = 4'b 0111;
end
6'b 110111 :
begin
  des_sbox[31:28] = 4'b 1110;
end
6'b 111000 :
begin
  des_sbox[31:28] = 4'b 0011;
end
6'b 111001 :
begin
  des_sbox[31:28] = 4'b 1010;
end
6'b 111010 :
begin
  des_sbox[31:28] = 4'b 1010;
end
6'b 111011 :
begin
  des_sbox[31:28] = 4'b 0000;
end
6'b 111100 :
begin
  des_sbox[31:28] = 4'b 0101;
end
6'b 111101 :
begin
  des_sbox[31:28] = 4'b 0110;
end
6'b 111110 :
begin
  des_sbox[31:28] = 4'b 0000;
end
6'b 111111 :
begin
  des_sbox[31:28] = 4'b 1101;
end
//default : 
//begin
//  des_sbox[31:28] = 4'b 1101;
//end
endcase
end
endfunction
//return val;
//end des_sbox------------------------------------------------------------

//-----------------------------function des_pbox--------------------------
// P-Box Permutation
//function des_pbox(din   :std_logic_vector (31 downto 0))
//return std_logic_vector is
//variable val 	:std_logic_vector (31 downto 0);
//begin
function [31:0] des_pbox;
input [31:0] din;
    des_pbox = {din[32 - 16],din[32 -  7],din[32 - 20],din[32 - 21],
                din[32 - 29],din[32 - 12],din[32 - 28],din[32 - 17],
                din[32 -  1],din[32 - 15],din[32 - 23],din[32 - 26],
                din[32 -  5],din[32 - 18],din[32 - 31],din[32 - 10],
                din[32 -  2],din[32 -  8],din[32 - 24],din[32 - 14],
                din[32 - 32],din[32 - 27],din[32 -  3],din[32 -  9],
                din[32 - 19],din[32 - 13],din[32 - 30],din[32 -  6],
                din[32 - 22],din[32 - 11],din[32 -  4],din[32 - 25]
               };
endfunction
//end des_pbox------------------------------------------------------------


//-----------------------------function des_keyshift----------------------
// encrypt : key shift num list: 
// round_num:  1,2,3,4,5, 6, 7, 8, 9, 10,11,12,13,14,15,16
// shift_num:  1,2,4,6,8,10, 12,14,15,17,19,21,23,25,27,28 
// decrypt: key shift_num list:	 
//------------------------------------------------------------------------
// Key Shift
//log_shifter 040204
//function des_keyshift (din	:std_logic_vector (55 downto 0);
//n 	:std_logic_vector (4 downto 0))
//return std_logic_vector is
//variable val	:std_logic_vector (55 downto 0);
//begin
function [55:0]  des_keyshift;
input    [55:0]  din;
input    [4:0]   n;
reg      [55:0]  shift_1; 
reg      [55:0]  shift_2;
reg      [55:0]  shift_4;
reg      [55:0]  shift_8;

begin	
    if (n[0])
        shift_1 = {din[54:28], din[55], din[26:0], din[27]};
    else
        shift_1 = din; 
        if (n[1])
            shift_2 = {shift_1[53:28], shift_1[55:54], shift_1[25:0], shift_1[27:26]};
        else
            shift_2 = shift_1;	
            if (n[2])
                shift_4 = {shift_2[51:28], shift_2[55:52], shift_2[23:0], shift_2[27:24]};
            else
                shift_4 = shift_2;
                if (n[3])
                    shift_8 = {shift_4[47:28], shift_4[55:48], shift_4[19:0], shift_4[27:20]};
                else
                    shift_8 = shift_4;	
                    if (n[4])
                        des_keyshift = {shift_8[39:28], shift_8[55:40], shift_8[11:0], shift_8[27:12]};
                    else
                        des_keyshift = shift_8;
end
endfunction
//end des_keyshift--------------------------------------------------------

endmodule


