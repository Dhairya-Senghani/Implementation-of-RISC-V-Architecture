module Sign_Extend(Input,ImmSrc,Output);
    input [31:0] Input;
    input [2:0] ImmSrc;
    output [31:0] Output;

    assign Output =  (ImmSrc == 3'b000) ? {{20{Input[31]}},Input[31:20]} : 
                     (ImmSrc == 3'b001) ? {{20{Input[31]}},Input[31:25],Input[11:7]} :  
                     (ImmSrc == 3'b010) ? {{19{Input[31]}},Input[31],Input[7],Input[30:25],Input[11:8], 1'b0} : 
                     (ImmSrc == 3'b011) ? {Input[31:12], 12'h000} : 
                     (ImmSrc == 3'b100) ? {{11{Input[31]}},Input[31],Input[19:12],Input[20], Input[30:21], 1'b0} : 32'h00000000; 

endmodule