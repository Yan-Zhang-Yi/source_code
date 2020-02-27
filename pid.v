// PID packet check
module pid(clk, rst, data_in, Token, Data, Handshake, error, en_data, crc_check, sel_crc);

//port name
input  clk, rst, en_data; 
input  data_in;
output Token, Data, Handshake, error;
output [7:0] crc_check;
output [2:0] sel_crc;

reg [7:0] pid_packet;
reg [3:0] cnt;
wire [3:0] pid_p;
wire [3:0] pid_n;
//wire [7:0] crc_check;
reg [7:0] crc_check;
reg [2:0] packet;
reg [2:0] packet_type;
reg error;
reg [2:0]sel_crc;

//==============================
 reg [3:0] Token_pid_name;
 reg [3:0] Data_pid_name;
 reg [3:0] Handshake_pid_name;
 // Token pid name
 wire OUT = Token_pid_name[0];
 wire SOF = Token_pid_name[1];
 wire IN = Token_pid_name[2];
 wire SETUP = Token_pid_name[3];
 // Data pid name
 wire DATA0 = Data_pid_name[0]; 
 wire DATA2 = Data_pid_name[1];
 wire DATA1 = Data_pid_name[2];
 wire MDATA = Data_pid_name[3];
 // Handshake pid name
 wire ACK = Handshake_pid_name[0]; 
 wire NYET = Handshake_pid_name[1];
 wire NAK = Handshake_pid_name[2];
 wire STALL = Handshake_pid_name[3]; 
//==============================


// decide packet is correct
//assign pid_packet = (cnt == 8) ? pid_packet : pid_packet;
assign pid_p = crc_check[3:0];
assign pid_n = crc_check[7:4];

// check pid type
/*
assign Token = packet[0];
assign Data  = packet[1];
assign Handshake = packet[2];
*/
assign Token = packet_type[0];
assign Data  = packet_type[1];
assign Handshake = packet_type[2];

//============= pid_packet =================


 //assign pid_packet = (cnt == 4'd8) ? pid_packet : pid_packet;

//assign crc_check = (cnt == 4'd8) ? pid_packet : crc_check;


//================ packet decide ===================
always @(cnt)
begin 
if(cnt == 4'd1)
begin
 if(pid_p == ~pid_n)
  begin
     error = 1'b0; 
     case (pid_p[1:0])
		       // Token packet
		       2'b01 : begin
			             packet = 3'b001;
			             Data_pid_name = 4'b0;
			             Handshake_pid_name = 4'b0;
					      case (pid_p[3:2])
					         2'b00 : Token_pid_name = 4'b0001;
							 2'b01 : Token_pid_name = 4'b0010;
							 2'b10 : Token_pid_name = 4'b0100;
							 2'b11 : Token_pid_name = 4'b1000;
						   default : Token_pid_name = 4'b0000;
					      endcase
                       end						  
		     /* 4'b0001 : packet = 3'b001;
			  4'b1001 : packet = 3'b001;
			  4'b0101 : packet = 3'b001;
			  4'b1101 : packet = 3'b001;*/
			  
			   //Data packet
			   2'b11 :  begin
			             packet = 3'b010;
			             Token_pid_name = 4'b0;
			             Handshake_pid_name = 4'b0;
					      case (pid_p[3:2])
					         2'b00 : Data_pid_name = 4'b0001;
							 2'b01 : Data_pid_name = 4'b0010;
							 2'b10 : Data_pid_name = 4'b0100;
							 2'b11 : Data_pid_name = 4'b1000;
						   default : Data_pid_name = 4'b0000;
					      endcase
                       end
			   					
			  /*4'b0011 : packet = 3'b010;
			  4'b1011 : packet = 3'b010;
			  4'b0111 : packet = 3'b010;
			  4'b1111 : packet = 3'b010;*/
			  
			   //Handshake packet
			   2'b10 : begin
			             packet = 3'b100;
			             Token_pid_name = 4'b0;
			             Data_pid_name = 4'b0;
					      case (pid_p[3:2])
					         2'b00 : Handshake_pid_name = 4'b0001;
							 2'b01 : Handshake_pid_name = 4'b0010;
							 2'b10 : Handshake_pid_name = 4'b0100;
							 2'b11 : Handshake_pid_name = 4'b1000;
						   default : Handshake_pid_name = 4'b0000;
					      endcase
                       end 
			   
			  /*4'b0010 : packet = 3'b100;
			  4'b1010 : packet = 3'b100;
			  4'b1110 : packet = 3'b100;
			  4'b0110 : packet = 3'b100;*/
			  default : begin 
			             packet = 3'b000; 
			             error = 1'b1; 
			             Token_pid_name = 4'b0;
			             Data_pid_name = 4'b0;
						 Handshake_pid_name = 4'b0;
			            end 	  
		  endcase 
	//=================== check Token Packet type ===================	
  end
  else
    begin
     packet = 3'b000;
     error = 1'b1; 
      Token_pid_name = 4'b0;
      Data_pid_name = 4'b0;
	 Handshake_pid_name = 4'b0;
    end 
 end
  else 
    begin
     packet = 3'b000;
     error = 1'b0;
    end 
end
//===================================================================
/*always @(posedge clk, negedge rst)
 begin
   if(!rst)
		  packet_type <= 3'b0;
	else
			packet_type <= packet;
 end*/
 
 //================= sel crc5 or crc16 signal =======================
     always@(posedge clk, negedge rst)
			begin
			  if(!rst)
					sel_crc <= 3'b0;
				else
					sel_crc <= packet_type;
			end
   
//===================================================================
always @(posedge clk, negedge rst)
 begin
   if(!rst)
     begin
      pid_packet <= 8'b0;
			packet_type <= 3'b0;
      cnt <= 0;
     end
   else
     begin 
		 if(en_data)
			begin
			 packet_type <= packet;
           if(cnt == 4'd8)
        begin
          crc_check <= pid_packet;
          cnt <= 4'd1;
          pid_packet <= pid_packet >> 1;
          pid_packet[7] <= data_in;
          //pid_packet <= 8'bx;
         end
           else
            begin
              cnt <= cnt + 1;
              pid_packet <= pid_packet >> 1;
              pid_packet[7] <= data_in;
            end
       end
			else
				begin
					pid_packet <= 8'b0;
					packet_type <= 3'b0;
          cnt <= 0;
				end
   end		 
 end
endmodule
