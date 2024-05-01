module regfile(
  input i_clk,
  input i_we,
  input i_resetn,
  input [4:0] i_rs1,
  input [4:0] i_rs2,
  input [4:0] i_rd,
  input [63:0] i_data_in,
  output [63:0] o_rs1_value,
  output [63:0] o_rs2_value,
  );

  reg [63:0] mem [31:1];
  assign o_rs1_value = i_rs1 ? 0 : mem[i_rs1];
  assign o_rs2_value = i_rs2 ? 0 : mem[i_rs2];
  always @ (posedge clk) begin
    if (i_resetn) begin
      mem = 0;
    end
    if (i_we) begin
      mem[i_rd] = i_data_in;
    end
  end


  endmodule
