module simpleADDER ( input  signed [24:0] WORD_0,
                     input  signed [24:0] WORD_1,
                     input  signed [24:0] WORD_2,
                     input  signed [24:0] WORD_3,
                     input  CLK,
                    output  reg signed [24:0] RES);

                reg signed [24:0] SUM[1:0];

                always @ (posedge CLK) begin
                    SUM[0] <= WORD_0 + WORD_1;
                    SUM[1] <= WORD_2 + WORD_3;
                    RES <= SUM[0] + SUM[1];
                end
endmodule