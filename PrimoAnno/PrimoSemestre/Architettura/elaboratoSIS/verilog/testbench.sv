module MorraCinese_tb();

  // Inputs
  reg clk;
  reg [1:0] primo;
  reg [1:0] secondo;
  reg inizia;

  // Outputs
  wire [1:0] manche;
  wire [1:0] partita;

  // Files
  integer sisTb;
  integer verilogOut;

  always #10 clk = ~clk;

  MorraCinese morra_cinese(
    .clk(clk),
    .primo(primo),
    .secondo(secondo),
    .inizia(inizia),
    .manche(manche),
    .partita(partita)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);

    sisTb = $fopen("testbench.script", "w");
    verilogOut = $fopen("output_verilog.txt", "w");

    $fdisplay(sisTb, "read_blif FSMD.blif");

    // Partita 1
    clk = 1'b0;
    inizia = 1'b1;

    // maxManche = 6
    primo = 2'b00;
    secondo = 2'b10;

    #20
    $display("Partita 1");
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 1
    // Sasso vs Carta
    // Vantaggio -1
    inizia = 1'b0;
    primo = 2'b01;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche Non valida (1)
    // Forbice vs Carta
    // Vantaggio -1
    primo = 2'b11;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    //Manche 2
    // Sasso vs Forbice
    // Vantaggio 0
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    //Manche 3
    // Forbice vs Forbice
    // Vantaggio 0
    primo = 2'b11;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    //Manche 4
    // Forbice vs Carta
    // Vantaggio 1
    primo = 2'b11;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 5
    // Sasso vs Carta
    // Vantaggio 0
    primo = 2'b01;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 6
    // Forbice vs Forbice
    // Vantaggio 0
    primo = 2'b11;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Partita 1 finita in pareggio

    // Partita 2
    inizia = 1'b1;

    // maxManche = 5
    primo = 2'b00;
    secondo = 2'b01;

    #20
    $display("\nPartita 2");
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 1
    // Sasso vs Forbice
    // Vantaggio 1
    inizia = 1'b0;
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 2
    // Carta vs Sasso
    // Vantaggio 2
    primo = 2'b10;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 3
    // Sasso vs Carta
    // Vantaggio 1
    primo = 2'b01;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 4
    // Carta vs Forbice
    // Vantaggio 0
    primo = 2'b10;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 5
    // Forbice vs Sasso
    // Vantaggio -1
    primo = 2'b11;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Partita 2 finita con vincitore Secondo e Vantaggio -1
    
    // Partita 3
    inizia = 1'b1;

    // maxManche = 19
    primo = 2'b11;
    secondo = 2'b11;

    #20
    $display("\nPartita 3");
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 1
    // Sasso vs Forbice
    // Vantaggio 1
    inizia = 1'b0;
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 2
    // Carta vs Sasso
    // Vantaggio 2
    primo = 2'b10;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 3
    // Forbice vs Carta
    // Vantaggio 3
    primo = 2'b11;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche non valida (4)
    // Forbice vs Sasso
    // Vantaggio 3
    primo = 2'b11;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 4
    // Sasso vs Carta
    // Vantaggio 2
    primo = 2'b01;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Partita 3 finita con vincitore Primo e vantaggio 2
    
    // Partita 4
    inizia = 1'b1;

    // maxManche = 9
    primo = 2'b01;
    secondo = 2'b01;

    #20
    $display("\nPartita 4");
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 1
    // Sasso vs Forbice
    // Vantaggio 1
    inizia = 1'b0;
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 2
    // Carta vs Sasso
    // Vantaggio 2
    primo = 2'b10;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 3
    // Forbice vs Sasso
    // Vantaggio 1
    primo = 2'b11;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 4
    // Carta vs Carta
    // Vantaggio 1
    primo = 2'b10;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 5
    // Forbice vs Sasso
    // Vantaggio 0
    primo = 2'b11;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 6
    // Sasso vs Forbice
    // Vantaggio 1
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche non valida (7)
    // Sasso vs Carta
    // Vantaggio 1
    primo = 2'b01;
    secondo = 2'b10;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche non valida (7)
    // N/A vs Forbici
    // Vantaggio 1
    primo = 2'b00;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche non valida (7)
    // Sasso vs Forbici
    // Vantaggio 1
    primo = 2'b01;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 7
    // Forbice vs Forbice
    // Vantaggio 1
    primo = 2'b11;
    secondo = 2'b11;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Manche 8
    // Carta vs Sasso
    // Vantaggio 2
    primo = 2'b10;
    secondo = 2'b01;

    #20
    $display("Primo: %b Secondo: %b Manche: %b Partita: %b", primo, secondo, manche, partita);
    $fdisplay(sisTb, "simulate %b %b %b %b %b", primo[1], primo[0], secondo[1], secondo[0], inizia);
    $fdisplay(verilogOut, "Outputs: %b %b %b %b", manche[1], manche[0], partita[1], partita[0]);
    // Partita 4 finita con vincitore Primo e Vantaggio 2

    $fdisplay(sisTb, "quit");
    $fclose(sisTb);
    $fclose(verilogOut);
    $finish;
  end

endmodule
