`timescale 1ns / 1ps
module pe #(
     parameter   DATA_WIDTH  = 32
     )
        (   input reset_accumulator,
            input clk,
            input [DATA_WIDTH-1:0] input_top,
            input [DATA_WIDTH-1:0] input_left,
            output [DATA_WIDTH-1:0] output_bottom,
            output [DATA_WIDTH-1:0] output_right
        );
   
    reg [DATA_WIDTH-1:0] output_bottom_reg=0;
    reg [DATA_WIDTH-1:0] output_right_reg=0;
    reg [DATA_WIDTH-1:0] accumulator=0;
//    wire [DATA_WIDTH-1:0] accumulatorx = 
    //wire [DATA_WIDTH-1:0] output_accumulator;

    assign output_right=output_right_reg;
    assign output_bottom=output_bottom_reg;
    
//    always @(posedge clk) begin
//        if(reset_accumulator==1)
//            begin
//                accumulator <= 0;
//            end
//        else  
//            begin
////                $display("what is this %d %d %d",$time,input_top,input_left);
//                accumulator <= accumulator + (input_top*input_left); //accumulator + (input_top*input_left);
//            end
//    end

    always @(posedge clk) begin
        if(reset_accumulator)
        begin
            output_bottom_reg <= 0;
            output_right_reg  <= 0;
        end
        else
        begin
            output_bottom_reg <= input_top;
            output_right_reg  <= input_left;
        end
    end
endmodule