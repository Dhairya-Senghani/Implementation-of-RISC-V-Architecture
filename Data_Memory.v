/*module Data_Memory #(parameter MEMORY_SIZE = 1048576)(clock,reset,WE,WD,A,RD);

    input clock;
    input reset;
    input WE;
    input [31:0]A;
    input [31:0]WD;
    output [31:0]RD;

    reg [31:0] Memory [MEMORY_SIZE-1:0];
    integer i;
    assign RD = Memory[A];

    always @(posedge clock)
    begin
        if(WE) begin
            Memory[A] <= WD;
        end
    end

    always @(posedge reset) begin
        if(reset == 1'b1) begin
            for(i = 0; i < MEMORY_SIZE; i = i +1) begin
                Memory[i] <= 32'h00000000;
            end
        end
    end


    // initial begin
    //     mem[0] = 32'h00000000;
    //     //mem[40] = 32'h00000002;
    // end


endmodule
*/



module Data_Memory #(parameter MEMORY_SIZE = 1048576)(clock,reset,WE,WD,A,RD);

    input clock;
    input reset;
    input WE;
    input [31:0]A;
    input [31:0]WD;
    output [31:0]RD;

    reg [7:0] Memory [MEMORY_SIZE-1:0];
    integer i;
    assign RD = {Memory[A + 3], Memory[A + 2], Memory[A + 1], Memory[A]};

    always @(posedge clock)
    begin
        if(WE) begin
            {Memory[A + 3], Memory[A + 2], Memory[A + 1], Memory[A]} <= WD;
        end
    end

    always @(posedge reset) begin
        if(reset == 1'b1) begin
            for(i = 0; i < MEMORY_SIZE; i = i +1) begin
                Memory[i] <= 32'h00000000;
            end
        end
    end


    // initial begin
    //     mem[0] = 32'h00000000;
    //     //mem[40] = 32'h00000002;
    // end


endmodule