// `include "Mux_4_1_32.v"

module Writeback_Cycle(clock, reset, ResultSrcW, PCPlus4W, ALU_ResultW, ReadDataW, ResultW);

// Declaration of IOs
input clock, reset;
input [1:0] ResultSrcW;
input [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

output [31:0] ResultW;

// Declaration of Module
Mux_4_1_32 result_mux (    
                .Input0(ALU_ResultW),
                .Input1(ReadDataW),
                .Input2(PCPlus4W),
                .Input3(32'h00000000),
                .Selection(ResultSrcW),
                .Output(ResultW)
                );
endmodule