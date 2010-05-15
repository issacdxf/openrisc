//////////////////////////                     
//                                             
//copyright 2007, HHIC                         
//all right reserved                           
//                                             
//project name: 2605U4                         
//filename    : des_dat.v                      
//author      : Jerry                          
//data        : 2007/08/03                     
//version     : 0.1                            
//                                             
//module name : des data register module       
//                                             
//modification history                         
//---------------------------------            
//&Log&                                        
//                                             
//////////////////////////                     
                                               
                                               
module      des_dat (
                     POR,
                     hresetn ,
                     clrptr, 
                     hclk ,
                     rd ,
                     wr , 
                     deswr,
                     data , 
                     data_all,
                     full_pulse , 
                     q, 
                     q_all 
                    );

input                POR;
input                hresetn ;
input                clrptr ;
input                hclk ;
input                rd ;
input                wr ;		   
input                deswr;
input   [31:0]       data ;	
input   [63:0]       data_all;

output               full_pulse ;
output  [31:0]       q ;
output  [63:0]       q_all;

reg     [31:0]       fifo_mem [1:0]; 
reg                  wr_ptr;
reg                  rd_ptr;
reg     [1:0]        ptr;
reg                  full;
reg                  full_delay;
reg                  full_pulse;

always @(posedge hclk or negedge POR )                     
begin        
    if ( POR == 1'b0 )
    begin
        fifo_mem[1] <= #1 32'b0;
        fifo_mem[0] <= #1 32'b0;
    end                                   
    else if (wr == 1'b1)                             
        fifo_mem[wr_ptr] <= #1 data[31:0] ;      
    else if (deswr == 1'b1)                     
        begin                                   
            fifo_mem[1] <= #1 data_all[63:32];  
            fifo_mem[0] <= #1 data_all[31: 0];  
        end	                                    
end                                             

//reset here!	
always @ (posedge hclk or negedge hresetn)
begin
    if ( hresetn == 1'b0 )
        begin
            wr_ptr   <= #1 1'b0;
            rd_ptr   <= #1 1'b0;
            ptr[1:0] <= #1 2'b0;
        end
    else if ( clrptr == 1'b0 )
        begin                     
            wr_ptr   <= #1 1'b0;  
            rd_ptr   <= #1 1'b0;  
            ptr[1:0] <= #1 2'b0; 
        end                               
    else
        begin
            if ((wr == 1'b1) && (ptr[1:0] < 2'b10)) 
                begin
                    wr_ptr   <= #1 wr_ptr   + 1'b1;
                    ptr[1:0] <= #1 ptr[1:0] + 1'b1;
                end
            else if ((rd == 1'b1) && (ptr[1:0] > 2'b0)) 
                begin
                    rd_ptr   <= #1 rd_ptr + 1'b1;
                    ptr[1:0] <= #1 ptr[1:0] - 1'b1;
                end
        end	
end	

always @ (posedge hclk or negedge hresetn)
begin
    if ( hresetn == 1'b0 )
        full  <= #1 1'b0;
    else if ( clrptr == 1'b0 )
        full  <= #1 1'b0;
    else if (ptr[1:0] == 2'b10)
        full <= #1 1'b1;
    else
        full <= #1 1'b0;
end  

always @ (posedge hclk or negedge hresetn)	
begin
   if ( hresetn == 1'b0 )
        full_delay <= #1 1'b0;
   else
        full_delay <= #1 full;
end

always @ (posedge hclk or negedge hresetn)
begin
   if ( hresetn == 1'b0 )
        full_pulse <= #1 1'b0;
   else
        full_pulse <= #1 full &&(!full_delay);
end

assign q[31:0]     = (rd == 1'b1) ? fifo_mem[rd_ptr] : {32{1'b0}}; 
assign q_all[63:0] = {fifo_mem[1],fifo_mem[0]}; 

endmodule
