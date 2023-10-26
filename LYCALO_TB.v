`include "global_parameters.vh"
`include "CREATEDATA.v"
`include "LYCALOBLOCK.v"

module LYCALO_TB;

    // LOCAL VARIABLES
    reg CLK;
    reg signed [31:0] LYCALOTHR;
    wire [31:0] LYCALOTHR_W;
    assign LYCALOTHR_W = LYCALOTHR;
    wire LYCALOTRG;
    wire signed [28:0] LYCALOQSUM;

    reg signed [24:0] DATA_IN_VEC[16];
    wire [25*16-1:0] DATA_IN;
    genvar iSlot;
    for (iSlot = 0; iSlot < 16; iSlot = iSlot + 1) begin
        assign DATA_IN[25*iSlot+:25] = DATA_IN_VEC[iSlot];
    end
    
    wire [1023:0] DATA;

    //DUT
    CREATEDATA CREATEDATA_TB (
        .DATA_IN(DATA_IN),
        .DATA(DATA)
    );

    LYCALOBLOCK LYCALO (
        .CLK(CLK),              // IN
        .DATA(DATA),            // IN
        .LYCALOTHR(LYCALOTHR_W),  // IN
        .LYCALOMASK(256'b1),    // IN
        .LYCALOTRG(LYCALOTRG),
        .LYCALOORTRG(),
        .LYCALOQSUM(LYCALOQSUM)
    );

    always #5 begin
        CLK <= ~CLK;
    end

    integer i;
    initial begin

        CLK = 0;
        LYCALOTHR = 0;
        for (i = 0; i < 16; i = i + 1) begin
            DATA_IN_VEC[i] = 0;
        end

        $display("TIME\t CLK\t TRG\t\t THR\t\t\t SUM");
        $monitor("%g\t %b\t %b\t %d\t\t %d", $time, CLK, LYCALOTRG, LYCALOTHR, LYCALOQSUM);

        #50
        $display("TEST 1");
        DATA_IN_VEC[0] = 10;
        DATA_IN_VEC[1] = 20;
        DATA_IN_VEC[2] = 30;
        DATA_IN_VEC[3] = 40;

        #50
        $display("TEST 2");
        DATA_IN_VEC[0] = 10;
        DATA_IN_VEC[1] = 20;
        DATA_IN_VEC[2] = 30;
        DATA_IN_VEC[3] = 40;
        DATA_IN_VEC[4] = -10;

        #50
        $display("TEST 3");
        LYCALOTHR = 90;

        #50
        $display("TEST 4");
        DATA_IN_VEC[0] = -100;
        DATA_IN_VEC[1] = 0;
        DATA_IN_VEC[2] = 0;
        DATA_IN_VEC[3] = 0;
        DATA_IN_VEC[4] = 0;
        LYCALOTHR = -101;
        $display(signed'(LYCALOTHR_W));

        #50
        $display("TEST 5");
        DATA_IN_VEC[0] = -100;
        LYCALOTHR = -100;

        #50

        $finish;
    end

endmodule