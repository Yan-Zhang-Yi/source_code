module div (
  input      clk,
  input      rst_n,
  output reg o_clk
);

always@(posedge clk or negedge rst_n) 
 begin
  if (!rst_n)
    o_clk <= 0;
  else
    o_clk <= ~o_clk;
 end
 endmodule
