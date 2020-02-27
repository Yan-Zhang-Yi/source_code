//CRC16 test
module CRC16(
     input             rst,      /* async reset,active low */ 
    input             clk,      /* clock input */ 
    input      [ 7 : 0 ] data_in, /* parallel data input pins */ 
    input             put, /* data valid,start to generate CRC, active high */ 
    output  reg [ 15 : 0 ] crc
);

integer i;
 reg feedback;
 reg [ 15 : 0 ] crc_tmp;
 //reg [23:0] data_crc;
 wire [23:0] data_crc;
 /*
 * * sequential process
 * */ 
 
 assign data_crc = (crc == 16'b0) ? 24'b0 : {data_in, crc} ;
always @( posedge clk or  negedge rst)
 begin 
    if (! rst)
        crc <= 16'b0; 
    else  if (put== 1'b0) 
        crc <= 16'b0; 
    else 
        crc <= crc_tmp;
       // data_crc <= {data_in, crc};
 end

/*
 * * combination process
 * */ 
always @( data_in or crc)
 begin 
    crc_tmp = crc;
    //data_crc = {data_in, crc};
     for (i= 7 ; i>= 0 ; i=i- 1 )
     begin 
        feedback     = crc_tmp[ 15 ] ^ data_in[i];
        crc_tmp[ 15 ] = crc_tmp[ 14 ];
        crc_tmp[ 14 ] = crc_tmp[ 13 ];
        crc_tmp[ 13 ] = crc_tmp[ 12 ];
        crc_tmp[ 12 ] = crc_tmp[ 11 ] ^ feedback;
        crc_tmp[ 11 ] = crc_tmp[ 10 ] ;
        crc_tmp[ 10 ] = crc_tmp[ 9 ];
        crc_tmp[ 9 ] = crc_tmp[ 8 ];
        crc_tmp[ 8 ] = crc_tmp[ 7 ];
        crc_tmp[ 7 ] = crc_tmp[ 6 ];
        crc_tmp[ 6 ] = crc_tmp[ 5 ];
        crc_tmp[ 5 ] = crc_tmp[ 4 ] ^ feedback;
        crc_tmp[ 4 ] = crc_tmp[ 3 ];
        crc_tmp[ 3 ] = crc_tmp[ 2 ];
        crc_tmp[ 2 ] = crc_tmp[ 1 ];
        crc_tmp[ 1 ] = crc_tmp[ 0 ];
        crc_tmp[ 0 ] = feedback;
      end 
end

endmodule
