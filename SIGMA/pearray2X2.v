`timescale 1ns / 1ps
module pearray4X4 #
        (
            parameter DATA_WIDTH=16,
            parameter NUM_PES=16
        )
        (input clk,
        input reset,
        input [DATA_WIDTH-1:0] in1,
        input [DATA_WIDTH-1:0] in2,
        input [DATA_WIDTH-1:0] in3,
        input [DATA_WIDTH-1:0] in4,
        input [DATA_WIDTH-1:0] in5,
        input [DATA_WIDTH-1:0] in6,
        input [DATA_WIDTH-1:0] in7,
        input [DATA_WIDTH-1:0] in8,


        output [DATA_WIDTH-1:0] out1,
        output [DATA_WIDTH-1:0] out2,
        output [DATA_WIDTH-1:0] out3,
        output [DATA_WIDTH-1:0] out4        
        );
    wire [DATA_WIDTH-1:0] penet[NUM_PES*2:0];
    assign out1 = penet[7];
    assign out2 = penet[15];
    assign out3 = penet[23];
    assign out4 = penet[31];
    integer k;
//    always@(reset)
//    begin
//        for(k = 0; k<DATA_WIDTH; k = k+1)begin
//            penet[k] = 0;
//        end 
//    end
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe11
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(in5),
         .input_left(in1),
         .output_bottom(penet[1]),
         .output_right(penet[0])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe21
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[1]),
         .input_left(in2),
         .output_bottom(penet[3]),
         .output_right(penet[2])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe31
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[3]),
         .input_left(in3),
         .output_bottom(penet[5]),
         .output_right(penet[4])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe41
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[5]),
         .input_left(in4),
         .output_bottom(penet[7]),
         .output_right(penet[6])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe12
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(in6),
         .input_left(penet[0]),
         .output_bottom(penet[9]),
         .output_right(penet[8])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe22
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[9]),
         .input_left(penet[2]),
         .output_bottom(penet[11]),
         .output_right(penet[10])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe32
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[11]),
         .input_left(penet[4]),
         .output_bottom(penet[13]),
         .output_right(penet[12])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe42
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[13]),
         .input_left(penet[6]),
         .output_bottom(penet[15]),
         .output_right(penet[14])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe13
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(in7),
         .input_left(penet[8]),
         .output_bottom(penet[17]),
         .output_right(penet[16])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe23
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[17]),
         .input_left(penet[10]),
         .output_bottom(penet[19]),
         .output_right(penet[18])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe33
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[19]),
         .input_left(penet[12]),
         .output_bottom(penet[21]),
         .output_right(penet[20])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe43
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[21]),
         .input_left(penet[14]),
         .output_bottom(penet[23]),
         .output_right(penet[22])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe14
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(in8),
         .input_left(penet[16]),
         .output_bottom(penet[25]),
         .output_right(penet[24])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe24
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[25]),
         .input_left(penet[18]),
         .output_bottom(penet[27]),
         .output_right(penet[26])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe34
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[27]),
         .input_left(penet[20]),
         .output_bottom(penet[29]),
         .output_right(penet[28])
    );
    pe #(.DATA_WIDTH(DATA_WIDTH))
     pe44
    (    .reset_accumulator(reset),
         .clk(clk),
         .input_top(penet[29]),
         .input_left(penet[22]),
         .output_bottom(penet[31]),
         .output_right(penet[30])
    );
endmodule