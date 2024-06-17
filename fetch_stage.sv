module instruction_fetch(
  input             i_clk,
  input             i_stall,
  input             i_flush,
  input      [63:0] i_address,
  input             i_jmp,
  // TODO: include memory interface
  output reg [31:0] o_instruction,
  output reg [63:0] o_pc
  );

  reg [31:0] memory [4096];

  parameter NOP = 32'b0000000_00000_00000_000_00000_0110011;

  initial begin
    memory[0]  = 32'b0000000_00000_00001_000_00010_0110011; //ADD X2, X1, X0
    memory[4]  = 32'b0000000_00000_00001_000_00011_0110011; //ADD X3, X1, X0
    memory[8]  = 32'b0000000_00010_00100_000_01010_0000010; //ST X2, 10(X4)  
    memory[12]  = 32'b0000000_00011_00100_000_01011_0000010; //ST X3, 11(X4) 
    memory[16] = 32'b0000000_00010_00011_000_00010_0110011; //ADD X2, X2, X3 
    memory[20] = 32'b0000000_00010_00011_000_00011_0110011; //ADD X2, X2, X3 
    memory[24] = 32'b0000000_00100_00001_000_00100_0110011; //ADD X4, X4, X1 
    memory[28] = 32'b1111111_00000_00000_000_01011_1100011; //BEQ 0, 0, -24(X0)
    memory[32] = NOP;
    memory[36] = NOP;
    memory[40] = NOP;
    memory[44] = NOP;
  end
  reg  [63:0] pc          = 0;
  reg  [31:0] instruction = 0;
  wire [63:0] pc_next     = pc + 4;

  initial begin
    o_instruction = 0;
    o_pc = 0;
  end
  always @ (posedge i_clk) begin
    if (!i_stall) begin
      pc          <= i_jmp? i_address : pc_next;
      // pc <= pc_next;
      instruction <= i_flush ? 32'b0 : memory[pc];
    end
  end

  always @ (negedge i_clk) begin
    if (!i_stall & !i_flush) begin
      o_pc          <= pc_next;
      o_instruction <= instruction;
    end else if (i_flush) begin
      o_pc <= 0;
      o_instruction <= 0;
      instruction <= 0;
    end else if (i_stall) begin
      o_instruction <= 32'b0000000_00000_00000_000_00000_0110011;
    end
  end


  endmodule
