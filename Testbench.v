`include "RISC_V_PIPELINED_TOP.v"

module tb();

    reg clock, reset;
    
    RISC_V_PIPELINED_TOP dut (.clock(clock), .reset(reset));
    
    always begin
        clock = ~clock;
        #50;
    end

    initial begin
        clock <= 1'b0;
        reset <= 1'b0;
        #200;
        reset <= 1'b1;
        #200;
        reset <= 1'b0;
        #21500;
        $finish;    
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule