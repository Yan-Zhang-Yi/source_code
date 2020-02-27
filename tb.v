`timescale 1ns/1ns
module tb;

reg clk;
reg rst;
reg load;
reg DP_i;
reg DM_i;
wire DP_o;
wire DM_o;
reg [7:0] pi;
wire [7:0]data_out;
//wire Token, Data, Handshake, Error;

top tb(
.clk(clk), 
.rst(rst), 
.DP_i(DP_i),
.DM_i(DM_i),
.DP_o(DP_o),
.DM_o(DM_o),
.data_in(pi), 
.load(load),
.data_out(data_out));


initial begin
  load = 1'b0;
  pi = 8'h0;
  #50;
  // SYNC
  pi <= 8'b10000000;
  //#5;
  load <= 1'b1;
  #40;
  load <= 1'b0;
  // PID
  #280 pi <= 8'b00101101;
       load <= 1'b1; 
  //#5 
  #40 load <= 1'b0;
  // Address + EndP + CRC
  #270 pi <= 8'b01111000;
  #10  load <= 1'b1; 
  #40 load <= 1'b0;
  #270 pi <= 8'b00010000;
       load <= 1'b1; 
  #40 load <= 1'b0;
  #400  $stop;
end

initial begin
  
	#0  DP_i <= 1;
	    DM_i <= 1;
	#150 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
	#40 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
  #40 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
        DM_i <= 0;
	//#20 DP_i <= 1;
     //   DM_i <= 0;
  #40 DP_i <= 0;
			DM_i <= 1;	
  #120 DP_i <= 1;
      DM_i <= 0;	
  #120 DP_i <= 0;
      DM_i <= 1;	
	#80 DP_i <= 1;
	    DM_i <= 0;
  #40 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
	#40 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
	#200 DP_i <= 0;
       DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
	#40 DP_i <= 0;
			DM_i <= 1;
	#40 DP_i <= 1;
      DM_i <= 0;
	#40 DP_i <= 0;
			DM_i <= 1;
	#80	DP_i <= 1;
      DM_i <= 0;
	#40 DP_i <= 0;
			DM_i <= 1;	
end

initial clk = 1'b0;
always #10 clk = ~clk;

initial begin
  rst = 1'b0;
  #15;
  rst = 1'b1;
end
/*
initial begin
  //$fsdbDumpfile("p2s.fsdb");
  //$fsdbDumpvars(0, p2s_tb);
  #500  $stop;
end
*/
endmodule
