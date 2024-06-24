module Branch_Module(A, B, A_Unsigned, B_Unsigned, BranchE, isBranch);
    input [2:0] BranchE;
    input signed [31:0] A, B;
    input [31:0] A_Unsigned, B_Unsigned;
    output isBranch;

    assign isBranch = (BranchE == 3'b000) ? 1'b0 :
                      (BranchE == 3'b001) ? (A == B) :
                      (BranchE == 3'b010) ? (A != B) :
                      (BranchE == 3'b011) ? (A < B) :
                      (BranchE == 3'b100) ? (A >= B) :
                      (BranchE == 3'b101) ? (A_Unsigned < B_Unsigned) :
                      (BranchE == 3'b110) ? (A_Unsigned >= B_Unsigned) : 1'b0;

endmodule