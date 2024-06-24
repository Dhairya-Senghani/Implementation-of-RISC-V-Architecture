// `include "Instruction_Memory.v"
// `include "Mux_2_1_32.v"
// `include "PC_Adder.v"
// `include "PC_Module.v"

module Fetch_Cycle(clock, reset, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);
input clock, reset;
input PCSrcE;
input [31:0] PCTargetE;
output [31:0] InstrD;
output [31:0] PCD, PCPlus4D;

wire [31:0] PC_F, PCF, PCPlus4F, inst_fetched;

reg [31:0] Inst_Fetch_reg;
reg [31:0] PCF_reg;
reg [31:0] PCPlus4F_reg;

Mux_2_1_32 PC_MUX(
    .Input0(PCPlus4F),
    .Input1(PCTargetE),
    .Selection(PCSrcE),
    .Output(PC_F)
);

PC_Module programm_counter(
    .clock(clock),
    .reset(reset),
    .PC_Next(PC_F),
    .PC(PCF)
);

Instruction_Memory INST_MEMORY(
    // .reset(reset),
    .address(PCF),
    .data(inst_fetched)
);

PC_Adder PC_add(
    .PC(PCF),
    .Amount(32'h00000004),
    .Incremented_PC(PCPlus4F)
);

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1) begin
        Inst_Fetch_reg <= 32'h00000000;
        PCF_reg <= 32'h00000000;
        PCPlus4F_reg <= 32'h00000000;
    end
    else begin
        Inst_Fetch_reg <= inst_fetched;
        PCF_reg <= PCF;
        PCPlus4F_reg <= PCPlus4F;
    end
end

assign InstrD = Inst_Fetch_reg;
assign PCD = PCF_reg;
assign PCPlus4D = PCPlus4F_reg;

endmodule