module tb_es3 ();

// Inputs
reg rst;
reg clk;
reg a;
reg b;

// Outputs
reg o;

es3 es3(rst, clk, a, b, o);
  
always #10 clk = ~clk;

initial begin
  $dumpfile("tb_es3.vcd");
  $dumpvars(1);

  clk = 0;
  a = 0;
  b = 0;
  rst = 1;
  #20
  a = 0;
  b = 0;
  rst = 0;
  #20
  a = 0;
  b = 1;
  rst = 0;
  #20
  a = 1;
  b = 0;
  rst = 0;
  #20
  a = 1;
  b = 1;
  rst = 0;
  #20
  a = 1;
  b = 1;
  rst = 0;
  #20
  $finish;
end
endmodule
