// bit_stuffing module  Editor: Amiss
module bit_stuffing(
input clk, 
input rst, 
input data_in,
input en_data,
input [4:0]crc5_in,
input [15:0]crc16_in,
output reg data_out
);

//reg data_out;
reg [2:0]cnt_6_high;
reg en_ok;
reg [1:0] state	;
reg reg_store_1,reg_store_out_1;
//wire start;



//assign start = clk & en_ok;

//always@(posedge clk, negedge rst)

/*assign data_out = (!en_ok && state == 0) ? 
                  data_in:(!en_ok && state == 1) ? 
                  reg_store_out_1:0;
*/
/*begin
	if(!rst)begin
		cnt_6_high	<=	3'd0;
		state	<=	2'd0;
		en_ok	<=	1'b0;
		
		reg_store_1		<=	1'b0;
		reg_store_out_1	<=	1'b0;
		end
	else 
	begin 
			if(!en_ok && state == 0) 
	           data_out <= data_in;
	        else if(!en_ok && state == 1)
			   data_out <= reg_store_1;
			else data_out <= 0;
    end
end	*/	
				  
always@(posedge clk,negedge rst)
begin
	if(!rst)
	 begin
		cnt_6_high	<=	3'd0;
		state	<=	2'd0;
		en_ok	<=	1'b0;		
		reg_store_1	<=	1'b0;
		reg_store_out_1	<=	1'b0;
		//data_out <= 1'b1;
	 end 
	  else	//rst = 1
	  begin 
	   if(en_data)
	    begin
		 if(data_in) 
		   begin
		     cnt_6_high <= (cnt_6_high == 3'd6) ? 0 : cnt_6_high + 1'b1;
			/*if (cnt_6_high == 3'd5) 			   
			   cnt_6_high <= 3'd0;*/
		   end	
		 else	/*if(	(cnt_6_high	==	3'd6) || (data_in	==	1'b0)	)*/
		 begin
			cnt_6_high	<=	3'd0;
		 end
		 
		 if(!en_ok && state == 0) 
	           data_out <= data_in;
	        else if(!en_ok && state == 1)
			   data_out <= reg_store_1;
			else data_out <= 0;
		
		case(state)
			0:begin
				if(cnt_6_high	==	3'd5)begin
					en_ok	<=	1;
					state	<=	1;
					reg_store_1	<=	data_in;
				end
			end
			
			1:begin
				if(cnt_6_high	==	3'd5)
				  begin
					en_ok	<=	1;
					state	<=	2;					
					reg_store_1	<=	data_in;
					reg_store_out_1	<=	reg_store_1;
				  end	
				else	
				  begin					
					en_ok	<=	0;
					state	<=	1;					
					reg_store_1	<=	data_in;
					reg_store_out_1	<=	reg_store_1;
				  end
			end
			
			2:begin
				if(cnt_6_high	==	3'd5)
				 begin
					en_ok	<=	1;
					state	<=	2;					
					reg_store_1	<=	data_in;
					reg_store_out_1	<=	reg_store_1;
				 end	
				else	
				  begin					
					en_ok	<=	0;
					state	<=	1;					
					reg_store_1	<=	data_in;
					reg_store_out_1	<=	reg_store_1;
				  end
		 	 end
		endcase
	end
	else
	  begin 
		cnt_6_high	<=	3'd0;
		state	<=	2'd0;
		en_ok	<=	1'b0;		
		reg_store_1	<=	1'b0;
		reg_store_out_1	<=	1'b0;
		data_out <= 1'b1;
		end
		
 end
end
 
endmodule
