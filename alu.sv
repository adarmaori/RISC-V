module alu(
  input [3:0] i_control,
  input [63:0] i_a,
  input [63:0] i_b,
  output [63:0] o_result,
  output o_zero
  );
  
  assign o_zero = o_result == 0;

  assign o_result = (i_control == 4'b0000) * (i_a + i_b) | // ADD
                    (i_control == 4'b0001) * (i_a - i_b) | // SUB
                    (i_control == 4'b0010) * (i_a <<< i_b[4:0]) | // SLL TODO: verify shift syntax
                    (i_control == 4'b0100) * {31'b0, ($signed(i_a) < $signed(i_b))} | // SLT TODO: test
                    (i_control == 4'b0110) * {31'b0, (i_a < i_b)} | // SLTU TODO: test
                    (i_control == 4'b1000) * (i_a ^ i_b) | // XOR
                    (i_control == 4'b1010) * (i_a >>> i_b[4:0]) | // SRL TODO: verify shift syntax
                    (i_control == 4'b1011) * (i_a >> i_b[4:0]) | // SRA TODO: verify shift syntax
                    (i_control == 4'b1100) * (i_a | i_b) | // OR
                    (i_control == 4'b1110) * (i_a & i_b); // AND
  endmodule
