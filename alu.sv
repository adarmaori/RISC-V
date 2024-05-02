module alu(
  input [3:0] i_control,
  input [63:0] i_a,
  input [63:0] i_b,
  output [63:0] o_result,
  output o_zero
  );
  
  assign o_zero = o_result == 0;

  assign o_result = (i_control == 4'b0010) * (i_a + i_b) |
                    (i_control == 4'b0110) * (i_a - i_b) |
                    (i_control == 4'b0000) * (i_a & i_b) |
                    (i_control == 4'b0001) * (i_a | i_b);

  endmodule
