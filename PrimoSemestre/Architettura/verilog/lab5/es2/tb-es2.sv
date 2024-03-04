module tb_es2();

  // Inputs
  reg rst;
  reg clk;
  reg i1;
  reg i2;

  // Outputs
  wire o;

  es2 es2(rst, clk, i1, i2, o);

  always #10 clk = ~clk;

  initial begin
    $dumpfile("tb-es1.vcd");
    $dumpvars(1);

    clk = 1'b0;

    i1 = 1'b0;
    i2 = 1'b0;
    rst = 1'b1;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b1;
    i2 = 1'b1;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b0;
    i2 = 1'b0;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b1;
    i2 = 1'b1;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b1;
    i2 = 1'b1;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b0;
    i2 = 1'b0;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b1;
    i2 = 1'b1;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b0;
    i2 = 1'b0;
    rst = 1'b0;
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #20
    i1 = 1'b0;
    i2 = 1'b1;
    rst = 1'b0;
    #10
    $display("%t: rst=%b, clk=%b, i1=%b, i2=%b, o=%b \n", $time, rst, clk, i1, i2, o);
    #10
    $finish;
  end
endmodule
