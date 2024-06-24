module Mux_4_1_32(
    input [31:0] Input0,
    input [31:0] Input1,
    input [31:0] Input2,
    input [31:0] Input3,
    input [1:0] Selection,
    output [31:0] Output
);
    assign Output = (Selection == 2'b00) ? Input0 : 
                    (Selection == 2'b01) ? Input1 : 
                    (Selection == 2'b10) ? Input2 : Input3;
endmodule