
module Control_Unit_1(
    input [6:0] Op,
    input [6:0] funct7,
    input [2:0] funct3,
    output RegWrite,
    output ALUSrc,
    output MemWrite,
    output [1:0] ResultSrc,
    output Jump,
    output [2:0] Branch,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);
    wire [1:0]ALUOp;
    wire isBranch;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .isJump(Jump),
                .isBranch(isBranch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp)
    );


    Branch_Decoder BranchOp(
                .isBranch(isBranch), 
                .funct3(funct3), 
                .Branch_D(Branch)
    );


    ALU_Decoder ALU_Decoder(
                            .op(Op),
                            .funct3(funct3),
                            .funct7(funct7),
                            .ALUOp(ALUOp),
                            .ALUControl(ALUControl)
    );


endmodule








module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,isJump,isBranch,ALUOp);
    input [6:0]Op;
    output RegWrite, ALUSrc, MemWrite, isJump, isBranch;
    output [2:0] ImmSrc;
    output [1:0] ResultSrc;
    output [1:0] ALUOp;


    assign RegWrite = (Op == 7'b0100011 | Op == 7'b1100011 | Op == 7'b1110011) ? 1'b0 :
                                                              1'b1 ;

    assign ImmSrc = (Op == 7'b0010011 | Op == 7'b0000011 | Op == 7'b1100111 | Op == 7'b1110011) ? 3'b000 : 
                    (Op == 7'b0100011) ? 3'b001 :    
                    (Op == 7'b1100011) ? 3'b010 :    
                    (Op == 7'b0110111 | Op == 7'b0010111) ? 3'b011 :    
                                         3'b100 ;
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 :
                                                            1'b0 ;
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;
    assign ResultSrc = (Op == 7'b0000011) ? 2'b01:
                       (Op == 7'b1101111 | Op == 7'b1100111) ? 2'b10:
                                            2'b00 ;
    assign isJump = (Op == 7'b1101111 | Op == 7'b1100111) ? 1'b1 :
                                                          1'b0 ;
                                         
    assign isBranch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;

    assign ALUOp = (Op == 7'b0110011) ? 2'b00 :  // R-Type Arithmatic & Logical
                   (Op == 7'b0010011) ? 2'b01 :  // I - Type
                   (Op == 7'b1100011) ? 2'b10 :  // For Branch
                                        2'b11 ;

endmodule





module Branch_Decoder (isBranch, funct3, Branch_D);
    input isBranch;
    input [2:0] funct3;
    output [2:0] Branch_D;

    assign Branch_D = ((isBranch == 1'b1) & (funct3 == 3'b000)) ? 3'b001 :
                      ((isBranch == 1'b1) & (funct3 == 3'b001)) ? 3'b010 : 
                      ((isBranch == 1'b1) & (funct3 == 3'b100)) ? 3'b011 : 
                      ((isBranch == 1'b1) & (funct3 == 3'b101)) ? 3'b100 : 
                      ((isBranch == 1'b1) & (funct3 == 3'b110)) ? 3'b101 : 
                      ((isBranch == 1'b1) & (funct3 == 3'b111)) ? 3'b110 : 3'b000;
endmodule







module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,op;
    output [3:0]ALUControl;

    // Method 1 
    // assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
    //                     (ALUOp == 2'b01) ? 3'b001 :
    //                     (ALUOp == 2'b10) ? ((funct3 == 3'b000) ? ((({op[5],funct7[5]} == 2'b00) | ({op[5],funct7[5]} == 2'b01) | ({op[5],funct7[5]} == 2'b10)) ? 3'b000 : 3'b001) : 
    //                                         (funct3 == 3'b010) ? 3'b101 : 
    //                                         (funct3 == 3'b110) ? 3'b011 : 
    //                                         (funct3 == 3'b111) ? 3'b010 : 3'b000) :
    //                                        3'b000;

    // Method 2
    // assign ALUControl = (ALUOp == 2'b00) ? 4'b0000 :
    //                     (ALUOp == 2'b01) ? 4'b0001 :
    //                     ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 4'b0001 : 
    //                     ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 4'b0000 : 
    //                     ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 4'b0101 : 
    //                     ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 4'b0011 : 
    //                     ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 4'b0010 : 
    //                                                               4'b0000 ;

    // My method
    assign ALUControl = ((ALUOp == 2'b00) & (funct3 == 3'b000) & (funct7 == 7'b0000000)) ? 4'b0000 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b000) & (funct7 == 7'b0100000)) ? 4'b0001 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b001) & (funct7 == 7'b0000000)) ? 4'b0101 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b010) & (funct7 == 7'b0000000)) ? 4'b1000 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b011) & (funct7 == 7'b0000000)) ? 4'b1001 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b100) & (funct7 == 7'b0000000)) ? 4'b0010 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b101) & (funct7 == 7'b0000000)) ? 4'b0110 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b101) & (funct7 == 7'b0100000)) ? 4'b0111 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b110) & (funct7 == 7'b0000000)) ? 4'b0011 : 
                        ((ALUOp == 2'b00) & (funct3 == 3'b111) & (funct7 == 7'b0000000)) ? 4'b0100 :

                        ((ALUOp == 2'b01) & (funct3 == 3'b000)) ? 4'b0000 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b001) & (funct7 == 7'b0000000)) ? 4'b0101 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b010)) ? 4'b1000 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b011)) ? 4'b1001 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b100)) ? 4'b0010 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b101) & (funct7 == 7'b0000000)) ? 4'b0110 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b101) & (funct7 == 7'b0100000)) ? 4'b0111 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b110)) ? 4'b0011 : 
                        ((ALUOp == 2'b01) & (funct3 == 3'b111)) ? 4'b0100 : 

                        (ALUOp == 2'b10) ? 4'b0001 :
                        (ALUOp == 2'b11) ? 4'b0000 :
                                                                  4'b0000 ;

endmodule






/*
module CONTROL(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg [3:0] alu_control,
	 output reg [1:0] op2_fetch,
    output reg reg_write
);
    always @(funct3 or funct7 or opcode)
    begin
	    reg_write = 1;
		 
        case(opcode) 
		 7'b0110011:  begin   // R-type instructions
		   op2_fetch = 2'b00;
				case(funct7)
				7'b0000000: begin             //Shifting Operation
            case (funct3)
                0: alu_control = 4'b0000; // ADD
					 1: alu_control = 4'b0001; // SLL
					 2: alu_control = 4'b0010; // SLT signed
					 3: alu_control = 4'b0011; // SLT unsigned
					 4: alu_control = 4'b0100; // XOR
                5: alu_control = 4'b0101; // SRL
                6: alu_control = 4'b0110; // OR
                7: alu_control = 4'b0111; // AND 
            endcase
				end
				
				7'b0100000:begin                  //Arithmatic Operation (Addition, Subtraction)
					case(funct3)
				   3'b000: alu_control = 4'b1000; // SUB
				   3'b101: alu_control = 4'b1001; // SRA
					endcase
					end
					
				7'b0000001: begin                 //Arithmatic Operation (Multiply, Devide, Reminder)
				case(funct3)
				  3'b000: alu_control = 4'b1001;  //MUL [31:0]
				  3'b001: alu_control = 4'b1010;  //MUL HIGH [63:32]
				  3'b010: alu_control = 4'b1011;  //MUL HIGH [63:32] signed
				  3'b011: alu_control = 4'b1100;  //MUL HIGH [63:32] unsigned
				  3'b100: alu_control = 4'b1101;  //DIV signed
				  3'b101: alu_control = 4'b1110;  //DIV unsigned
				  3'b110: alu_control = 4'b1111;  //REMINDER signed
			  // 3'b111: alu_control = 4'b1011;  //REMINDER unsigned
				endcase
				end
				
			endcase
		end
		
	 7'b0010011: begin // I-type instructions
					 op2_fetch = 2'b01;
            case (funct3)
                0: alu_control = 4'b0000; // ADD
					 1: if(funct7 == 7'b0000000) alu_control = 4'b0001; // SLL
					 2: alu_control = 4'b0010; // SLT signed
					 3: alu_control = 4'b0011; // SLT unsigned
					 4: alu_control = 4'b0100; // XOR
                5: begin 
							case(funct7) 
								7'b0000000: alu_control = 4'b0101; // SRL
								7'b0100000: alu_control = 4'b1001; // SRA
							endcase
						 end
                6: alu_control = 4'b0110; // OR
                7: alu_control = 4'b0111; // AND 
            endcase
				end
				
				endcase
end

endmodule
*/