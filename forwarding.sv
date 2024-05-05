module forwarding_unit (
    input [63:0] i_memwb_rd_value,
    input [63:0] i_exmem_rd_value,

    input [63:0] i_idex_rs1_value,
    input [63:0] i_idex_rs2_value,

    input [63:0] i_memwb_mem_data,
    input [63:0] i_exmem_rs2_value,

    input [4:0] i_exmem_rd,
    input [4:0] i_memwb_rd,
    input [4:0] i_idex_rs1,
    input [4:0] i_idex_rs2,

    input i_memwb_mem_to_reg, // For detecting copy hazards (load followed immediately by a store)
    input i_exmem_mem_write,

    output [63:0] o_exe_rs1_value,
    output [63:0] o_exe_rs2_value,

    output [63:0] o_mem_rs2_value
  );

    // TODO: refactor
    assign o_exe_rs1_value = (i_exmem_rd == i_idex_rs1 != 0) ? 
      i_exmem_rd_value : (
      (i_memwb_rd == i_idex_rs1 != 0) ? (
      i_memwb_mem_to_reg ? i_memwb_mem_data : i_memwb_rd_value) : i_idex_rs1_value
      );
    assign o_exe_rs2_value = (i_exmem_rd == i_idex_rs2 != 0) ? 
      i_exmem_rd_value : (
      (i_memwb_rd == i_idex_rs2 != 0) ? i_memwb_rd_value : i_idex_rs2_value
      );


    // LOAD HAZARDS
    assign o_mem_rs2_value = (i_memwb_mem_to_reg & i_exmem_mem_write) ? i_memwb_mem_data : i_exmem_rs2_value;

  endmodule
