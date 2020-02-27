// control all module data   Editor : Amiss
module controller(clk, rst, en_stuf, en_nrzi, en_unstuf, en_sipo);

input clk, rst;
output en_stuf, en_nrzi, en_unstuf, en_sipo;

reg [3:0] state;
reg [3:0] valid;

wire en_stuf     = valid[0];
wire en_nrzi  = valid[1];
wire en_unstuf   = valid[2];
wire en_sipo     = valid[3];


always@(posedge clk, negedge rst)
	begin
		if(!rst)
			begin
			  valid <= 4'b0;
			  state <= 4'd0;			
			end
		else
			begin
			 case (state)
			  0 : begin 
					valid <= 4'b0000;
				    state <= 4'd1;
				  end
			  1 : begin 
					valid <= 4'b0001;
				    state <= 4'd2;
				  end		
			  2 : begin
					valid <= 4'b0011;
					state <= 4'd3;
				  end
		/*		  				  
			  3 : begin
					//valid <= 4'b1111;
					state <= 3'd4;
				  end
		*/	  
			  3 : begin
					valid <= 4'b1111;
					state <= 4'd4;
				  end
				  
			  4 : begin
					valid <= 4'b1111;
					//state <= 3'd6;
				  end
			 /* 	  
			  6 : begin
					valid <= 4'b1111;
					state <= 3'd6;
				  end	
			*/	    
				default: begin
						  valid <= 4'b0;
						  state <= 4'b0;
						end
			 endcase
			end
	end

endmodule
