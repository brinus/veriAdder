module simpleADDER ( input  signed [24:0] WORD_0,
                     input  signed [24:0] WORD_1,
                     input  signed [24:0] WORD_2,
                     input  signed [24:0] WORD_3,
                     input  CLK,
                    output  wire signed [24:0] RES);

                reg signed [24:0] SUM[2:0];
                
                integer i;
                initial begin
                    for (i = 0; i < 3; i = i + 1) begin
                        SUM[i] = 0;
                    end
                end

                assign RES = SUM[2];

                always @ (posedge CLK) begin
                    SUM[0] <= WORD_0 + WORD_1;
                    SUM[1] <= WORD_2 + WORD_3;
                    SUM[2] <= SUM[0] + SUM[1];
                end
endmodule