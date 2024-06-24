module Instruction_Memory(
  // input reset,
  input [31:0]address,
  output [31:0]data
);
reg [31:0]mem[1023:0];

initial begin
$readmemh("memfile.hex",mem);
end

// assign data = (reset == 1'b1) ? {32{1'b0}} : mem[address[31:2]];
assign data = mem[address[31:2]];

endmodule