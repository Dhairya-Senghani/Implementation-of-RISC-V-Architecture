module Hazard_Unit(reset, RegWriteM, RegWriteW, RD_M, RD_W, Rs1_D, Rs2_D, Rs1_E, Rs2_E, ForwardAE, ForwardBE, ForwardAD, ForwardBD);

    // Declaration of I/Os
    input reset, RegWriteM, RegWriteW;
    input [4:0] RD_M, RD_W, Rs1_D, Rs2_D, Rs1_E, Rs2_E;
    output [1:0] ForwardAE, ForwardBE;
    output ForwardAD, ForwardBD;
    
    assign ForwardAE = (reset == 1'b1) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'b00000) & (RD_M == Rs1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'b00000) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;
                       
    assign ForwardBE = (reset == 1'b1) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'b00000) & (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'b00000) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

    assign ForwardAD = (reset == 1'b1) ? 1'b0 : 
                       ((RegWriteW == 1'b1) & (RD_W != 5'b00000) & (RD_W == Rs1_D)) ? 1'b1 : 1'b0;
                       
    assign ForwardBD = (reset == 1'b1) ? 1'b0 : 
                       ((RegWriteW == 1'b1) & (RD_W != 5'b00000) & (RD_W == Rs2_D)) ? 1'b1 : 1'b0;

                       

endmodule