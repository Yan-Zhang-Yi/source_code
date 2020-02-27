// NRZI code Editor: Amiss
module en_nrzi(clk, rst, data_in, DP, DM, en_nrzi);

input clk, rst, data_in, en_nrzi;

output DP, DM;

reg en_data_DP, DP, DM;
reg data_bf;

/*

assign DM = (!rst) ? 1'b1 : ~DP;


always @(data_in, en_data_DP)
 begin
      DP <= ~(data_in ^ en_data_DP); 
     // DM <= (data_in ^ en_data_DP); 
 end

always@(posedge clk, negedge rst)
 begin
   if (!rst) 
    begin  
     en_data_DP <= 1'b1;
     //DM <= 1'b1;
    end 
  else
    begin
    en_data_DP  <= DP;
    end
end
*/
always @(posedge clk, negedge rst)
 begin
  if(!rst)
    data_bf <= 0;
  else
    data_bf <= data_in;
 end


//================= NEW ======================
always @(posedge clk, negedge rst)
 begin
   if(!rst)
      begin
        DP = 1'b1;
        DM = 1'b1;
      end  
        else 
          begin
           if(en_nrzi)
            begin  
              DP = ~(data_in ^ en_data_DP); 
              DM = ~DP;
            end
           else
             begin
			   DP = 1'b1;
               DM = 1'b1;
             end
          end
 end
 
 always@(posedge clk, negedge rst)
 begin
    en_data_DP  <= DP;
 end
 

endmodule


