`include "simpleADDER.v"

module simpleADDER_TB;

    reg signed [24:0] in_0;
    reg signed [24:0] in_1;
    reg signed [24:0] in_2;
    reg signed [24:0] in_3;
    wire signed [24:0] out;
    reg clk;

    simpleADDER simpleADDERMODULE (
        .CLK    (clk),
        .WORD_0 (in_0),
        .WORD_1 (in_1),
        .WORD_2 (in_2),
        .WORD_3 (in_3),
        .RES    (out));

    always #5 begin
        clk <= ~clk;
    end

    initial begin
        clk = 0;
        in_0 = 0;
        in_1 = 0;
        in_2 = 0;
        in_3 = 0;

        #3  in_0 <= 5;
        #1  in_1 <= 4;
        #1  in_2 <= 4;
        #1  in_3 <= 4;
        #20 $display("RES: %d", out);
        #10;
        $finish;
    end



endmodule