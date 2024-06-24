module Register_File(
    input clock,
    input reset,
    input WE3,         //WE --> Write Enable
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,  //WD --> Write Data
    output [31:0] RD1, //RD --> Read Data
    output [31:0] RD2 
);
    reg [31:0] Register_Memory [31:0];
    // initial begin
    //     Register_Memory[0] = 32'h00000000;
    // end

    assign RD1 = Register_Memory[A1];
    assign RD2 = Register_Memory[A2];

    // genvar i;
    integer i;
    // generate
    always @ (posedge clock or posedge reset) begin
        if(reset == 1'b1) begin
            for(i = 0; i < 32; i = i + 1) begin
                Register_Memory[i] <= 32'h00000000;
            end
        end
        else begin
            if(WE3 == 1'b1 && (A3 != 5'b00000)) begin
                Register_Memory[A3] <= WD3;
            end
        end
    end
    // endgenerate


endmodule