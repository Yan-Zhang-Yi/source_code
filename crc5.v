//CRC5 practice
module crc5(
     input            rst,
     input            clk,
     input      [ 7 : 0 ] data_in,
     input            put, 
     output  reg [ 4 : 0 ] crc
     /*output     [12 : 0 ] data_crc*/);
     
  integer i;
 reg feedback;
 reg [ 4 : 0 ] crc_tmp;
 wire [12 : 0 ] data_crc;
// reg [12:0] data_crc;
 
assign data_crc = (crc == 5'b0) ? 13'b0 : {data_in, crc} ;
 always @( posedge clk or  negedge rst)
 begin 
    if (! rst)
        crc <= 5'b0;          
    else  if (put == 1'b0) 
        crc <= 5'b0; 
    else 
      begin
        crc <= crc_tmp;
        //data_crc <= {data_in, crc};
      end
 end


always @( data_in or crc)
 begin 
    crc_tmp = crc;
    //data_crc = {data_in, crc};
     for (i= 7 ; i>= 0 ; i=i- 1 )
     begin 
        feedback     = crc_tmp[ 4 ] ^ data_in[i];
        crc_tmp[ 4 ] = crc_tmp[ 3 ];
        crc_tmp[ 3 ] = crc_tmp[ 2 ];
        crc_tmp[ 2 ] = crc_tmp[ 1 ] ^ feedback;
        crc_tmp[ 1 ] = crc_tmp[ 0 ];
        crc_tmp[ 0 ] = feedback;
 	    //data_crc = {data_in, crc};
     end
    
end

endmodule

