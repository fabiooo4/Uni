module es1(
  input rst, clk, i1, i2,
  output reg o1, o2);
  reg state = 4'b0000;
  reg nextState = 4'b0000;

  always @(posedge clk) begin: SEQ
    if (rst) state = 4'b0000;
    else state = nextState;
  end

  always @(state, i1, i2) begin: CMB
    case (state)
      4'b0000: // A
        if (~i1 && ~i2) begin
          nextState = 4'b0011;
          o1 = 1'b1;
          o2 = 1'b0;
        end else if (~i1 && i2) begin
          nextState = 4'b0011;
          o1 = 1'b0;
          o2 = 1'b0;
        end else if (i1 && ~i2) begin
          nextState = 4'b0000;
          o1 = 1'b1;
          o2 = 1'b1;
        end else begin
          nextState = 4'b0011;
          o1 = 1'b1;
          o2 = 1'b1;
        end
      4'b0001: // B
        if (~i1 && ~i2) begin
          nextState = 4'b0001;
          o1 = 1'b1;
          o2 = 1'bx;
        end else if (~i1 && i2) begin
          nextState = 4'b0000;
          o1 = 1'bx;
          o2 = 1'bx;
        end else if (i1 && ~i2) begin
          nextState = 4'b0001;
          o1 = 1'bx;
          o2 = 1'b1;
        end else begin
          nextState = 4'b0010;
          o1 = 1'bx;
          o2 = 1'bx;
        end
      4'b0010: // C
        if (~i1 && ~i2) begin
          nextState = 4'b0010;
          o1 = 1'b0;
          o2 = 1'bx;
        end else if (~i1 && i2) begin
          nextState = 4'b0111;
          o1 = 1'bx;
          o2 = 1'b1;
        end else if (i1 && ~i2) begin
          nextState = 4'b1000;
          o1 = 1'bx;
          o2 = 1'b0;
        end else begin
          nextState = 4'b0000;
          o1 = 1'bx;
          o2 = 1'b0;
        end
      4'b0011: // D
        if (~i1 && ~i2) begin
          nextState = 4'b0000;
          o1 = 1'b1;
          o2 = 1'b0;
        end else if (~i1 && i2) begin
          nextState = 4'b0000;
          o1 = 1'bx;
          o2 = 1'b0;
        end else if (i1 && ~i2) begin
          nextState = 4'b0011;
          o1 = 1'b1;
          o2 = 1'b1;
        end else begin
          nextState = 4'b0000;
          o1 = 1'b1;
          o2 = 1'b1;
        end
      4'b0100: // E
        if (~i1 && ~i2) begin
          nextState = 4'b0110;
          o1 = 1'b1;
          o2 = 1'b0;
        end else if (~i1 && i2) begin
          nextState = 4'b0110;
          o1 = 1'bx;
          o2 = 1'bx;
        end else if (i1 && ~i2) begin
          nextState = 4'b0010;
          o1 = 1'bx;
          o2 = 1'b1;
        end else begin
          nextState = 4'b1000;
          o1 = 1'b1;
          o2 = 1'bx;
        end
      4'b0101: // F
        if (~i1 && ~i2) begin
          nextState = 4'b0111;
          o1 = 1'bx;
          o2 = 1'bx;
        end else if (~i1 && i2) begin
          nextState = 4'b0111;
          o1 = 1'bx;
          o2 = 1'b0;
        end else if (i1 && ~i2) begin
          nextState = 4'b0000;
          o1 = 1'b0;
          o2 = 1'b1;
        end else begin
          nextState = 4'b0001;
          o1 = 1'b1;
          o2 = 1'b0;
        end
      4'b0110: // G
        if (~i1 && ~i2) begin
          nextState = 4'b0000;
          o1 = 1'b1;
          o2 = 1'b0;
        end else if (~i1 && i2) begin
          nextState = 4'b0110;
          o1 = 1'bx;
          o2 = 1'b0;
        end else if (i1 && ~i2) begin
          nextState = 4'b0111;
          o1 = 1'b0;
          o2 = 1'b0;
        end else begin
          nextState = 4'b0011;
          o1 = 1'b1;
          o2 = 1'b1;
        end
      4'b0111: // H
        if (~i1 && ~i2) begin
          nextState = 4'b0011;
          o1 = 1'b1;
          o2 = 1'bx;
        end else if (~i1 && i2) begin
          nextState = 4'b0110;
          o1 = 1'bx;
          o2 = 1'b0;
        end else if (i1 && ~i2) begin
          nextState = 4'b0111;
          o1 = 1'b0;
          o2 = 1'b0;
        end else begin
          nextState = 4'b0000;
          o1 = 1'bx;
          o2 = 1'b1;
        end
      4'b1000: // I
        if (~i1 && ~i2) begin
          nextState = 4'b0101;
          o1 = 1'bx;
          o2 = 1'bx;
        end else if (~i1 && i2) begin
          nextState = 4'b0101;
          o1 = 1'b1;
          o2 = 1'b1;
        end else if (i1 && ~i2) begin
          nextState = 4'b0100;
          o1 = 1'b0;
          o2 = 1'b0;
        end else begin
          nextState = 4'b0000;
          o1 = 1'b0;
          o2 = 1'b1;
        end
      default:
        begin
          nextState = 4'b0000;
          o1 = 1'b0;
          o2 = 1'b0;
        end
    endcase
  end
endmodule
