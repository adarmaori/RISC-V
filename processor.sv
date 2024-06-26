module processor (
  input i_clk
  // The rest of the ports (memory, data bus, etc will be placed later)
);
  // Register File Ports
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [63:0] reg_file_rs1_value;
  wire [63:0] reg_file_rs2_value;
  wire [63:0] reg_file_write_data;

  // IFID Pipeline Register
  wire [31:0] IFID_INST;
  wire [63:0] IFID_PC;

  // IDEX Pipeline Register
  wire [31:0] IDEX_INST;
  wire [63:0] IDEX_RS1_VALUE;
  wire [63:0] IDEX_RS2_VALUE;
  wire [63:0] IDEX_IMM;
  wire [63:0] IDEX_PC;
  wire [1:0] IDEX_ALU_OP;

  // EXMEM Pipeline Register
  wire [31:0] EXMEM_INST;
  wire [63:0] EXMEM_PC;
  wire [63:0] EXMEM_RS1_VALUE;
  wire [63:0] EXMEM_RS2_VALUE;
  wire [63:0] EXMEM_ALU_RES;
  wire [63:0] EXMEM_JMP_ADDR;

  // MEMWB Pipeline Register
  wire [31:0] MEMWB_INST; 
  wire [63:0] MEMWB_ALU_RES;
  wire [63:0] MEMWB_MEM_DATA;
  wire [63:0] MEMWB_RS1_VALUE;
  wire [63:0] MEMWB_RS2_VALUE;


  wire [63:0] FORWARD_RS1_EXE;
  wire [63:0] FORWARD_RS2_EXE;
  wire [63:0] FORWARD_RS2_MEM;

  // Pipeline management stuff
  wire DECODE_STALL = 0;
  wire EXECUTE_STALL = 0;
  wire MEMORY_ACCESS_STALL = 0;
  wire WRITE_BACK_STALL = 0;


  // DEBUG SIGNALS
  wire HAZARD_A1 = EXMEM_INST[11:7] == IDEX_INST[19:15] != 0; // EXMEM.Rd == IDEX.RS1
  wire HAZARD_B1 = EXMEM_INST[11:7] == IDEX_INST[24:20] != 0; // EXMEM.Rd == IDEX.RS2
  wire HAZARD_A2 = MEMWB_INST[11:7] == IDEX_INST[19:15] != 0; // MEMWB.Rd == IDEX.RS1
  wire HAZARD_B2 = MEMWB_INST[11:7] == IDEX_INST[24:20] != 0; // MEMWB.Rd == IDEX.RS1


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

  forwarding_unit forwarder (
    .i_exmem_rd_value  (EXMEM_ALU_RES),
    .i_memwb_rd_value  (MEMWB_ALU_RES),

    .i_idex_rs1_value  (IDEX_RS1_VALUE),
    .i_idex_rs2_value  (IDEX_RS2_VALUE),

    .i_memwb_mem_data  (MEMWB_MEM_DATA),
    .i_exmem_rs2_value (EXMEM_RS2_VALUE),

    .i_exmem_rd        (EXMEM_INST[11:7]),
    .i_memwb_rd        (MEMWB_INST[11:7]),
    .i_idex_rs1        (IDEX_INST[19:15]),
    .i_idex_rs2        (IDEX_INST[24:20]),

    .i_memwb_mem_to_reg (MEMWB_MEM_TO_REG),
    .i_exmem_mem_write  (EXMEM_MEM_WRITE),

    .o_exe_rs1_value  (FORWARD_RS1_EXE),
    .o_exe_rs2_value  (FORWARD_RS2_EXE),
    .o_mem_rs2_value  (FORWARD_RS2_MEM)
    );

  stall_unit staller (
    .i_clk (i_clk),
    .i_memwb_mem_to_reg (EXMEM_MEM_TO_REG),
    .i_memwb_rd         (EXMEM_INST[11:7]),
    .i_idex_rs1         (IDEX_INST[19:15]),
    .i_idex_rs2         (IDEX_INST[24:20]),
    .o_decode           (STALL)
    );

  instruction_fetch fetcher(
    .i_clk              (i_clk),
    .i_stall            (STALL),
    .i_flush            (EXMEM_BRANCH & EXMEM_ALU_ZERO),
    .i_address          (EXMEM_JMP_ADDR),
    .i_jmp              (EXMEM_BRANCH & EXMEM_ALU_ZERO),
    .o_ifid_instruction (IFID_INST),
    .o_ifid_pc          (IFID_PC)
    );

  instruction_decode decode(
    .i_clk         (i_clk),
    // .i_stall       (DECODE_STALL),
    .i_stall       (1'b0),
    .i_pc          (IFID_PC),
    .i_instruction (IFID_INST),
    .i_rs1_value   (reg_file_rs1_value),
    .i_rs2_value   (reg_file_rs2_value),

    .o_rs1_index   (rs1),
    .o_rs2_index   (rs2),

    .o_idex_instruction (IDEX_INST),
    .o_idex_rs1_value   (IDEX_RS1_VALUE),
    .o_idex_rs2_value   (IDEX_RS2_VALUE),
    .o_idex_immediate   (IDEX_IMM),
    .o_idex_pc          (IDEX_PC),

    .o_idex_alu_op      (IDEX_ALU_OP),
    .o_idex_alu_src     (IDEX_ALU_SRC),
    .o_idex_branch      (IDEX_BRANCH),
    .o_idex_mem_write   (IDEX_MEM_WRITE),
    .o_idex_mem_read    (IDEX_MEM_READ),
    .o_idex_mem_to_reg  (IDEX_MEM_TO_REG),
    .o_idex_reg_write   (IDEX_REG_WRITE)
    );

  execute executer (
    .i_clk         (i_clk),
    // .i_stall       (EXECUTE_STALL),
    .i_stall       (1'b0),
    .i_instruction (IDEX_INST),
    .i_pc          (IDEX_PC),
    .i_immediate   (IDEX_IMM),
    .i_rs1_value   (FORWARD_RS1_EXE),
    .i_rs2_value   (FORWARD_RS2_EXE),

    .i_alu_op      (IDEX_ALU_OP),
    .i_alu_src     (IDEX_ALU_SRC),
    .i_branch      (IDEX_BRANCH),
    .i_mem_write   (IDEX_MEM_WRITE),
    .i_mem_read    (IDEX_MEM_READ),
    .i_mem_to_reg  (IDEX_MEM_TO_REG),
    .i_reg_write   (IDEX_REG_WRITE),

    .o_exmem_instruction (EXMEM_INST),
    .o_exmem_pc          (EXMEM_PC),
    .o_exmem_rs1_value   (EXMEM_RS1_VALUE),
    .o_exmem_rs2_value   (EXMEM_RS2_VALUE),
    .o_exmem_alu_result  (EXMEM_ALU_RES),
    .o_exmem_alu_zero    (EXMEM_ALU_ZERO),
    .o_exmem_jmp_addr    (EXMEM_JMP_ADDR),

    .o_exmem_branch      (EXMEM_BRANCH),
    .o_exmem_mem_write   (EXMEM_MEM_WRITE),
    .o_exmem_mem_read    (EXMEM_MEM_READ),
    .o_exmem_mem_to_reg  (EXMEM_MEM_TO_REG),
    .o_exmem_reg_write   (EXMEM_REG_WRITE)
    );

  mem_access memory_accessor (
    .i_clk         (i_clk),
    // .i_stall       (MEMORY_ACCESS_STALL),
    .i_stall       (1'b0),
    .i_instruction (EXMEM_INST),
    .i_pc          (EXMEM_PC),
    .i_rs1_value   (EXMEM_RS1_VALUE),
    .i_rs2_value   (FORWARD_RS2_MEM),
    .i_alu_result  (EXMEM_ALU_RES),
    .i_alu_zero    (EXMEM_ALU_ZERO),

    .i_branch      (EXMEM_BRANCH),
    .i_mem_write   (EXMEM_MEM_WRITE),
    .i_mem_read    (EXMEM_MEM_READ),
    .i_mem_to_reg  (EXMEM_MEM_TO_REG),
    .i_reg_write   (EXMEM_REG_WRITE),

    .o_memwb_instruction (MEMWB_INST),
    .o_memwb_alu_result  (MEMWB_ALU_RES),
    .o_memwb_mem_data    (MEMWB_MEM_DATA),
    .o_memwb_rs1_value   (MEMWB_RS1_VALUE),
    .o_memwb_rs2_value   (MEMWB_RS2_VALUE),

    .o_memwb_reg_write   (MEMWB_REG_WRITE),
    .o_memwb_mem_to_reg  (MEMWB_MEM_TO_REG),
    .o_memwb_pc_src      (pc_src)
    );

  write_back writer (
    .i_clk         (i_clk),
    // .i_stall       (WRITE_BACK_STALL),
    .i_stall       (1'b0),
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
