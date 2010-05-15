//////////////////////////                       
//                                               
//copyright 2007, HHIC                           
//all right reserved                             
//                                               
//project name: 2605U4                           
//filename    : des_cop.v                        
//author      : Jerry                            
//data        : 2007/08/03                       
//version     : 0.1                              
//                                               
//module name : des coprocessor module           
//                                               
//modification history                           
//---------------------------------              
//&Log&                                          
//                                               
//////////////////////////                       
                                                 
                                                 
module         des_cop ( 
                        hclk,
                        POR,
                        hresetn,
                        encrypt_whole,
                        dt_sel,
                        key23_sel,
                        edr,
                        mode_sel,
                        iv_sel,
                        iv,
                        key1,
                        key2,
                        key3,
                        din,
                        din_valid_whole,
                        dout,
                        dout_valid 
                       );

input                   hclk ;
input                   POR;
input                   hresetn ;
input                   encrypt_whole ;
input                   dt_sel ;
input                   key23_sel ;
input    [1:0]          edr ;
input                   mode_sel ;
input                   iv_sel ;
input    [63:0]         iv ;
input    [63:0]         key1 ;
input    [63:0]         key2 ;
input    [63:0]         key3 ;
input    [63:0]         din ;
input                   din_valid_whole ;

output   [63:0]         dout ;
output                  dout_valid ;

wire                    hclk ;
wire                    POR;
wire                    hresetn ;
wire                    encrypt_whole ;
wire                    dt_sel ;
wire                    key23_sel ;
wire     [1:0]          edr ;
wire                    mode_sel ;
wire                    iv_sel ;
wire     [63:0]         iv ;
wire     [63:0]         key1 ;
wire     [63:0]         key2 ;
wire     [63:0]         key3 ;
wire     [63:0]         din ;
wire                    din_valid_whole ;


wire     [63:0]         dout ;
wire                    dout_valid ;

wire     [63:0]         din_xor_iv;
wire     [3:0]          round;
wire     [63:0]         dout_eins;         
wire     [3:0]          last_round;				 
wire                    cbc_iv_flag;       
wire                    cbc_iv_en_flag;    
wire                    cbc_iv_de_flag;    

reg      [1:0]          flag;
reg      [63:0]         din_eins;
reg                     din_valid_eins;
reg                     encrypt_eins;
reg      [63:0]         key_eins;

wire                    dout_valid_eins;               

tiny_des       des_unit(
                        .hclk             (hclk),
                        .POR              (POR),
                        .hresetn          (hresetn),
                        .encrypt          (encrypt_eins),
                        .edr              (edr),
                        .key_in           (key_eins),
                        .din              (din_eins),
                        .din_valid        (din_valid_eins),
                        .round            (round),
                        .dout             (dout_eins),
                        .dout_valid       (dout_valid_eins)
                       );

assign cbc_iv_flag    =   mode_sel & iv_sel;
assign cbc_iv_en_flag =   cbc_iv_flag & (~encrypt_whole);
assign din_xor_iv     =   din^({64{cbc_iv_en_flag}} & iv); 
assign cbc_iv_de_flag =   cbc_iv_flag & encrypt_whole;
assign dout           =   dout_eins^({64{cbc_iv_de_flag}} & iv);

always @(posedge hclk or negedge hresetn )									
begin
    if (hresetn==1'b0)
        flag[1:0] <= #1 2'b00;
    else if (din_valid_whole==1'b1)
        flag[1:0] <= #1 2'b11;
    else if ((round[3:0]==last_round[3:0]) && (flag[1:0]!=2'b00))
        if(dt_sel==1'b1)
            flag[1:0] <= #1 flag[1:0] - 1'b1;
        else
            flag[1:0] <= #1 2'b00;				
end
		
assign last_round[3:0]   =   {2'b00, edr[1:0]} - 1'b1;				

always @(posedge hclk or negedge hresetn)
begin
    if (hresetn==1'b0)
        din_valid_eins <= #1 1'b0;
    else if ((round[3:0]==last_round[3:0]) && dt_sel==1'b1 && flag[1]==1'b1) 
        din_valid_eins <= #1 1'b1;
    else
        din_valid_eins <= #1 din_valid_whole;
end

assign dout_valid=(flag==2'b00)?dout_valid_eins:0;

always @(*)
begin
    case(flag[1:0])
    2'b11:
        begin
            encrypt_eins = encrypt_whole;
            din_eins[63:0] = din_xor_iv[63:0];
            if (encrypt_whole==1'b1 && dt_sel==1'b1 && key23_sel==1'b1) //encrypt des as same as tdes.
                key_eins[63:0] = key3[63:0];
            else           
                key_eins[63:0] = key1[63:0];
        end
    2'b10:
        begin	
            key_eins[63:0] =  key2[63:0];
            encrypt_eins   =  ~encrypt_whole;
            din_eins[63:0] =  dout_eins[63:0];
        end
    2'b01:
        begin
            encrypt_eins   =  encrypt_whole;
            din_eins[63:0] =  dout_eins[63:0];
            if (encrypt_whole==1'b0 && key23_sel==1'b1) //encrypt
                key_eins[63:0]   =  key3[63:0];
            else              
                key_eins[63:0]   =  key1[63:0];
        end
    default:
        begin
            encrypt_eins   =  encrypt_whole;
            key_eins[63:0] =  key1[63:0];
            din_eins[63:0] =  dout_eins[63:0];
        end
    endcase
end

endmodule
