`timescale 1ns/1ns
module top(
clk, 
rst, 
data_in, 
load,
DP_i,
DM_i,
DP_o,
DM_o,
error,
data_out);

input clk; 
input rst;
input load;
input DP_i, DM_i;
output DP_o, DM_o;
input [7:0]data_in; 
output [7:0] data_out;
output error;
//output valid;


wire valid,data_to_stuf,DP_data, DM_data, data_to_nrzi, data_to_uf, data_flow; 
wire en_stuf, en_nrzi, en_unstuf, en_sipo;
wire clk_div, crc5_put, crc16_put, crc16_put_r, en_crc; 
wire [2:0] sel_crc;
wire [7:0] data_to_crc, data_to_crc_r;
wire [15:0] crc16_r, crc16_t_i, crc16_t_o;
wire [4:0] crc5_t_i, crc5_t_o; 

//Div 
div div(
 .clk(clk),
 .rst_n(rst),
 .o_clk(clk_div)
);

// Controller
controller control(
.clk(clk_div), 
.rst(rst), 
.en_stuf(en_stuf), 
.en_nrzi(en_nrzi),  
.en_unstuf(en_unstuf), 
.en_sipo(en_sipo));

// PISO
 piso PISO(
  .clk(clk_div),
  .rst(rst),
  .load(load),
  .pi(data_in),
  .en_crc(en_crc),
  .so(data_to_stuf));
	
// PID_TX
 	pid PID(
	.clk(clk_div), 
	.rst(rst), 
	.data_in(data_to_stuf), 
	.sel_crc(sel_crc),
	.Token(crc5_put), 
	.Data(crc16_put), 
	.Handshake(), 
	.error(), 
	.en_data(en_crc), 
	.crc_check(data_to_crc));
	
	// CRC5
 crc5 CRC5_T(
  .rst(rst),
  .clk(clk_div),
  .data_in(data_to_crc),
  .put(crc5_put), 
  .crc(crc5_t_i));

	// CRC16
	 CRC16 CRC16_T(
    .rst(rst),     
    .clk(clk_div),      
    .data_in(data_to_crc), 
    .put(crc16_put), 
    .crc(crc16_t_i));
		
//stuffing module 
bit_stuffing Stuffing(
 .clk(clk_div), 
 .rst(rst),
 .en_data(en_stuf), 
 .crc5_in(crc5_t_o),
 .crc16_in(crc16_t_o),
 .data_in(data_to_stuf),
 .data_out(data_to_nrzi));


//En-NRZI module
 en_nrzi En_NRZI(
 .clk(clk_div), 
 .rst(rst),
 .en_nrzi(en_nrzi), 
 .data_in(data_to_nrzi), 
 .DP(DP_o), 
 .DM(DM_o));


//De-NRZI module
de_nrzi De_NRZI(
  .clk(clk_div), 
	.rst(rst), 
	.DP_in(DP_i), 
	.DM_in(DM_i), 
	.data_out(data_to_uf));

//unstuffing module
  unstuffing Unstuffing(
  .clk(clk_div), 
  .rst(rst),
  .data_in(data_to_uf),
  .crc_in(crc16_r),
  .en_unstuf(en_unstuf), 
  .data_out(data_flow), 
  .data_valid(valid));
	
// PID_RX	
	pid_re PID_re(
	.clk(clk_div), 
	.rst(rst), 
	.data_in(data_to_uf), 
	.Token(), 
	.Data(crc16_put_r), 
	.Handshake(), 
	.error(error), 
	.en_data(en_sipo), 
	.crc_check(data_to_crc_r), 
	.data_valid(valid));
	
// CRC16
	CRC16 CRC16_R(
    .rst(rst),     
    .clk(clk_div),      
    .data_in(data_to_crc_r), 
    .put(crc16_put_r), 
    .crc(crc16_r));
		
	//SIPO
  sipo SIPO(
	.clk(clk_div), 
	.rst(rst), 
	.data_in(data_flow),
	.en_sipo(en_sipo), 
	.data_out(data_out), 
	.valid(valid));
	
	//Mux
  crc_mux MUX(
	.crc5_i(crc5_t_i), 
	.crc5_o(crc5_t_o), 
	.crc16_i(crc16_t_i), 
	.crc16_o(crc16_t_o), 
	.sel(sel_crc));
		
endmodule
