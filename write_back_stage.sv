module write_back (
  input i_clk,
  input [63:0] i_alu_result,
  input [63:0] i_mem_data,
  
  input [31:0] i_instruction,

  input i_reg_write,
  input i_mem_to_reg,

  output [4:0] o_rd_index,
  output [63:0] o_rd_data,
  output o_rd_we
  );

  reg [4:0] rd_index;
  reg [63:0] rd_data;
  reg rd_we;

  assign o_rd_index = rd_index;
  assign o_rd_data = rd_data;
  assign o_rd_we = rd_we;

  always @ (posedge i_clk) begin
    rd_index <= i_instruction[11:7];
    rd_data <= i_mem_to_reg ? i_mem_data : i_alu_result;
    rd_we <= i_reg_write;
  end


  
endmodule
