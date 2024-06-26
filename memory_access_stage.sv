module mem_access (
  input i_clk,
  input i_stall,
  input [31:0] i_instruction,
  input [63:0] i_pc,
  input [63:0] i_rs1_value,
  input [63:0] i_rs2_value,
  input [63:0] i_alu_result,
  input i_alu_zero,

  input i_branch,
  input i_mem_write,
  input i_mem_read,
  input i_mem_to_reg,
  input i_reg_write,

  output reg [31:0] o_memwb_instruction,
  output reg [63:0] o_memwb_alu_result,
  output reg [63:0] o_memwb_mem_data,
  output reg [63:0] o_memwb_rs1_value,
  output reg [63:0] o_memwb_rs2_value,

  output reg o_memwb_reg_write,
  output reg o_memwb_mem_to_reg,
  output reg o_memwb_pc_src
  // TODO: implement access point to external memory
);
  
  reg [31:0] data_memory [128];

  initial begin
    data_memory[49] = 5;
    o_memwb_instruction = 0;
    o_memwb_alu_result = 0;
    o_memwb_mem_data = 0;
    o_memwb_rs1_value = 0;
    o_memwb_rs2_value = 0;

    o_memwb_reg_write = 0;
    o_memwb_mem_to_reg = 0;
    o_memwb_pc_src = 0;
  end

  reg [31:0] instruction;
  reg [63:0] pc;
  reg [31:0] alu_result;
  reg [63:0] mem_data;
  reg [63:0] rs1_value;
  reg [63:0] rs2_value;


  reg [63:0] to_write;
  reg mem_write;
  reg mem_to_reg;
  reg pc_src;
  reg reg_write;


  // DEBUG SIGNALS
  wire [31:0] mem0 = data_memory[0];
  wire [31:0] mem1 = data_memory[1];
  wire [31:0] mem2 = data_memory[2];
  wire [31:0] mem3 = data_memory[3];
  wire [31:0] mem4 = data_memory[4];
  wire [31:0] mem5 = data_memory[5];
  wire [31:0] mem6 = data_memory[6];
  wire [31:0] mem7 = data_memory[7];
  wire [31:0] mem8 = data_memory[8];
  wire [31:0] mem9 = data_memory[9];
  wire [31:0] mem10 = data_memory[10];
  wire [31:0] mem11 = data_memory[11];
  wire [31:0] mem12 = data_memory[12];
  wire [31:0] mem13 = data_memory[13];
  wire [31:0] mem14 = data_memory[14];
  wire [31:0] mem15 = data_memory[15];
  wire [31:0] mem16 = data_memory[16];
  wire [31:0] mem17 = data_memory[17];
  wire [31:0] mem18 = data_memory[18];
  wire [31:0] mem19 = data_memory[19];
  wire [31:0] mem20 = data_memory[20];
  wire [31:0] mem21 = data_memory[21];
  wire [31:0] mem22 = data_memory[22];
  wire [31:0] mem23 = data_memory[23];
  wire [31:0] mem24 = data_memory[24];
  wire [31:0] mem25 = data_memory[25];
  wire [31:0] mem26 = data_memory[26];
  wire [31:0] mem27 = data_memory[27];
  wire [31:0] mem28 = data_memory[28];
  wire [31:0] mem29 = data_memory[29];
  wire [31:0] mem30 = data_memory[30];
  wire [31:0] mem31 = data_memory[31];
  wire [31:0] mem32 = data_memory[32];
  wire [31:0] mem33 = data_memory[33];
  wire [31:0] mem34 = data_memory[34];
  wire [31:0] mem35 = data_memory[35];
  wire [31:0] mem36 = data_memory[36];
  wire [31:0] mem37 = data_memory[37];
  wire [31:0] mem38 = data_memory[38];
  wire [31:0] mem39 = data_memory[39];
  wire [31:0] mem40 = data_memory[40];
  wire [31:0] mem41 = data_memory[41];
  wire [31:0] mem42 = data_memory[42];
  wire [31:0] mem43 = data_memory[43];
  wire [31:0] mem44 = data_memory[44];
  wire [31:0] mem45 = data_memory[45];
  wire [31:0] mem46 = data_memory[46];
  wire [31:0] mem47 = data_memory[47];
  wire [31:0] mem48 = data_memory[48];
  wire [31:0] mem49 = data_memory[49];
  wire [31:0] mem50 = data_memory[50];
  wire [31:0] mem51 = data_memory[51];
  wire [31:0] mem52 = data_memory[52];
  wire [31:0] mem53 = data_memory[53];
  wire [31:0] mem54 = data_memory[54];
  wire [31:0] mem55 = data_memory[55];
  wire [31:0] mem56 = data_memory[56];
  wire [31:0] mem57 = data_memory[57];
  wire [31:0] mem58 = data_memory[58];
  wire [31:0] mem59 = data_memory[59];
  wire [31:0] mem60 = data_memory[60];
  wire [31:0] mem61 = data_memory[61];
  wire [31:0] mem62 = data_memory[62];
  wire [31:0] mem63 = data_memory[63];
  wire [31:0] mem64 = data_memory[64];
  wire [31:0] mem65 = data_memory[65];
  wire [31:0] mem66 = data_memory[66];
  wire [31:0] mem67 = data_memory[67];
  wire [31:0] mem68 = data_memory[68];
  wire [31:0] mem69 = data_memory[69];
  wire [31:0] mem70 = data_memory[70];
  wire [31:0] mem71 = data_memory[71];
  wire [31:0] mem72 = data_memory[72];
  wire [31:0] mem73 = data_memory[73];
  wire [31:0] mem74 = data_memory[74];
  wire [31:0] mem75 = data_memory[75];
  wire [31:0] mem76 = data_memory[76];
  wire [31:0] mem77 = data_memory[77];
  wire [31:0] mem78 = data_memory[78];
  wire [31:0] mem79 = data_memory[79];
  wire [31:0] mem80 = data_memory[80];
  wire [31:0] mem81 = data_memory[81];
  wire [31:0] mem82 = data_memory[82];
  wire [31:0] mem83 = data_memory[83];
  wire [31:0] mem84 = data_memory[84];
  wire [31:0] mem85 = data_memory[85];
  wire [31:0] mem86 = data_memory[86];
  wire [31:0] mem87 = data_memory[87];
  wire [31:0] mem88 = data_memory[88];
  wire [31:0] mem89 = data_memory[89];
  wire [31:0] mem90 = data_memory[90];
  wire [31:0] mem91 = data_memory[91];
  wire [31:0] mem92 = data_memory[92];
  wire [31:0] mem93 = data_memory[93];
  wire [31:0] mem94 = data_memory[94];
  wire [31:0] mem95 = data_memory[95];
  wire [31:0] mem96 = data_memory[96];
  wire [31:0] mem97 = data_memory[97];
  wire [31:0] mem98 = data_memory[98];
  wire [31:0] mem99 = data_memory[99];
  wire [31:0] mem100 = data_memory[100];
  wire [31:0] mem101 = data_memory[101];
  wire [31:0] mem102 = data_memory[102];
  wire [31:0] mem103 = data_memory[103];
  wire [31:0] mem104 = data_memory[104];
  wire [31:0] mem105 = data_memory[105];
  wire [31:0] mem106 = data_memory[106];
  wire [31:0] mem107 = data_memory[107];
  wire [31:0] mem108 = data_memory[108];
  wire [31:0] mem109 = data_memory[109];
  wire [31:0] mem110 = data_memory[110];
  wire [31:0] mem111 = data_memory[111];
  wire [31:0] mem112 = data_memory[112];
  wire [31:0] mem113 = data_memory[113];
  wire [31:0] mem114 = data_memory[114];
  wire [31:0] mem115 = data_memory[115];
  wire [31:0] mem116 = data_memory[116];
  wire [31:0] mem117 = data_memory[117];
  wire [31:0] mem118 = data_memory[118];
  wire [31:0] mem119 = data_memory[119];
  wire [31:0] mem120 = data_memory[120];
  wire [31:0] mem121 = data_memory[121];
  wire [31:0] mem122 = data_memory[122];
  wire [31:0] mem123 = data_memory[123];
  wire [31:0] mem124 = data_memory[124];
  wire [31:0] mem125 = data_memory[125];
  wire [31:0] mem126 = data_memory[126];
  wire [31:0] mem127 = data_memory[127];

  always @ (posedge i_clk) begin
    if (!i_stall) begin
      instruction <= i_instruction;
      rs1_value <= i_rs1_value;
      rs2_value <= i_rs2_value;
      reg_write <= i_reg_write;
      mem_to_reg <= i_mem_to_reg;
      pc_src <= i_alu_zero & i_branch;
      alu_result = i_alu_result;
      to_write = {32'b0, data_memory[i_alu_result]};
      if (i_mem_write) begin
        data_memory[i_alu_result] <= i_rs2_value;
      end else if (i_mem_to_reg) begin
        mem_data <= to_write;
        // mem_data <= 8'h55;
      end
    end
  end

  always @ (negedge i_clk) begin
    if (!i_stall) begin
      o_memwb_alu_result <= alu_result;
      o_memwb_rs1_value <= rs1_value;
      o_memwb_rs2_value <= rs2_value;
      o_memwb_mem_data <= mem_data;
      o_memwb_mem_to_reg <= mem_to_reg;
      o_memwb_reg_write <= reg_write;
      o_memwb_pc_src <= pc_src;
      o_memwb_instruction <= instruction;
      
    end
  end
endmodule
