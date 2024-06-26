module execute (
  input             i_clk,
  input             i_stall,
  input [31:0]      i_instruction,
  input [63:0]      i_pc,
  input [63:0]      i_immediate,
  input [63:0]      i_rs1_value,
  input [63:0]      i_rs2_value,

  input [1:0]       i_alu_op,
  input             i_alu_src,
  input             i_branch,
  input             i_mem_write,
  input             i_mem_read,
  input             i_mem_to_reg,
  input             i_reg_write,

  output reg [31:0] o_exmem_instruction,
  output reg [63:0] o_exmem_pc,
  output reg [63:0] o_exmem_rs1_value,
  output reg [63:0] o_exmem_rs2_value,
  output reg [63:0] o_exmem_alu_result,
  output reg        o_exmem_alu_zero,
  output reg [63:0] o_exmem_jmp_addr,

  output reg        o_exmem_branch,
  output reg        o_exmem_mem_write,
  output reg        o_exmem_mem_read,
  output reg        o_exmem_mem_to_reg,
  output reg        o_exmem_reg_write

);

  wire [63:0] w_alu_result;

  alu ALU (
    .i_control (alu_control),
    .i_a (alu_a),
    .i_b (alu_b),
    .o_result (w_alu_result),
    .o_zero (w_alu_zero)
    );


  reg [1:0] alu_op = 0;
  reg alu_src = 0;
  reg branch = 0;
  reg mem_write = 0;
  reg mem_read = 0;
  reg mem_to_reg = 0;
  reg reg_write = 0;
  reg [63:0] rs1_value = 0;
  reg [63:0] rs2_value = 0;
  reg [31:0] instruction= 0;
  reg [63:0] pc = 0;
  reg [63:0] jmp_addr = 0;

  reg [63:0] alu_a = 0;
  reg [63:0] alu_b = 0;
  reg [3:0] alu_control = 0;
  reg [63:0] alu_result = 0;
  reg alu_zero;
  
  initial begin
     o_exmem_instruction = 0;
     o_exmem_pc = 0;
     o_exmem_rs1_value = 0;
     o_exmem_rs2_value = 0;
     o_exmem_alu_result = 0;
     o_exmem_alu_zero = 0;
     o_exmem_jmp_addr = 0;

     o_exmem_branch = 0;
     o_exmem_mem_write = 0; 
     o_exmem_mem_read = 0;
     o_exmem_mem_to_reg = 0;
     o_exmem_reg_write = 0;
  end


  always @ (posedge i_clk)  begin
    if (!i_stall) begin
      instruction <= i_instruction;
      branch <= i_branch;
      mem_write <= i_mem_write;
      mem_read <= i_mem_read;
      mem_to_reg <= i_mem_to_reg;
      reg_write <= i_reg_write;
      rs1_value <= i_rs1_value;
      rs2_value <= i_rs2_value;
      alu_src <= i_alu_src;

      alu_a <= i_rs1_value; 
      alu_b <= i_alu_src ? i_immediate : i_rs2_value;

      jmp_addr <= i_pc + i_immediate + i_immediate + 16;

      // case (i_alu_op) 
      //   2'b00: alu_control <= 4'b0010;
      //   2'b01: alu_control <= 4'b0110;
      //   2'b10: begin
      //     case (i_instruction[14:12])
      //       3'b000: alu_control <= {1'b0, i_instruction[30], 2'b10}; // Generating the difference between ADD and SUB
      //       3'b111: alu_control <= 4'b0000;
      //       3'b110: alu_control <= 4'b0001;
      //       default : begin end
      //     endcase
      //   end
      //   
      //   default : begin end
      // endcase
      // TODO: check if the commented block above is actually needed
      alu_control <= {i_instruction[14:12], i_instruction[30]};

    end
  end

  always @ (negedge i_clk) begin
    if (!i_stall) begin
      o_exmem_branch <= branch;
      o_exmem_mem_write <= mem_write;
      o_exmem_mem_read <= mem_read;
      o_exmem_mem_to_reg <= mem_to_reg;
      o_exmem_reg_write <= reg_write;

      o_exmem_rs1_value <= rs1_value;
      o_exmem_rs2_value <= rs2_value;
      o_exmem_instruction <= instruction;
      o_exmem_pc <= pc;
      o_exmem_alu_zero <= w_alu_zero;
      o_exmem_alu_result <= w_alu_result;
      o_exmem_jmp_addr <= jmp_addr;

    end
  end
endmodule
