module alu(
  input [3:0] control,
  input [63:0] a,
  input [63:0] b,
  output [63:0] result,
  output carry,
  output zero
  );
  
  assign zero = result == 0;

  assign result = (control == 0) ? a + b :
                  (control == 1) ? a - b :
                  (control == 2) ? a & b :
                  (control == 3) ? a | b;

  endmodule
