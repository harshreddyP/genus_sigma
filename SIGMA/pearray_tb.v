`timescale 1ns / 1ps

module pearray_tb;

parameter DATA_WIDTH=32;
parameter NUM_PES=16;
reg clk=1;
reg reset=0;

reg [DATA_WIDTH-1:0] in1;
reg [DATA_WIDTH-1:0] in2;
reg [DATA_WIDTH-1:0] in3;
reg [DATA_WIDTH-1:0] in4;
reg [DATA_WIDTH-1:0] in5;
reg [DATA_WIDTH-1:0] in6;
reg [DATA_WIDTH-1:0] in7;
reg [DATA_WIDTH-1:0] in8;

wire [DATA_WIDTH-1:0] out1, out2, out3, out4;

//wire [(DATA_WIDTH*16)-1:0] out;


//assign out = {out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16};
pearray4X4 #(.DATA_WIDTH(DATA_WIDTH),.NUM_PES(NUM_PES))
        uut
        (.clk(clk),
        .reset(reset),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),

        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
        );
always #1 clk=~clk;

reg enable = 0,enable2= 0,enable3= 0,enable4= 0;
reg[31:0] top1,top2,top3,top4;
reg[31:0] topb1,topb2,topb3,topb4;
reg [31:0] queque1[0:3];
reg [31:0] queque2[0:3];
reg [31:0] queque3[0:3];
reg [31:0] queque4[0:3];

reg [31:0] quequeb1[0:3];
reg [31:0] quequeb2[0:3];
reg [31:0] quequeb3[0:3];
reg [31:0] quequeb4[0:3];
reg [31:0] scratchpad[0:31];
reg[1:0] counter = 0;
//reg[1:0] counter1 = 0;
always@(posedge clk)
begin
//    scratchpad[][]
    counter = counter + 1;
    if(enable && (~reset))
    begin
        in1 <= top1;
        in5 <= topb1;
    end
    else
    begin
        in1 <= 0;
        in5 <= 0;
    end
    if(enable2 && (~reset))
    begin
        in2 <= top2;
        in6 <= topb2;
    end
    else
    begin
        in2 <= 0;
        in6 <= 0;
    end
        
    if(enable3 && (~reset))
    begin
        in3 <= top3;
        in7 <= topb3;
    end
    else
    begin
        in3 <= 0;
        in7 <= 0;
    end
        
    if(enable4 && (~reset))
    begin
        in4 <= top4;
        in8 <= topb4;
    end
    else
    begin
        in4 <= 0;
        in8 <= 0;
    end

    if(counter == 7)
    begin
//        counter1 <= counter1 + 1;
        counter <= 0;
    end
    
end

always@(*)
begin
    top1 <= queque1[3];
    topb1 <= quequeb1[3];
    top2 <= queque2[3];
    topb2 <= quequeb2[3];
    top3 <= queque3[3];
    topb3 <= quequeb3[3];
    top4 <= queque4[3];
    topb4 <= quequeb4[3];
end   
//control

always@(posedge clk)
begin
    if(~reset)
    begin   
    if(counter <= 7)
        counter = counter + 1;
    else
        counter = 7;
    if(counter < 4)
     {enable,enable2,enable3,enable4} <= {1'b1,{enable,enable2,enable3}};
    else
     {enable,enable2,enable3,enable4} <= {1'b0,{enable,enable2,enable3}};
    end
    else
    begin
        counter = 0;
    end
end
integer i;
always@(posedge clk)
begin
    if(enable && (~reset)) begin
       for(i = 4; i > 0; i=i-1)
       begin
          queque1[i] <= queque1[i-1];
          quequeb1[i] <= quequeb1[i-1];
       end
       queque1[0] <= 0;
       quequeb1[0] <= 0;
    end
    if(enable2 && (~reset)) begin
       for(i = 4; i > 0; i=i-1)
       begin
          queque2[i] <= queque2[i-1];
          quequeb2[i] <= quequeb2[i-1];
       end
       queque2[0] <= 0;
       quequeb2[0] <= 0;
    end
    if(enable3 && (~reset)) begin
       for(i = 4; i > 0; i=i-1)
       begin
          queque3[i] <= queque3[i-1];
          quequeb3[i] <= quequeb3[i-1];
       end
       queque3[0] <= 0;
       quequeb3[0] <= 0;
    end
    if(enable4 && (~reset)) begin
       for(i = 4; i > 0; i=i-1)
       begin
          queque4[i] <= queque4[i-1];
          quequeb4[i] <= quequeb4[i-1];
       end
       queque4[0] <= 0;
       quequeb4[0] <= 0;
    end    
end

integer j;

initial 
    begin
    $readmemh("scratchpad.mem",scratchpad);
    $dumpfile ("pearray2.vcd");
    $dumpvars; //Dump variables in the top module.
    for(j = 3; j >= 0; j=j-1)       
    begin
     $display("j = %d",j);
     queque1[j] = scratchpad[j];end
    for(j = 3; j >= 0; j=j-1)       
        queque2[j] = scratchpad[j+4];
    for(j = 3; j >= 0; j=j-1)       
        queque3[j] = scratchpad[j+8];
    for(j = 3; j >= 0; j=j-1)       
        queque4[j] = scratchpad[j+12];
    for(j = 3; j >= 0; j=j-1)       
        quequeb1[j] = scratchpad[j+16];
    for(j = 3; j >= 0; j=j-1)       
        quequeb2[j] = scratchpad[j+20];
    for(j = 3; j >= 0; j=j-1)       
        quequeb3[j] = scratchpad[j+24];
    for(j = 3; j >= 0; j=j-1)       
        quequeb4[j] = scratchpad[j+28];
    
    $display("I am here");
    counter = 0;
    reset=1;
    #(15);
    reset=0;
    
    #120 $finish;
    end
endmodule