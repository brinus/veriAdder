`include "global_parameters.vh"

module CREATEDATA(
    input [25*16-1:0] DATA_IN,
    output [1023:0] DATA
    );

    genvar iSlot;
    for (iSlot = 0; iSlot < 16; iSlot = iSlot + 1) begin
        assign DATA[iSlot*64+:64] = {39'b0, DATA_IN[iSlot*25+:25]};
    end
endmodule