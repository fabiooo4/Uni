module tb_es1();
  reg [1:0] a;
  reg [1:0] b;
  reg sel;
  
  wire [1:0] o;

  integer tbf, outf;
  
  es1 c(.a(a), .b(b), .sel(sel), .o(o));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);

    tbf = $fopen("testbench.script", "w");
    outf = $fopen("output_verilog.txt", "w");

    $fdisplay(tbf, "read_blif es1.blif");
    
    sel <= 0;
    $display("Somme:");
    for (integer i = 0; i < 4; i++) begin
      a <= i;
      for (integer j = 0; j < 4; j++) begin
        b <= j;
        #2;
        
        if (a + b < 4) begin
          $fdisplay(tbf, "simulate %b %b %b %b %b", sel, a[1], a[0], b[1], b[0]);
          $display("%d + %d = %d", a, b, o);
          $fdisplay(outf, "Outputs: %b %b", o[1], o[0]);
        end
      end
    end
    
    sel <= 1;
    $display("Sottrazioni:");
    for (integer i = 0; i < 4; i++) begin
      a <= i;
      for (integer j = 0; j < 4; j++) begin
        b <= j;
        #2;

        if (a - b > -3) begin
          $fdisplay(tbf, "simulate %b %b %b %b %b", sel, a[1], a[0], b[1], b[0]);
          $display("%d - %d = %d", a, b, $signed(o));
          $fdisplay(outf, "Outputs: %b %b", o[1], o[0]);
        end
      end
    end


    $fdisplay(tbf, "quit");
    $fclose(tbf);
    $fclose(outf);
  end
endmodule
