module MorraCinese(
  input [0:0] clk, [1:0] primo, [1:0] secondo, [0:0] inizia,
  output reg [1:0] manche, [1:0] partita
  );
   
  reg [2:0] stato = 3'b000;
  reg [2:0] statoProssimo = 3'b000;
  reg [4:0] mancheIdx = 5'b00000;
  reg [4:0] maxManche = 5'b00100;
  integer vantaggio = 0;

  reg [1:0] sasso = 2'b01;
  reg [1:0] carta = 2'b10;
  reg [1:0] forbice = 2'b11;

  reg [1:0] pareggio = 2'b11;

  always @(clk) begin: Update
    stato = statoProssimo;
  end

  always @(posedge clk) begin: Datapath
    if (inizia) begin
      stato = 3'b000;
      mancheIdx = 5'b00000;
      vantaggio = 0;
      partita = 2'b00;
      manche = 2'b00;
      maxManche = 5'b00100 + {primo, secondo};
    end else begin
      if (manche != 2'b00) begin
        mancheIdx++;
      end
      if (manche == 2'b01) begin
        vantaggio++;
      end else if (manche == 2'b10) begin
        vantaggio--;
      end

      if (vantaggio <= -2 && mancheIdx >= 4) begin
        partita = 2'b10;
      end else if (vantaggio >= 2 && mancheIdx >= 4) begin
        partita = 2'b01;
      end else if (mancheIdx == maxManche && vantaggio > 0) begin
        partita = 2'b01;
      end else if (mancheIdx == maxManche && vantaggio < 0) begin
        partita = 2'b10;
      end else if (mancheIdx == maxManche && vantaggio == 0) begin
        partita = 2'b11;
      end else begin
        partita = 2'b00;
      end
    end
  end

  always @(primo, secondo) begin: FSM
    /*
    Par = 000
    PrS = 001
    PrC = 010
    PrF = 011
    SeS = 100
    SeC = 101
    SeF = 110
    */
    case (stato)
      3'b000:
        if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == sasso && secondo == forbice) begin
          statoProssimo = 3'b001;
          manche = 2'b01;
        end else if (primo == sasso && secondo == carta) begin
          statoProssimo = 3'b101;
          manche = 2'b10;
        end else if (primo == carta && secondo == sasso) begin
          statoProssimo = 3'b010;
          manche = 2'b01;
        end else if (primo == carta && secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else if (primo == forbice && secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b10;
        end else if (primo == forbice && secondo == carta) begin
          statoProssimo = 3'b011;
          manche = 2'b01;
        end else begin
          statoProssimo = 3'b000;
          manche = 2'b00;
        end
      3'b001:
        if (primo == sasso) begin
          statoProssimo = 3'b001;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == carta && secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else if (primo == forbice && secondo == carta) begin
          statoProssimo = 3'b011;
          manche = 2'b01;
        end else if (primo == carta && secondo == sasso) begin
          statoProssimo = 3'b010;
          manche = 2'b01;
        end else if (primo == forbice && secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b10;
        end else begin
          statoProssimo = 3'b001;
          manche = 2'b00;
        end
      3'b010:
        if (primo == carta) begin
          statoProssimo = 3'b010;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == sasso && secondo == forbice) begin
          statoProssimo = 3'b001;
          manche = 2'b01;
        end else if (primo == forbice && secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b10;
        end else if (primo == sasso && secondo == carta) begin
          statoProssimo = 3'b101;
          manche = 2'b10;
        end else if (primo == forbice && secondo == carta) begin
          statoProssimo = 3'b011;
          manche = 2'b01;
        end else begin
          statoProssimo = 3'b010;
          manche = 2'b00;
        end
      3'b011:
        if (primo == forbice) begin
          statoProssimo = 3'b011;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == sasso && secondo == carta) begin
          statoProssimo = 3'b101;
          manche = 2'b10;
        end else if (primo == carta && secondo == sasso) begin
          statoProssimo = 3'b010;
          manche = 2'b01;
        end else if (primo == sasso && secondo == forbice) begin
          statoProssimo = 3'b001;
          manche = 2'b01;
        end else if (primo == carta && secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else begin
          statoProssimo = 3'b011;
          manche = 2'b00;
        end
      3'b100:
        if (secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == carta && secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else if (primo == forbice && secondo == carta) begin
          statoProssimo = 3'b011;
          manche = 2'b01;
        end else if (primo == sasso && secondo == forbice) begin
          statoProssimo = 3'b001;
          manche = 2'b01;
        end else if (primo == sasso && secondo == carta) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else begin
          statoProssimo = 3'b100;
          manche = 2'b00;
        end
      3'b101:
        if (secondo == carta) begin
          statoProssimo = 3'b101;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == sasso && secondo == forbice) begin
          statoProssimo = 3'b001;
          manche = 2'b01;
        end else if (primo == forbice && secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b10;
        end else if (primo == carta && secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b10;
        end else if (primo == carta && secondo == sasso) begin
          statoProssimo = 3'b010;
          manche = 2'b01;
        end else begin
          statoProssimo = 3'b101;
          manche = 2'b00;
        end
      3'b110:
        if (secondo == forbice) begin
          statoProssimo = 3'b110;
          manche = 2'b00;
        end else if (primo == secondo) begin
          statoProssimo = 3'b000;
          manche = 2'b11;
        end else if (primo == sasso && secondo == carta) begin
          statoProssimo = 3'b101;
          manche = 2'b10;
        end else if (primo == carta && secondo == sasso) begin
          statoProssimo = 3'b010;
          manche = 2'b01;
        end else if (primo == forbice && secondo == sasso) begin
          statoProssimo = 3'b100;
          manche = 2'b10;
        end else if (primo == forbice && secondo == carta) begin
          statoProssimo = 3'b011;
          manche = 2'b01;
        end else begin
          statoProssimo = 3'b110;
          manche = 2'b00;
        end
      endcase
  end

endmodule
