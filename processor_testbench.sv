module tb;
  reg clk;
  processor uut (
    .i_clk (clk)
    );

  initial begin
    clk = 0;
    $dumpfile("output.vcd");
    $dumpvars;
    #10000 $finish;
  end

  always #100 clk = ~clk;


  
endmodule
