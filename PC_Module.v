module PC_Module(
    input clock, reset,
    input [31:0] PC_Next,
    output reg [31:0] PC
);
always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1) begin
        PC <= 32'h00000000;
    end
    else begin
        PC <= PC_Next;
    end
end
endmodule