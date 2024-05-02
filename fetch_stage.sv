module instruction_fetch(
  input             i_clk,
  input             i_enable,
  input      [63:0] i_address,
  input             i_jmp,
  // TODO: include memory interface
  output reg [31:0] o_instruction,
  output reg [63:0] o_pc
  );

  reg [31:0] memory [4096];
  initial begin
    memory[0]  = 32'b000000110000_00001_000_01101_0000001;// LD x13, 48(x1)
    memory[4]  = 32'b0000001_01110_01110_000_10001_0000010; // SD x14, 49(x14)
    memory[8]  = 32'b0000000_00110_00111_000_00101_0110011; // ADD x5, x6, x7
    memory[12] = 32'b0100000_00010_00100_000_00100_0110011; // SUB X4, X2, X4
  end
  reg  [63:0] pc          = 0;
  reg  [31:0] instruction = 0;
  wire [63:0] pc_next     = pc + 4;

  always @ (posedge i_clk) begin
    if (i_enable) begin
      pc          <= pc_next;
      instruction <= memory[pc];
    end
  end

  always @ (negedge i_clk) begin
    o_pc          <= pc;
    o_instruction <= instruction;
  end


  endmodule
