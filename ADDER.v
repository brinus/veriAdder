module ADDER ( input    signed [24:0] WORD[15:0],
               input    CLK,
               output   wire signed [24:0] RES);

                reg signed [24:0] SUM[14:0];

                integer i;
                initial begin
                    for (i = 0; i < 16; i = i + 1) begin
                        SUM[i] = 0;
                    end
                end

                assign RES = SUM[14];

                always @ (posedge CLK) begin
                    for (i = 0; i < 8; i = i + 1) begin
                        SUM[i] <= WORD[i] + WORD[i + 8];
                    end
                    for (i = 0; i < 4; i = i + 1) begin
                        SUM[i + 8] <= SUM[i] + SUM[i + 4];
                    end
                    for (i = 0; i < 2; i = i + 1) begin
                        SUM[i + 12] <= SUM[i + 8] + SUM[i + 10];
                    end
                    SUM[14] <= SUM[12] + SUM[13];
                end
endmodule