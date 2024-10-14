module tb_es2();

  // Inputs
  reg clk;
  reg apri;
  reg [3:0] num;

  // Outputs
  wire aperta;

  es2 c(clk, apri, num, aperta);

  always #10 clk = ~clk;

  initial begin
    $dumpfile("tb-es1.vcd");
    $dumpvars(1);

    clk = 1'b0;

    num = 4'b1001;
    apri = 1;
    #20
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    apri = 0;
    num = 4'b0110;
    #20
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    apri = 1;
    #20
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    num = 4'b0;
    #80
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    #40
    num = 4'b0110;
    apri = 1;
    #20
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    apri = 0;
    #20
    $display("num: %b apri: %b aperta: %b", num, apri, aperta);
    #40

    $finish;
  end

endmodule
