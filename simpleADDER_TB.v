`include "simpleADDER.v"

module simpleADDER_TB;

    // LOCAL VARIABLES
    reg signed [24:0] in_0;
    reg signed [24:0] in_1;
    reg signed [24:0] in_2;
    reg signed [24:0] in_3;
    wire signed [24:0] out;
    reg clk;
    reg signed [24:0] check_sum;

    // DUT CONNECTION
    simpleADDER simpleADDER_MODULE (
        .CLK    (clk),
        .WORD_0 (in_0),
        .WORD_1 (in_1),
        .WORD_2 (in_2),
        .WORD_3 (in_3),
        .RES    (out));

    // CLOCK LOGIC
    always #5 begin
        check_sum <= in_0 + in_1 + in_2 + in_3;
        clk <= ~clk;
    end

    // TESTBENCH
    initial begin
        $display("time\t clk\t\t CHECK\t\t O");
        $monitor("%g\t %b\t %d\t %d", $time, clk, check_sum, out);
        clk = 0;
        in_0 = 0;
        in_1 = 0;
        in_2 = 0;
        in_3 = 0;

        // TEST 1 -------------------------------
        #10 $display("TEST 1: START");
            in_0 = 1;
            in_1 = 2;
            in_2 = 3;
            in_3 = 4;
        #10 $display("TEST 1: STOP");
        // --------------------------------------
        
        // TEST 2 -------------------------------
        #20 $display("TEST 2: START");
            in_0 = -1;
            in_1 = 0;
        #1  in_2 = 5;
        #1  in_0 = 0;
        #10 $display("TEST 2: STOP");
        // --------------------------------------
        
        #20;
        $finish;
    end

endmodule