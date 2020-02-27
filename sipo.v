// Serial In Parallel  Out
module sipo(clk, rst, data_in, data_out, en_sipo, valid);

input clk, rst, valid;
input data_in, en_sipo;
output [7:0]data_out;

reg [7:0]data_s;
reg [3:0] cnt;
reg [7:0] data_out;
//assign data_out = (cnt == 4'd8) ? (data_s) : data_out;


always @(posedge clk)
 begin
   if(!rst)
     begin
      data_s <= 8'b0;
      cnt <= 4'd0;
     end
   else
     begin
		if(en_sipo) 
		 begin
		   if(valid)
			  begin
          data_s <= data_s >> 1;
          data_s[7] <= data_in;
        if(cnt == 4'd8)
				  begin
						cnt <= 4'b1;
						data_out <= data_s;
					end	
        else
			begin
           cnt <= cnt + 1;
             
			end
       end
      end
      else
		begin
         data_s <= 8'b0;
          cnt <= 4'd0;
        end
   end
 end

 endmodule

