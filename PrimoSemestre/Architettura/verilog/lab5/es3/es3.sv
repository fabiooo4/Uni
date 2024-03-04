module es3 (
  input rst, clk, a, b,
  output reg o);

  reg state = 1'b0;
  reg nextState = 1'b0;


  always @(posedge clk) begin: Seq
    if (rst) state = 1'b0;
    else state = nextState;
  end

  always @(state, a, b) begin: Comb
    case (state)
      0:
        if (a && b) begin
          nextState = 1;
          o = 0;
        end else begin
          if (~a && ~b) begin
            nextState = 0;
            o = 0;
          end else begin
            nextState = 0;
            o = 1;
          end
        end
      1:
        if (a && b) begin
          nextState = 1;
          o = 1;
        end else begin
          nextState = 0;
          if (~a && ~b) begin
            o = 1;
          end else begin
            o = 0;
          end
        end
    endcase
  end
endmodule
