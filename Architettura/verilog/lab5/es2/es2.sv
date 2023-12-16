module es2(
  input rst, clk, i1, i2,
  output reg o);
  reg[1:0] state = 2'b00;
  reg[1:0] nextState = 2'b00;

  always @(posedge clk) begin: SEQ
    if (rst) state = 2'b00;
    else state = nextState;
  end

  always @(state, i1, i2) begin: COMB
    case (state)
      2'b00: // A
        if (~i1 && ~i2) begin
          nextState = 2'b01; // B
          o = 1'b0;
        end else begin
          nextState = 2'b00; // A
          o = 1'b0;
        end
      2'b01: // B
        if (i1 && i2) begin
          nextState = 2'b10; // C
          o = 1'b0;
        end else begin
          nextState = 2'b00; // A
          o = 1'b0;
        end
      2'b10: // C
        if (~i1 && ~i2) begin
          nextState = 2'b11; // D
          o = 1'b0;
        end else begin
          nextState = 2'b00; // A
          o = 1'b0;
        end
      2'b11: // D
        if (~i1 && i2) begin
          nextState = 2'b00; // A
          o = 1'b1;
        end else begin
          nextState = 2'b10; // C
          o = 1'b0;
        end
    endcase
  end
endmodule
