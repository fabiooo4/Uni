module es2(
  input clk, apri, [3:0] num, 
  output reg aperta = 0
  );

  integer conta = 0;

  always @(posedge clk) begin
    conta++;
  end

  always @(clk, apri, num) begin
    if (apri && num == 4'b0110 && ~aperta) begin
      aperta = 1;
      conta = 0;
    end

    if (aperta && (conta == 3 || ~apri)) begin
      aperta = 0;
    end
  end

endmodule
