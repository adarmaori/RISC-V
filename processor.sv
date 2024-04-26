module processor (
  input clk
  // The rest of the ports (memory, data bus, etc will be placed later)
);

  parameter S_FETCH   = 3'b000;  
  parameter S_DECODE  = 3'b001;  
  parameter S_EXECUTE = 3'b010;  
  parameter S_MEM_ACC = 3'b011;  
  parameter S_WRT_BCK  = 3'b100;  

  reg [2:0] state = S_FETCH;

  reg [7:0] memory [4096]; // To be replaced with external memory

  reg [31:0] reg_file [32];
  // TODO: figure out the thing with the zero register, should I waste
  // a register on it? not sure yet
  reg [31:0] pc;
  
  always @ (posedge clk) begin
    case (state)
      S_FETCH: begin end
      S_DECODE: begin end
      S_EXECUTE: begin end
      S_MEM_ACC: begin end
      S_WRT_BCK: begin end
    endcase
  end
  
endmodule
