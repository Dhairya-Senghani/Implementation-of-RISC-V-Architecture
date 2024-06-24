module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative);

    input [31:0]A,B;
    input [3:0]ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + (~B) + 32'h00000001) ;
    assign {Cout,Result} = (ALUControl == 4'b0000) ? Sum :
                           (ALUControl == 4'b0001) ? Sum :
                           (ALUControl == 4'b0010) ? A ^ B :
                           (ALUControl == 4'b0011) ? A | B :
                           (ALUControl == 4'b0100) ? A & B :
                           (ALUControl == 4'b0101) ? A << B[4:0] :
                           (ALUControl == 4'b0110) ? A >> B[4:0] :
                           (ALUControl == 4'b0111) ? {A[31], (A >> B[4:0])} :
                           (ALUControl == 4'b1000) ? {{32{1'b0}},(Sum[31])} :
                           (ALUControl == 4'b1001) ? (A < B ? 1 : 0) :  
                           {33{1'b0}};
                           
                      
    assign OverFlow = ((ALUControl == 4'b0000 | ALUControl == 4'b0001) & 
                      (B[31] & A[31] & ~Sum[31]) | ( ~B[31] & ~A[31] & Sum[31]));

    assign Carry = ((ALUControl == 4'b0000 | ALUControl == 4'b0001) & Cout);
    
    assign Zero = &(~Result);
    
    assign Negative = Result[31];

endmodule