module stall_unit (
  input i_clk,

  input i_memwb_mem_to_reg,
  input [4:0] i_memwb_rd,
  input [4:0] i_idex_rs1,
  input [4:0] i_idex_rs2,

  output reg o_decode,
  output reg o_execute,
  output reg o_memory,
  output reg o_write_back
  );
 
  initial begin
    o_decode = 0; 
    o_execute = 0; 
    o_memory = 0; 
    o_write_back = 0; 
  end

  always @ (*) begin
    o_execute = 0;
    o_memory = 0;
    o_write_back = 0;
    if (i_memwb_mem_to_reg) begin
      if (i_memwb_rd == i_idex_rs1 | i_memwb_rd == i_idex_rs2) begin
        o_decode <= 1'b1;
      end else begin
        o_decode <= 1'b0;
      end
    end else begin
      o_decode <= 1'b0;
    end
  end

  // always @ (negedge o_decode) begin
  //   o_execute <= 1'b1;
  // end
  // always @ (negedge o_execute) begin
  //   o_memory <= 1'b1;
  // end
  // always @ (negedge o_memory) begin
  //   o_write_back <= 1'b1;
  // end


  endmodule
