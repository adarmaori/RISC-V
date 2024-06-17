module write_back (
  input i_clk,
  input i_stall,
  input [63:0] i_alu_result,
  input [63:0] i_mem_data,
  
  input [31:0] i_instruction,

  input i_reg_write,
  input i_mem_to_reg,

  output reg [4:0] o_rd_index,
  output reg [63:0] o_rd_data,
  output reg o_rd_we
  );

  reg [4:0] rd_index;
  reg [63:0] rd_data;
  reg rd_we;

  initial begin
    o_rd_we = 0;
    o_rd_data = 0;
    o_rd_index = 0;
  end
  // assign o_rd_index = rd_index;
  // assign o_rd_data = rd_data;
  // assign o_rd_we = rd_we;

  always @ (i_clk) begin
    if (i_clk) begin
      if (!i_stall) begin
        o_rd_index = i_instruction[11:7];
        o_rd_data = i_mem_to_reg ? i_mem_data : i_alu_result;
        o_rd_we = i_reg_write;
      end
    end else begin
      // o_rd_index = rd_index;
      // o_rd_data = rd_data;
      // o_rd_we = rd_we;
    end
  end


  
endmodule
