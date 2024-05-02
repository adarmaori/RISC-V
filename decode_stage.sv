module instruction_decode(
  input i_clk,
  input i_enable,
  input [63:0] i_pc,
  input [31:0] i_instruction,
  input [63:0] i_rs1_value,
  input [63:0] i_rs2_value,

  // reg file read interface
  output [4:0] o_rs1_index,
  output [4:0] o_rs2_index,

  // pipeline regiter
  output reg [31:0] o_instruction,
  output reg [63:0] o_rs1_value,
  output reg [63:0] o_rs2_value,
  output reg [63:0] o_immediate, // TODO: handle the immediate
  output reg [63:0] o_pc,

  output reg [1:0] o_alu_op,
  output reg o_alu_src,
  output reg o_branch,
  output reg o_mem_write,
  output reg o_mem_read,
  output reg o_mem_to_reg,
  output reg o_reg_write
  );
  
  parameter LD = 7'b0000001;  // TODO: figure out the actual opcodes
  parameter SD = 7'b0000010; 

  
  reg [63:0] rs1_value;
  reg [63:0] rs2_value;

   assign o_rs1_index = i_instruction[19:15];
   assign o_rs2_index = i_instruction[24:20];
  reg [31:0] instruction = 0;
  reg [63:0] pc;
  reg [63:0] immediate;
  reg [1:0] alu_op;
  reg alu_src;
  reg branch;
  reg mem_write;
  reg mem_read;
  reg mem_to_reg;
  reg reg_write;

  always @ (posedge i_clk) begin
    instruction <= i_instruction;
    pc <= i_pc;
    rs1_value = i_rs1_value;
    rs2_value = i_rs2_value;

    case (i_instruction[6:0]) // opcode
      7'b0110011: begin // R-format
        alu_op     <= 2'b10;
        alu_src    <= 1'b0;
        branch     <= 1'b0;
        mem_write  <= 1'b0;
        mem_read   <= 1'b0;
        mem_to_reg <= 1'b0;
        reg_write  <= 1'b1;
      end
      LD: begin
        alu_op     <= 2'b00;
        alu_src    <= 1'b1;
        branch     <= 1'b0;
        mem_write  <= 1'b0;
        mem_read   <= 1'b1;
        mem_to_reg <= 1'b1;
        reg_write  <= 1'b1;
        immediate  <= {{52{i_instruction[31]}}, i_instruction[31:20]};
      end
      SD: begin
        alu_op     <= 2'b00;
        alu_src    <= 1'b1;
        branch     <= 1'b0;
        mem_write  <= 1'b1;
        mem_read   <= 1'b0;
        reg_write  <= 1'b0;
        immediate  <= {{52{i_instruction[31]}}, i_instruction[31:25], i_instruction[11:7]};
      end
      7'b1100011: begin // beq
        alu_op     <= 2'b01;
        alu_src    <= 1'b0;
        branch     <= 1'b1;
        mem_write  <= 1'b0;
        mem_read   <= 1'b0;
        reg_write  <= 1'b0;
        immediate  <= {{52{i_instruction[31]}}, i_instruction[7], i_instruction[30:25], i_instruction[11:8], 1'b0};
      end
      
      default: begin end
      
    endcase
  end
  
  always @ (negedge i_clk) begin
    o_pc <= pc;
    o_instruction <= instruction;
    o_rs1_value <= rs1_value;
    o_rs2_value <= rs2_value;
    o_alu_op <= alu_op;
    o_alu_src <= alu_src;
    o_branch <= branch;
    o_mem_write <= mem_write;
    o_mem_read <= mem_read;
    o_mem_to_reg <= mem_to_reg;
    o_reg_write <= reg_write;
    o_immediate <= immediate;
  end
  endmodule
