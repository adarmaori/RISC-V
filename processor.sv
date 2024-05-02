module processor (
  input i_clk
  // The rest of the ports (memory, data bus, etc will be placed later)
);

  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [63:0] reg_file_rs1_value;
  wire [63:0] reg_file_rs2_value;
  wire [63:0] reg_file_write_data;
  wire [31:0] IFID_INST;
  wire [63:0] IFID_PC;
  wire [31:0] IDEX_INST;
  wire [63:0] IDEX_RS1;
  wire [63:0] IDEX_RS2;
  wire [63:0] IDEX_IMM;
  wire [63:0] IDEX_PC;
  wire [1:0] IDEX_ALU_OP;
  wire [31:0] EXMEM_INST;
  wire [63:0] EXMEM_PC;
  wire [63:0] EXMEM_RS2_VAL;
  wire [63:0] EXMEM_ALU_RES;
  wire [63:0] jmp_addr;
  wire [31:0] MEMWB_INST; 
  wire [63:0] MEMWB_ALU_RES;
  wire [63:0] MEMWB_MEM_DATA;



  regfile reg_file (
    .i_clk       (i_clk), 
    .i_we        (reg_file_write_en),
    .i_resetn    (1'b0),
    .i_rs1       (rs1),
    .i_rs2       (rs2),
    .i_rd        (rd),
    .i_data_in   (reg_file_write_data),
    .o_rs1_value (reg_file_rs1_value),
    .o_rs2_value (reg_file_rs2_value)
    );

  instruction_fetch fetcher(
    .i_clk         (i_clk),
    .i_enable      (1'b1),
    .i_address     (),
    .i_jmp         (),
    .o_instruction (IFID_INST),
    .o_pc          (IFID_PC)
    );

  instruction_decode decode(
    .i_clk         (i_clk),
    .i_enable      (1'b1),
    .i_pc          (IFID_PC),
    .i_instruction (IFID_INST),
    .i_rs1_value   (reg_file_rs1_value),
    .i_rs2_value   (reg_file_rs2_value),

    .o_rs1_index   (rs1),
    .o_rs2_index   (rs2),

    .o_instruction (IDEX_INST),
    .o_rs1_value   (IDEX_RS1),
    .o_rs2_value   (IDEX_RS2),
    .o_immediate   (IDEX_IMM),
    .o_pc          (IDEX_PC),

    .o_alu_op      (IDEX_ALU_OP),
    .o_alu_src     (IDEX_ALU_SRC),
    .o_branch      (IDEX_BRANCH),
    .o_mem_write   (IDEX_MEM_WRITE),
    .o_mem_read    (IDEX_MEM_READ),
    .o_mem_to_reg  (IDEX_MEM_TO_REG),
    .o_reg_write   (IDEX_REG_WRITE)
    );

  execute executer (
    .i_clk         (i_clk),
    .i_instruction (IDEX_INST),
    .i_pc          (IDEX_PC),
    .i_immediate   (IDEX_IMM),
    .i_rs1_value   (IDEX_RS1),
    .i_rs2_value   (IDEX_RS2),

    .i_alu_op      (IDEX_ALU_OP),
    .i_alu_src     (IDEX_ALU_SRC),
    .i_branch      (IDEX_BRANCH),
    .i_mem_write   (IDEX_MEM_WRITE),
    .i_mem_read    (IDEX_MEM_READ),
    .i_mem_to_reg  (IDEX_MEM_TO_REG),
    .i_reg_write   (IDEX_REG_WRITE),


    .o_instruction (EXMEM_INST),
    .o_pc          (EXMEM_PC),
    .o_rs2_value   (EXMEM_RS2_VAL),
    .o_alu_result  (EXMEM_ALU_RES),
    .o_alu_zero    (EXMEM_ALU_ZERO),
    .o_jmp_addr    (jmp_addr),

    .o_branch      (EXMEM_BRANCH),
    .o_mem_write   (EXMEM_MEM_WRITE),
    .o_mem_read    (EXMEM_MEM_READ),
    .o_mem_to_reg  (EXMEM_MEM_TO_REG),
    .o_reg_write   (EXMEM_REG_WRITE)
    );

  mem_access memory_accessor (
    .i_clk         (i_clk),
    .i_instruction (EXMEM_INST),
    .i_pc          (EXMEM_PC),
    .i_rs2_value   (EXMEM_RS2_VAL),
    .i_alu_result  (EXMEM_ALU_RES),
    .i_alu_zero    (EXMEM_ALU_ZERO),

    .i_branch      (EXMEM_BRANCH),
    .i_mem_write   (EXMEM_MEM_WRITE),
    .i_mem_read    (EXMEM_MEM_READ),
    .i_mem_to_reg  (EXMEM_MEM_TO_REG),
    .i_reg_write   (EXMEM_REG_WRITE),

    .o_instruction (MEMWB_INST),
    .o_alu_result  (MEMWB_ALU_RES),
    .o_mem_data    (MEMWB_MEM_DATA),

    .o_reg_write   (MEMWB_REG_WRITE),
    .o_mem_to_reg  (MEMWB_MEM_TO_REG),
    .o_pc_src      (pc_src)
    );

  write_back writer (
    .i_clk         (i_clk),
    .i_mem_data    (MEMWB_MEM_DATA),
    .i_alu_result  (MEMWB_ALU_RES),
    .i_instruction (MEMWB_INST),
    .i_reg_write   (MEMWB_REG_WRITE),
    .i_mem_to_reg  (MEMWB_MEM_TO_REG),
    .o_rd_index    (rd),
    .o_rd_data     (reg_file_write_data),
    .o_rd_we       (reg_file_write_en)
    );
endmodule
