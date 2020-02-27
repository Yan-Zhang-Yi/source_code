module unstuffing(clk, rst,data_in, data_out, data_valid ,en_unstuf, crc_in);

// port type
input clk,rst,data_in, en_unstuf; 
input [15:0] crc_in;
output data_out,data_valid;

parameter setup = 2'b00,  determine = 2'b01, mark = 2'b10, idel = 2'b11;
// wire & register  
//reg [3:0]data_out_r1;
//reg [7:0] data_out_r2;
reg [2:0] count; 
//reg [3:0] count2;
reg [1:0] state;
reg data_valid;	//Signal to determine whether data_out is valid or not
//reg [7:0] store_data;
//reg [7:0] data_s;
//wire data_out;
reg data_out;
reg stay;
reg [17:0] idel_counter;
//assign Error = (~(&data_out_r1)) ? 1'b1 : 1'b0;
//wire data_en;
//wire en_clk;
//wire clk_n;

//assign data_en = (count2 == 4'd8) ? 1'b1 : 1'b0;
//assign data_out = data_out_r2[0];
 


/*
always @(posedge data_en)
  begin
    data_s <= store_data;
  end
  
/*
always @(posedge clk, negedge rst)
  begin
    if (!rst)
      begin
       data_out_r2 <= 8'b0;
      end  
   else 
     begin
     if (data_en)
       data_out_r2  <= data_s;    
       else
       data_out_r2  <= {1'b0, data_out_r2[7:1]};
       //data_out = data_out_r2[0];
     end 
  end
*/
	  
//idel counter
   always @(posedge clk, negedge rst)
	    begin
		if(!rst)
		  begin
		     idel_counter <= 18'b0;
		  end
		else
		  begin  
		  
		   if(data_valid)
                begin
		          if(data_out)
				    idel_counter <= idel_counter + 1;							   
				 else
					idel_counter <= 18'b0;			  
		        end
		  end      
		end


always @(posedge clk, negedge rst)
  begin
    if(!rst)
	  begin
	    // data_out_r1 <= 4'b1111;
        // data_out_r2 <= 8'b0;
         //count <= 3'b0; 
         //count2 <= 4'b0;
         state <= setup;
		// data_out_r1 <= 4'b1111;       
         count <= 3'b0;        
         data_valid <= 1'b0;
		 stay <= 1'b0;
         //data_valid <= 1'b0;
        // store_data <= 8'b0;	
	  end
	  else //rst = 1
	    begin
				if(en_unstuf)
					begin
   //============= shift reg ==============
      /* if (data_en)
         begin
          data_out_r2  <= data_s;    
         end
       else
         begin
          data_out_r2  <= {1'b0, data_out_r2[7:1]};
		 end
	  */
	  //state <= 2'b1;
	  //data_valid <= 1'b1;
	  data_out <= data_in;	    
	//============ state machine ==========	   
		  case(state) 
             setup: begin
				 //data_out <= data_in;
				 data_valid <= 1'b1;
				 state <= determine;
				end

		     determine: begin	
				//data_out <= data_in;
				data_valid <= 1'b1;
			 		
				
			//decide data_in	   
			     if(data_in)
				  begin	
				    count <= count + 1;								   
				  end
				 else
					begin
					  count <= 3'd0;
					  state <= determine;				  
					end
					
			//decide data_in =>> six high		
				if(count == 3'd6)
					begin
					  count <= 3'd0;
					  data_valid <= 1'b0;
				      state <= mark;
				     // data_out_r1 = data_out_r1 << 1;
				      //data_out_r1[0] <= data_in;
				     /* 
				      if(~(|data_out_r1))
				        begin
				        state <= idel;
						stay <= 1'b1;
				        end
					*/	
					 end
					 
				else
				  begin
				   state <= determine;
				   //store_data <= store_data >> 1;
		           //store_data[7] <= data_in;
				   //count2 <= (count2 == 4'd8) ? 4'd1 : count2 + 1'b1;	
				  end
		     end	
				
			mark: begin
			      
			  
			  // idel counter 	        
		      if(idel_counter > 18'd150000)
					begin
					 stay <= 1'b1;
					 state <= idel;
					end	
				else
				  begin	
				  //data_out <= data_in;
			      if(data_in)
				  begin	
				    count <= count + 1;								   
				  end
				 else
					begin
					  count <= 3'd0;			  
					end			
				   data_valid <= 1'b1;
				   state <= determine;
				  end
				  //store_data <= store_data >> 1;
		          //store_data[7] <= data_in;
				  //count2 <= (count2 == 4'd8) ? 4'd1 : count2 + 1'b1;
			   end
			   
			idel:begin
				 data_valid <= 1'b0;
			  end
		  endcase
		 
     end
		  else
				begin
				 state <= setup;   
         count <= 3'b0;        
         data_valid <= 1'b0;
		     stay <= 1'b0;
				end
   end // end for rst
  end // end for always



endmodule
