// Mux
module crc_mux(crc5_i, crc5_o, crc16_i, crc16_o, sel);

input [4:0] crc5_i;
input [15:0] crc16_i;
input [2:0] sel;
output [4:0] crc5_o;
output [15:0] crc16_o;

reg [4:0] crc5_o;
reg [15:0] crc16_o;

always@(crc5_i or crc16_i or sel)
   begin
   case(sel)
	3'b001: begin crc5_o = crc5_i; crc16_o = 16'b0; end
	3'b010: begin crc16_o = crc16_i; crc5_o = 5'b0; end
	3'b100: begin crc5_o = 5'b0; crc16_o = 16'b0; end
  default : begin crc5_o = 5'bx; crc16_o = 16'bx; end
  endcase
   end
endmodule
