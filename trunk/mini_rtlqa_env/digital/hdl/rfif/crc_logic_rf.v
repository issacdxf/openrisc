`timescale 1ns/10ps


module crc_logic_rf(
         clk_i      ,
         nrst_i     ,
         syn_rst_i  ,
         en_i       ,
         din_i      ,
         dout_o              
         );

input         clk_i     ;
input         nrst_i    ;
input         syn_rst_i ;
input         en_i      ;
input  [ 7:0] din_i     ;
output [15:0] dout_o    ;


reg  [15:0] crc_reg;
reg  [15:0] crc_data;
reg  [ 7:0] temp8_0;
reg  [ 7:0] temp8_1;

wire [15:0] dout_o;

assign  dout_o = ~crc_reg;

always @ (posedge clk_i or negedge nrst_i)
  begin
  	if (~nrst_i)
  	  crc_reg <= 16'hffff;
  	else if (syn_rst_i)
  	  crc_reg <= 16'hffff;
  	else if (en_i)
      crc_reg <= crc_data;
  end


always @ (din_i or crc_reg or temp8_0 or temp8_1)
  begin
  	temp8_0  = crc_reg[7:0] ^ din_i;
  	temp8_1  = temp8_0 ^ {temp8_0[3:0],4'h0};
  	crc_data = {8'h00,crc_reg[15:8]} ^
  	            {temp8_1,8'h00} ^
  	            {5'b00000,temp8_1,3'b000} ^
  	            {12'h000,temp8_1[7:4]};
  end


endmodule       