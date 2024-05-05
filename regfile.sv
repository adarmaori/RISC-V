module regfile(
  input i_clk,
  input i_we,
  input i_resetn,
  input [4:0] i_rs1,
  input [4:0] i_rs2,
  input [4:0] i_rd,
  input [63:0] i_data_in,
  output [63:0] o_rs1_value,
  output [63:0] o_rs2_value
  );

  reg [63:0] mem [31:1];
  assign o_rs1_value = (i_rs1 == 0) ? 0 : mem[i_rs1];
  assign o_rs2_value = (i_rs2 == 0) ? 0 : mem[i_rs2];
  

  // DEBUG SIGNALS
  wire [63:0] r1 = mem[1];
  wire [63:0] r2 = mem[2];
  wire [63:0] r3 = mem[3];
  wire [63:0] r4 = mem[4];
  wire [63:0] r5 = mem[5];
  wire [63:0] r6 = mem[6];
  wire [63:0] r7 = mem[7];
  wire [63:0] r8 = mem[8];
  wire [63:0] r9 = mem[9];
  wire [63:0] r10 = mem[10];
  wire [63:0] r11 = mem[11];
  wire [63:0] r12 = mem[12];
  wire [63:0] r13 = mem[13];
  wire [63:0] r14 = mem[14];
  wire [63:0] r15 = mem[15];
  wire [63:0] r16 = mem[16];
  wire [63:0] r17 = mem[17];
  wire [63:0] r18 = mem[18];
  wire [63:0] r19 = mem[19];
  wire [63:0] r20 = mem[20];
  wire [63:0] r21 = mem[21];
  wire [63:0] r22 = mem[22];
  wire [63:0] r23 = mem[23];
  wire [63:0] r24 = mem[24];
  wire [63:0] r25 = mem[25];
  wire [63:0] r26 = mem[26];
  wire [63:0] r27 = mem[27];
  wire [63:0] r28 = mem[28];
  wire [63:0] r29 = mem[29];
  wire [63:0] r30 = mem[30];
  wire [63:0] r31 = mem[31];
  initial begin
    mem[1] = 1;
    mem[2] = 2;
    mem[3] = 3;
    mem[4] = 4;
    mem[5] = 5;
    mem[6] = 6;
    mem[7] = 7;
    mem[8] = 8;
    mem[9] = 9;
    mem[10] = 10;
    mem[11] = 11;
    mem[12] = 12;
    mem[13] = 13;
    mem[14] = 14;
    mem[15] = 15;
    mem[16] = 16;
    mem[17] = 17;
    mem[18] = 18;
    mem[19] = 19;
    mem[20] = 20;
    mem[21] = 21;
    mem[22] = 22;
    mem[23] = 23;
    mem[24] = 24;
    mem[25] = 25;
    mem[26] = 26;
    mem[27] = 27;
    mem[28] = 28;
    mem[29] = 29;
    mem[30] = 30;
    mem[31] = 31;
  end
  always @ (posedge i_clk) begin
    #1 if (i_we && i_rd) begin // TODO: get rid of this one too
      mem[i_rd] <= i_data_in;
    end
  end

  endmodule
