module Mux_2_1_32(
    input [31:0] Input0,
    input [31:0] Input1,
    input Selection,
    output [31:0] Output
    );
assign Output = ~(Selection) ? Input0 : Input1;
endmodule