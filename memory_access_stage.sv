module mem_access (
  input i_clk,
  input [31:0] i_instruction,
  input [63:0] i_pc,
  input [63:0] i_rs2_value,
  input [63:0] i_alu_result,
  input i_alu_zero,

  input i_branch,
  input i_mem_write,
  input i_mem_read,
  input i_mem_to_reg,
  input i_reg_write,

  output reg [31:0] o_instruction,
  output reg [63:0] o_alu_result,
  output reg [63:0] o_mem_data,

  output reg o_reg_write,
  output reg o_mem_to_reg,
  output reg o_pc_src
  // TODO: implement access point to external memory
);
  
  reg [31:0] data_memory [128];

  initial begin
    data_memory[49] = 5;
  end
  reg [31:0] instruction;
  reg [63:0] pc;
  reg [31:0] alu_result;
  reg [63:0] mem_data;


  reg [63:0] to_write;
  reg mem_write;
  reg mem_to_reg;
  reg pc_src;
  reg reg_write;


  // DEBUG SIGNALS
  wire [31:0] m49 = data_memory[49];
  wire [31:0] m54 = data_memory[54];
  wire [31:0] m46 = data_memory[46];
  wire [31:0] m63 = data_memory[63];
  always @ (posedge i_clk) begin
    instruction <= i_instruction;
    reg_write <= i_reg_write;
    mem_to_reg <= i_mem_to_reg;
    pc_src <= i_alu_zero & i_branch;
    alu_result = i_alu_result;
    to_write = {32'b0, data_memory[i_alu_result]};
    if (i_mem_write) begin
      data_memory[i_alu_result] <= i_rs2_value;
    end else if (i_mem_to_reg) begin
      mem_data <= to_write;
      // mem_data <= 8'h55;
    end
  end

  always @ (negedge i_clk) begin
    o_alu_result <= alu_result;
    o_mem_data <= mem_data;
    o_mem_to_reg <= mem_to_reg;
    o_reg_write <= reg_write;
    o_pc_src <= pc_src;
    o_instruction <= instruction;
  end
endmodule
