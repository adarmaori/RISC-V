module execute (
  input i_clk,
  input [31:0] i_instruction,
  input [63:0] i_pc,
  input [63:0] i_immediate,
  input [63:0] i_rs1_value,
  input [63:0] i_rs2_value,

  input [1:0] i_alu_op,
  input i_alu_src,
  input i_branch,
  input i_mem_write,
  input i_mem_read,
  input i_mem_to_reg,
  input i_reg_write,

  output [31:0] o_instruction,
  output [63:0] o_pc,
  output [63:0] o_rs2_value,
  output [63:0] o_alu_result,
  output o_alu_zero,
  output [63:0] o_jmp_addr,

  output o_branch,
  output o_mem_write,
  output o_mem_read,
  output o_mem_to_reg,
  output o_reg_write

);

  wire [63:0] w_alu_result;

  alu ALU (
    .i_control (alu_control),
    .i_a (alu_a),
    .i_b (alu_b),
    .o_result (w_alu_result),
    .o_zero (w_alu_zero)
    );


  reg [1:0] alu_op;
  reg alu_src;
  reg branch;
  reg mem_write;
  reg mem_read;
  reg mem_to_reg;
  reg reg_write;
  reg [63:0] rs2_value;
  reg [31:0] instruction= 0;
  reg [63:0] pc;
  reg [63:0] jmp_addr;

  reg [63:0] alu_a;
  reg [63:0] alu_b;
  reg [3:0] alu_control;
  reg [63:0] alu_result;
  reg alu_zero;

  assign o_branch = branch;
  assign o_mem_write = mem_write;
  assign o_mem_read = mem_read;
  assign o_mem_to_reg = mem_to_reg;
  assign o_reg_write = reg_write;
  
  assign o_rs2_value = rs2_value;
  assign o_instruction = instruction;
  assign o_pc = pc;
  assign o_alu_zero = alu_zero;
  assign o_alu_result = alu_result;
  assign o_jmp_addr = jmp_addr;


  always @ (posedge i_clk)  begin
    instruction <= i_instruction;
    branch <= i_branch;
    mem_write <= i_mem_write;
    mem_read <= i_mem_read;
    mem_to_reg <= i_mem_to_reg;
    reg_write <= i_reg_write;
    rs2_value <= i_rs2_value;
    alu_src <= i_alu_src;

    alu_a <= i_rs1_value;
    alu_b <= i_alu_src ? i_immediate : i_rs2_value;
    case (i_alu_op) 
      2'b00: alu_control <= 4'b0010;
      2'b01: alu_control <= 4'b0110;
      2'b10: begin
        case (i_instruction[14:12])
          3'b000: alu_control <= {1'b0, i_instruction[3], 2'b10}; // Generating the difference between ADD and SUB
          3'b111: alu_control <= 4'b0000;
          3'b110: alu_control <= 4'b0001;
          default : begin end
        endcase
      end
      
      default : begin end
    endcase

    alu_result <= w_alu_result;
    alu_zero <= w_alu_zero;
    jmp_addr <= i_pc + {i_immediate, 1'b0};
  end

endmodule
