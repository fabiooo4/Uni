module es1(
  input [1:0] a, [1:0] b, sel,
  output reg [1:0] o
  );

  always @(a, b, sel) begin
    if (sel) begin
      o = a - b;
    end else begin
      o = a + b;
    end
  end
endmodule
