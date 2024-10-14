module tb_es1();

  // Inputs
  reg rst;
  reg clk;
  reg i1;
  reg i2;

  // Outputs
  wire o1;
  wire o2;

  es1 es1(rst, clk, i1, i2, o1, o2);

  always #10 clk = ~clk;

  initial begin
    $dumpfile("tb-es1.vcd");
    $dumpvars(1);

    clk = 1'b0;

    i1 = 1'b0;
    i2 = 1'b0;
    rst = 1'b1;
    #60
    i1 = 1'b1;
    i2 = 1'b0;
    rst = 1'b0;
    #60
    i1 = 1'b0;
    i2 = 1'b1;
    #60
    i1 = 1'b1;
    i2 = 1'b1;
    #60
    i1 = 1'b0;
    i2 = 1'b0;
    #60
    i1 = 1'b1;
    i2 = 1'b0;
    $finish;
  end
endmodule

