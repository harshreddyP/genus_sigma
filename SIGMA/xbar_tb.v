    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 02.03.2021 17:17:40
    // Design Name: 
    // Module Name: tb_crossbar
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////


    module tb_crossbar;
        parameter DATA_TYPE = 16;
        parameter NUM_PES = 16;
        parameter INPUT_BW = 16;
        parameter LOG2_PES = 4;
        parameter NUM_TESTS = 4;
        reg clk;
        reg rst;
        reg [INPUT_BW*DATA_TYPE-1 : 0] i_data_bus;
        reg [LOG2_PES * NUM_PES -1 : 0] i_mux_bus;
        
        wire [NUM_PES * DATA_TYPE -1 : 0] o_dist_bus;
        
            reg [10:0] counter = 'd0;

        xbar #(
            .DATA_TYPE(DATA_TYPE),
            .NUM_PES(NUM_PES),
            .INPUT_BW(NUM_PES),
            .LOG2_PES(LOG2_PES))
            my_xbar_1 (
            .clk(clk),
            .rst(rst),
            .i_data_bus(i_data_bus),
            .i_mux_bus(i_mux_bus),
            .o_dist_bus(o_dist_bus)
        );
        
        initial begin
        $dumpfile ("xbar_iv_16_syn.vcd");
        $dumpvars;
        rst = 1;
        clk = 0;
        #5
        rst = 0;
        #18 $finish;
        end
        
	always
	   #1 clk = ~clk;
// 	reg [(NUM_PES * DATA_TYPE * NUM_TESTS)-1 : 0] i_data_list_bus =
// 		{
// //            64'h3F80_4000_4040_4080_40A0_40C0_40E0_4100_4110_4120_4130_4140_4150_4160_4170_4180, // 1 2 3 4 5 6 7 8 
//             64'h3F80_4000_4040_4080, // 1 2 3 4 5 6 7 8 
// 			64'h40A0_40C0_40E0_4100,
// 			64'h4110_4120_4130_4140,
// 			64'h4150_4160_4170_4180};
	
	reg [(NUM_PES * DATA_TYPE * NUM_TESTS)-1 : 0] i_data_list_bus =
		{
            256'h3F80_4000_4040_4080_40A0_40C0_40E0_4100_4110_4120_4130_4140_4150_4160_4170_4180, // 1 2 3 4 5 6 7 8 
			256'h3F80_40A0_4110_4150_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000,
			256'h4000_40C0_4120_4160_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000,
			256'h4040_40E0_4130_4170_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000};
	//*
    /*	
    reg [(NUM_PES * LOG2_PES *NUM_TESTS)-1:0] i_dest_bus =
		{
			8'b11_10_01_00, // stationary
			8'b11_10_01_00, // streaming
			8'b11_10_01_00, // streaming
			8'b11_10_01_00};	
	*/
	reg [(NUM_PES * LOG2_PES * NUM_TESTS)-1 : 0] i_dest_bus =
		{
			64'b1111_1110_1101_1100_1011_1010_1001_1000_0111_0110_0101_0100_0011_0010_0001_0000, // stationary
			64'b1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100, // streaming
			64'b1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100, // streaming
			64'b1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100_1111_1110_1101_1100};
			//*/		
    always @ (posedge clk) begin
		if (rst == 1'b0 && counter < NUM_TESTS) begin
			i_data_bus = i_data_list_bus[counter*(INPUT_BW*DATA_TYPE) +: (INPUT_BW*DATA_TYPE)];
			i_mux_bus = i_dest_bus[counter*(LOG2_PES * NUM_PES) +: (LOG2_PES * NUM_PES)];
			if (counter < NUM_TESTS) begin
				counter = counter + 1'b1;
			end
		end else begin
			i_data_bus = 'd0;
			i_mux_bus = 'd0;
		end
	end
	
	
endmodule

