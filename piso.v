module piso (
  clk,
  rst,
  load,
  pi,
  so,
  en_crc
);

input clk;
input rst;
input load;
input [7:0] pi;
output so;
output en_crc;

reg [1:0]state;
reg [3:0] cnt1;
reg [3:0] cnt2;
reg [7:0] r;
reg en_crc;
//reg so;
//reg en; 

assign so = r[0];

always@(posedge clk or negedge rst) 
begin
  if (!rst)
  begin
    r <= 8'b11111111;
   // en <= 1'b0;
  end  
  else 
   begin
    //en <= load;
     if (load)
     r <= pi;    
    else
		//so <= r[0];
    r <= {1'b0, r[7:1]};
  end  
end

always@(posedge clk, negedge rst)
begin
  if(!rst)
		begin
			cnt1 <= 4'd0;
			cnt2 <= 4'd0;
			en_crc <= 1'b0;
			state <= 2'd0;
		end
	else
		begin
			case(state)
				0: begin
			      en_crc <= 1'b0;
						if(r == 8'b10000000)
						begin
							state <= 2'd1;
						end	
					 end
					 
				1: begin
						 cnt1 <= cnt1 + 1;
						 if(cnt1 == 4'd6)
							begin
								state <= 2'd2;
								en_crc <= 1'b1;
								cnt1 <= 4'd0;
							end
						end	
				 2: begin
						  cnt2 <= cnt2 + 1;
						 if(cnt2 == 4'd9)
							begin
								state <= 2'd3;
								en_crc <= 1'b0;
								cnt2 <= 4'd0;
							end
						 end	
					3:begin
							state <= 2'b0;
						end
						
          default :begin 
						state <= 2'b0;						
					end
			endcase
		end
end		
endmodule
