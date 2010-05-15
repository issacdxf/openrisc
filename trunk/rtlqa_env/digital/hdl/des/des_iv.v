//////////////////////////                   
//                                           
//copyright 2007, HHIC                       
//all right reserved                         
//                                           
//project name: 2605U4                       
//filename    : des_iv.v                     
//author      : Jerry                        
//data        : 2007/08/03                   
//version     : 0.1                          
//                                           
//module name : des iv register module       
//                                           
//modification history                       
//---------------------------------          
//&Log&                                      
//                                           
//////////////////////////                   
                                             
                                             
module        des_iv (
                      hclk,
                      POR,
                      hresetn,
                      clrptr, 
                      wr, 
                      deswr,
                      data, 
                      data_all, 
                      q_all 
                     );

input                 hclk ;
input                 POR;
input                 hresetn ;
input                 clrptr ;
input                 wr ;		   
input                 deswr;
input    [31:0]       data ;	
input    [63:0]       data_all;
output   [63:0]       q_all;

wire                  hclk ;
wire                  POR;
wire                  hresetn ;
wire                  clrptr ;
wire                  wr ;     
wire                  deswr;
wire     [31:0]       data ;   
wire     [63:0]       data_all;

reg      [31:0]       fifo_mem     [1:0]; 
reg                   wr_ptr;
reg      [1:0]        ptr;

always @(posedge hclk or negedge POR)                     
begin                                           
    if (POR == 1'b0)
        begin
            fifo_mem[1] <= #1 32'b0 ;
            fifo_mem[0] <= #1 32'b0 ;
        end
    else 
        if (wr == 1'b1)                             
            fifo_mem[wr_ptr] <= #1 data[31:0];       
        else if (deswr == 1'b1)                     
            begin                                   
                fifo_mem[1] <= #1 data_all[63:32];  
                fifo_mem[0] <= #1 data_all[31:0];  
            end                                     
end                                             

always @ (posedge hclk or negedge hresetn)
begin
    if (hresetn == 1'b0)
        begin
            wr_ptr      <= #1 1'b0;
            ptr   [1:0] <= #1 2'b00; 
        end
    else if (clrptr == 1'b0)
        begin
            wr_ptr      <= #1 1'b0; 
            ptr   [1:0] <= #1 2'b00;
        end
    else
        begin
            if (wr == 1'b1 && ptr[1:0] < 2'b10) 
                begin
                    ptr[1:0] <= #1 ptr[1:0] + 1'b1;
                    if (wr_ptr == 1'b0) 
                        wr_ptr <= #1 1'b1;
                    else  
                        wr_ptr <= #1 1'b0;
                end
        end								
end	  

assign q_all[63:0] = {fifo_mem[1],fifo_mem[0]};                                                                                            
endmodule
