// `include "ALU.v"
// `include "Mux_2_1_32.v"
// `include "Mux_4_1_32.v"
// `include "PC_Adder.v"
// `include "Branch_Module.v"

module Execute_Cycle(clock, reset, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, JumpE, BranchE, ALUControlE, 
    RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, ResultW, ForwardA_E, ForwardB_E);

    // Declaration I/Os
    input clock, reset, RegWriteE, ALUSrcE, MemWriteE, JumpE;
    input [2:0] BranchE;
    input [1:0] ResultSrcE;
    input [3:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;

    output PCSrcE, RegWriteM, MemWriteM;
    output [1:0] ResultSrcM;
    output [4:0] RD_M; 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    // Declaration of Interim Wires
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE, isBranch;

    // Declaration of Register
    reg RegWriteE_r, MemWriteE_r;
    reg [1:0] ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    // Declaration of Modules
    // 3 by 1 Mux for Source A
    Mux_4_1_32 srca_mux (
                        .Input0(RD1_E),
                        .Input1(ResultW),
                        .Input2(ALU_ResultM),
                        .Input3(32'h00000000),
                        .Selection(ForwardA_E),
                        .Output(Src_A)
                        );

    // 3 by 1 Mux for Source B
    Mux_4_1_32 srcb_mux (
                        .Input0(RD2_E),
                        .Input1(ResultW),
                        .Input2(ALU_ResultM),
                        .Input3(32'h00000000),
                        .Selection(ForwardB_E),
                        .Output(Src_B_interim)
                        );
    // ALU Src Mux
    Mux_2_1_32 alu_src_mux (
            .Input0(Src_B_interim),
            .Input1(Imm_Ext_E),
            .Selection(ALUSrcE),
            .Output(Src_B)
            );

    Branch_Module is_Branch(
            .A(Src_A), 
            .B(Src_B), 
            .A_Unsigned(Src_A), 
            .B_Unsigned(Src_B), 
            .BranchE(BranchE), 
            .isBranch(isBranch) 
            );

    // ALU Unit
    ALU alu (
            .A(Src_A),
            .B(Src_B),
            .Result(ResultE),
            .ALUControl(ALUControlE),
            .OverFlow(),
            .Carry(),
            .Zero(ZeroE),
            .Negative()
            );

    // Adder
    PC_Adder branch_adder (
            .PC(PCE),
            .Amount(Imm_Ext_E),
            .Incremented_PC(PCTargetE)
            );

    // Register Logic
    always @(posedge clock or posedge reset) begin
        if(reset == 1'b1) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 2'b00;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim; 
            ResultE_r <= ResultE;
        end
    end

    // Output Assignments
    assign PCSrcE = JumpE | (BranchE != 3'b000 & isBranch == 1'b1);
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule