module instruction_fetch(
  input i_clk,
  input i_enable,
  input [63:0] i_address,
  input i_jmp,
  // TODO: include memory interface
  output [31:0] o_instruction,
  output [63:0] o_pc
  );

  reg [31:0] memory [4096];
  initial begin
    memory[0] = 32'b000000110000_00001_000_01101_0000001;// LD x13, 48(x1)
    memory[4] = 32'b0000001_1101_1101_000_10001_0000010; // SD x13, 49(x13)
  end
  reg [63:0] pc = 0;
  reg [31:0] instruction = 0;
  assign o_instruction = instruction;
  wire [63:0] pc_next = pc + 4;
  assign o_pc = pc_next;

  always @ (posedge i_clk) begin
    if (i_enable) begin
      instruction <= memory[pc];
      pc <= pc_next;
    end
  end


  endmodule
