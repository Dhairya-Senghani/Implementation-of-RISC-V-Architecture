module PC_Adder(
    input [31:0] PC,
    input [31:0] Amount,
    output [31:0] Incremented_PC
);
assign Incremented_PC = PC + Amount;
    
endmodule