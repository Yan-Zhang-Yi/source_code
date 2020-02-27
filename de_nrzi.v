module de_nrzi(clk, rst, DP_in, DM_in, data_out);
input clk, rst, DP_in ,DM_in;
output data_out;

reg de_dp, de_dm/*, data_out*/,out;
//wire dm, dp;
wire data_out;
//wire a, b, c;
/*
assign data_out = (!rst) ? 1'bz : (de_dp | de_dm);
assign dp = ~(de_dp ^ DP_in);
assign dm = ~(de_dm ^ DM_in);
 
  always@(posedge clk, negedge rst)
 begin
  if(!rst) 
   begin
    de_dp <= 1'b1;
    de_dm <= 1'b1;
   end
  else
   begin
    de_dp  <= dp;
    de_dm  <= dm;
   end
 end
 */


//wire dp_o, dm_o;

  /*
always @(DP_in, de_d1)
begin
  de_d2 <= (~(DP_in ^ de_d1)| ~(DM_in ^ de_d1));
end

 always @(posedge clk, negedge rst)
  if(!rst)
   begin
     data_out <= 1'b1;
   end
   
    else 
	 begin
	   data_out <= de_d2;	  
	 end
	 
  always @(posedge clk)
    begin
      de_d1 <= DP_in;
    end	
  */
  
   //=====================================
 /* always @(posedge clk)
begin
  data_out = (~(DP_in ^ de_d1) | (DM_in ^ de_d1));
end
*/
//assign dp_o = ~(DP_in ^ de_dp);
//assign dm_o = ~(DM_in ^ de_dm);

//============================== Test =========================
/*
assign a = (~DP_in) & de_dp; assign b = DP_in & (~de_dp); assign c = a | b;
assign data_out = (!rst) ? 1'bx : (dp_o | dm_o) ~c; 


always @(posedge clk)
  begin
   if(!rst)
    begin 
     de_dp <= 1'b1;
     de_dm <= 1'b1;
    end
    else
     begin
      de_dp <= DP_in;
      de_dm <= DM_in;
     end
  end 
 */ 
//====================================================

always @(posedge clk, negedge rst)
  if(!rst)
   begin
     //data_out <= 1'bz;
     de_dp <= 1'b1;
     de_dm <= 1'b1;    
   end
   
    else 
	 begin
	   de_dp <= DP_in;
	   de_dm <= DM_in;	
	 out = (~(DP_in ^ de_dp) /*| ~(DM_in ^ de_dm)*/);
	 end
  assign  data_out = (!rst) ? 1'bx : out;
  // assign  data_out = (!rst) ? 1'bx : (~(DP_in ^ de_dp) | ~(DM_in ^ de_dm));
   
endmodule

