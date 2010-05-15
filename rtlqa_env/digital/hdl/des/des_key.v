//////////////////////////                           
//                                                   
//copyright 2007, HHIC                               
//all right reserved                                 
//                                                   
//project name: 2605U4                               
//filename    : des_key.v                            
//author      : Jerry                                
//data        : 2007/08/03                           
//version     : 0.1                                  
//                                                   
//module name : des key register module              
//                                                   
//modification history                               
//---------------------------------                  
//&Log&                                              
//                                                   
//////////////////////////                           
                                                     
                                                     
module        des_key (
                       hresetn ,
                       clrptr, 
                       hclk ,
                       wr ,
                       data, 
                       q1_all, 
                       q2_all, 
                       q3_all 
                      );  

input                  hresetn ;
input                  clrptr ;
input                  hclk ;
input                  wr ;
input    [31:0]        data ;	  
output   [63:0]        q1_all;					   
output   [63:0]        q2_all;
output   [63:0]        q3_all;

reg      [31:0]        fifo_mem    [5:0];
                       
reg      [2:0]         wr_ptr;
reg      [2:0]         ptr;
integer                loop_index;

always @ (posedge hclk or negedge hresetn)
begin
    if (hresetn==1'b0)
        begin
            wr_ptr[2:0] <= #1 3'b000;
            ptr   [2:0] <= #1 3'b000;
        end
    else if (clrptr == 1'b0)
        begin                      
            wr_ptr[2:0] <= #1 3'b000; 
            ptr   [2:0] <= #1 3'b000; 
        end                    
    else                                             
        begin                                        
            if ((wr == 1'b1) && (ptr[2:0] < 3'b110))        
                begin                                
                    if (wr_ptr[2:0] < 3'b101)           
                        wr_ptr[2:0] <= #1 wr_ptr[2:0] + 1'b1;  
                    else if (wr_ptr[2:0] == 3'b101)     
                        wr_ptr[2:0] <= #1 3'b000;       
                    ptr[2:0] <= #1 ptr[2:0] + 1'b1;            
                end                                  
        end                                          
end

always @ (posedge hclk or negedge hresetn)
begin
    if (hresetn==1'b0)
        for (loop_index=0;loop_index<6;loop_index=loop_index+1)
            fifo_mem[loop_index] <= #1 32'b0;   
    else if (wr == 1'b1)
        fifo_mem[wr_ptr[2:0]] <= #1 {data[31:25],1'b0,data[23:17],1'b0,data[15:9],1'b0,data[7:1],1'b0};                                     
end

assign q1_all[63:0] = {fifo_mem[1],fifo_mem[0]};
assign q2_all[63:0] = {fifo_mem[3],fifo_mem[2]};
assign q3_all[63:0] = {fifo_mem[5],fifo_mem[4]};

endmodule
