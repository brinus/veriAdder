`include "global_parameters.vh"
`include "SERDESDECODE_1.v"

module LYCALOBLOCK(
    input CLK,
    input [1023:0] DATA,
    input signed [31:0] LYCALOTHR,
    input [255:0] LYCALOMASK,
    output reg LYCALOTRG,
    output reg LYCALOORTRG,
    output reg signed [(`LYCALOQBIT+4)-1:0] LYCALOQSUM
    );

    // CREATE CHARGE FOR EVERY WDB
    wire [`LYCALOQBIT*`NSERDESBP-1:0] WFSUM_BOARD;
    wire [255:0] DISCR_BOARD;

    genvar iSlot;
    generate
    for (iSlot = 0; iSlot < 16; iSlot = iSlot + 1) begin
        SERDESDECODE_1 #(
            .SLOT(iSlot),
            .NSLOT(16)
        ) slot_decode (
            .DATA(DATA),
            .WFMSUM(WFSUM_BOARD[iSlot*`LYCALOQBIT+:`LYCALOQBIT]),
            .ANYNOTPED(),
            .MAXID(),
            .MAXWAVEFORM(),
            .TDCSUM(),
            .TDCNUM(),
            .TDCHIT(),
            .TDCVAL(),
            .DISCRSTATE(DISCR_BOARD[iSlot*16+:16])
        );
    end
    endgenerate

    // PERFORMING SUM
    reg [(`LYCALOQBIT+1)*8-1:0] SUM_1;
    reg [(`LYCALOQBIT+2)*4-1:0] SUM_2;
    reg [(`LYCALOQBIT+3)*2-1:0] SUM_3;


    integer i;
    always @ (posedge CLK) begin

        for (i=0; i<8; i=i+1) begin
            SUM_1[i*(`LYCALOQBIT+1)+:`LYCALOQBIT+1] <= $signed(WFSUM_BOARD[i*(`LYCALOQBIT)+:`LYCALOQBIT]) + $signed(WFSUM_BOARD[(i+8)*(`LYCALOQBIT)+:`LYCALOQBIT]);
        end
        for (i=0; i<4; i=i+1) begin
            SUM_2[i*(`LYCALOQBIT+2)+:`LYCALOQBIT+2] <= $signed(SUM_1[i*(`LYCALOQBIT+1)+:`LYCALOQBIT+1]) + $signed(SUM_1[(i+4)*(`LYCALOQBIT+1)+:`LYCALOQBIT+1]);
        end
        for (i=0; i<2; i=i+1) begin
            SUM_3[i*(`LYCALOQBIT+3)+:`LYCALOQBIT+3] <= $signed(SUM_2[i*(`LYCALOQBIT+2)+:`LYCALOQBIT+2]) + $signed(SUM_2[(i+2)*(`LYCALOQBIT+2)+:`LYCALOQBIT+2]);
        end

        LYCALOQSUM <= $signed(SUM_3[0+:`LYCALOQBIT+3]) + $signed(SUM_3[`LYCALOQBIT+3+:`LYCALOQBIT+3]);      

        // TRIGGER ON Q_TOT
        LYCALOTRG <= (LYCALOQSUM > LYCALOTHR) ? 1 : 0;
        // TRIGGER ON ALL 'OR'
        LYCALOORTRG <= |(DISCR_BOARD[255:0]&LYCALOMASK[255:0]);

    end

endmodule 