module SERDESDECODE_1(
    input [64*NSLOT-1:0] DATA,
    output [24:0] WFMSUM,
    output ANYNOTPED,
    output [3:0] MAXID,
    output [20:0] MAXWAVEFORM,
    output [7:0] TDCSUM,
    output [4:0] TDCNUM,
    output [15:0] TDCHIT,
    output [3*16-1:0] TDCVAL,
    output [15:0] DISCRSTATE
    );

    parameter SLOT=0;
    parameter NSLOT=1;

    //decode QSUM
    // CONNECTION SCHEME:
    // WDi :BIT 24-0 FOR SUM OF WAVEFORMs
    //     :BIT 63 FOR ANY PEDESTAL OUTSIDE THRESHOLD
    assign WFMSUM = DATA[64*SLOT+:25];
    assign ANYNOTPED = DATA[64*SLOT+63];

    //decode MAXID
    // CONNECTION SCHEME:
    // WDi :BIT 28-26 FOR MAXIMUM ID (if WDB Algsel==0 relates to MAXWAVEFORM
    //                                otherwise relates to TDCNUM)
    assign MAXID = DATA[64*SLOT+25+:4];

    //decode MAXWAVEFORM
    // CONNECTION SCHEME:
    // WDi :BIT 49-29 FOR MAXIMUM WAVEFORM WALUE
    assign MAXWAVEFORM = DATA[64*SLOT+29+:21];

    //decode TDC Mult
    // CONNECTION SCHEME:
    //     :BIT 55-48 FOR SUM OF TDCs
    //     :BIT 60-56 FOR NUM OF TDCs
    assign TDCSUM = DATA[64*SLOT+50+:8];    
    assign TDCNUM = DATA[64*SLOT+58+:5];    

    //decode TC
    // CONNECTION SCHEME:
    // WDi :BIT 15-0 FOR TIME VALID
    //     :BIT 63-16 FOR TIMESTAMP (3 bit each)
    assign TDCHIT = DATA[64*SLOT+:16];    
    assign TDCVAL = DATA[64*SLOT+16+:3*16];

    //decode DISCRIMINATOR status
    assign DISCRSTATE = DATA[64*SLOT+29+:16];
endmodule