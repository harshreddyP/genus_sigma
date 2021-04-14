//##########################################################
// Generated Fowarding Adder Network (FAN topology)
// Author: Eric Qin
// Contact: ecqin@gatech.edu
//##########################################################


module fan_network # (
	parameter DATA_TYPE =  32 ,
	parameter NUM_PES =  4 ,
	parameter LOG2_PES =  2 ) (
	clk,
	rst,
	i_valid,
	i_data_bus,
	i_add_en_bus,
	i_cmd_bus,
	i_sel_bus,
	o_valid,
	o_data_bus
);
	input clk;
	input rst;
	input i_valid; // valid input data bus
	input [NUM_PES*DATA_TYPE-1 : 0] i_data_bus; // input data bus
	input [(NUM_PES-1)-1 : 0] i_add_en_bus; // adder enable bus
	input [3*(NUM_PES-1)-1 : 0] i_cmd_bus; // command bits for each adder
	input [-1 : 0] i_sel_bus; // select bits for FAN topolgy
	output reg [NUM_PES-1 : 0] o_valid; // output valid signal
	output reg [NUM_PES*DATA_TYPE-1 : 0] o_data_bus; // output data bus

	// tree wires (includes binary and forwarding wires)
	wire [ 63  : 0] w_fan_lvl_0;
	wire [ 31  : 0] w_fan_lvl_1;


	// flop forwarding levels across levels to maintain pipeline timing


	// output virtual neuron (completed partial sums) wires for each level and valid bits
	wire [127 : 0] w_vn_lvl_0;
	wire [3 : 0] w_vn_lvl_0_valid;
	wire [63 : 0] w_vn_lvl_1;
	wire [1 : 0] w_vn_lvl_1_valid;


	// output ff within each level of adder tree to maintain pipeline behavior
	reg [255 : 0] r_lvl_output_ff;
	reg [7 : 0] r_lvl_output_ff_valid;


	// valid FFs for each level of the adder tree
	reg [3 : 0] r_valid;
	// flop final adder output cmd and values
	reg [DATA_TYPE-1:0] r_final_sum;
	reg r_final_add;
	reg r_final_add2;
	// FAN topology flip flops between forwarding levels to maintain pipeline timing
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
		end else begin
		end
	end


	// Output Buffers and Muxes across all levels to pipeline finished VNs (complete Psums)
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_lvl_output_ff[127:0] <= 'd0;
			r_lvl_output_ff_valid[3:0] <= 'd0;
		end else begin
			if (w_vn_lvl_0_valid[1:0] == 2'b11) begin // both VN complete
				r_lvl_output_ff[63:0] <= w_vn_lvl_0[63:0];
				r_lvl_output_ff_valid[1:0] <= 2'b11;
			end else if (w_vn_lvl_0_valid[1:0] == 2'b10) begin // right VN complete
				r_lvl_output_ff[63:32] <= w_vn_lvl_0[63:32];
				r_lvl_output_ff[31:0] <= 'd0;
				r_lvl_output_ff_valid[1:0] <= 2'b10;
			end else if (w_vn_lvl_0_valid[1:0] == 2'b01) begin // left VN complete
				r_lvl_output_ff[63:0] <= 'd0;
				r_lvl_output_ff[31:0] <= w_vn_lvl_0[31:0];
				r_lvl_output_ff_valid[1:0] <= 2'b01;
			end else begin // no VN complete
				r_lvl_output_ff[63:0] <= 'd0; 
				r_lvl_output_ff_valid[1:0] <= 2'b00;
			end


			if (w_vn_lvl_0_valid[3:2] == 2'b11) begin // both VN complete
				r_lvl_output_ff[127:64] <= w_vn_lvl_0[127:64];
				r_lvl_output_ff_valid[3:2] <= 2'b11;
			end else if (w_vn_lvl_0_valid[3:2] == 2'b10) begin // right VN complete
				r_lvl_output_ff[127:96] <= w_vn_lvl_0[127:96];
				r_lvl_output_ff[95:64] <= 'd0;
				r_lvl_output_ff_valid[3:2] <= 2'b10;
			end else if (w_vn_lvl_0_valid[3:2] == 2'b01) begin // left VN complete
				r_lvl_output_ff[127:64] <= 'd0;
				r_lvl_output_ff[95:64] <= w_vn_lvl_0[95:64];
				r_lvl_output_ff_valid[3:2] <= 2'b01;
			end else begin // no VN complete
				r_lvl_output_ff[127:64] <= 'd0; 
				r_lvl_output_ff_valid[3:2] <= 2'b00;
			end


		end
	end


	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_lvl_output_ff[255:128] <= 'd0;
			r_lvl_output_ff_valid[7:4] <= 'd0;
		end else begin
			r_lvl_output_ff[159:128] <= r_lvl_output_ff[31:0];
			r_lvl_output_ff_valid[4] <= r_lvl_output_ff_valid[0];


			if (w_vn_lvl_1_valid[0] == 1'b1) begin
				r_lvl_output_ff[191:160] <= w_vn_lvl_1[31:0];
				r_lvl_output_ff_valid[5] <= 1'b1;
			end else begin
				r_lvl_output_ff[191:160] <= r_lvl_output_ff[63:32];
				r_lvl_output_ff_valid[5] <= r_lvl_output_ff_valid[1];
			end


			if (w_vn_lvl_1_valid[1] == 1'b1) begin
				r_lvl_output_ff[223:192] <= w_vn_lvl_1[63:32];
				r_lvl_output_ff_valid[6] <= 1'b1;
			end else begin
				r_lvl_output_ff[223:192] <= r_lvl_output_ff[95:64];
				r_lvl_output_ff_valid[6] <= r_lvl_output_ff_valid[2];
			end


			r_lvl_output_ff[255:224] <= r_lvl_output_ff[127:96];
			r_lvl_output_ff_valid[7] <= r_lvl_output_ff_valid[3];


		end
	end


	// Flop input valid for different level of the adder tree
	always @ (*) begin
		if (i_valid == 1'b1) begin
			r_valid[0] <= 1'b1;
		end else begin
			r_valid[0] <= 1'b0;
		end
	end

	genvar i;
	generate
		for (i=0; i < 3; i=i+1) begin
			always @ (posedge clk) begin
				if (rst == 1'b1) begin
					r_valid[i+1] <= 1'b0;
				end else begin
					r_valid[i+1] <= r_valid[i];
				end
			end
		end
	endgenerate

	// Instantiating Adder Switches

	edge_adder_switch #(
		.DATA_TYPE( 32 ),
		.NUM_IN( 2 ),
		.SEL_IN( 2 )) my_adder_0 (
		.clk(clk),
		.rst(rst),
		.i_valid(r_valid[0]),
		.i_data_bus(i_data_bus[63 : 0]),
		.i_add_en(i_add_en_bus[0]),
		.i_cmd(i_cmd_bus[2:0]),
		.i_sel(2'b00),
		.o_vn(w_vn_lvl_0[63 : 0]),
		.o_vn_valid(w_vn_lvl_0_valid[1 : 0]),
		.o_adder(w_fan_lvl_0[31 : 0])
	);

	edge_adder_switch #(
		.DATA_TYPE( 32 ),
		.NUM_IN( 2 ),
		.SEL_IN( 2 )) my_adder_1 (
		.clk(clk),
		.rst(rst),
		.i_valid(r_valid[1]),
		.i_data_bus({ w_fan_lvl_0[63:32], w_fan_lvl_0[31:0]}),
		.i_add_en(i_add_en_bus[2]),
		.i_cmd(i_cmd_bus[8:6]),
		.i_sel(2'b00),
		.o_vn(w_vn_lvl_1[63 : 0]),
		.o_vn_valid(w_vn_lvl_1_valid[1 : 0]),
		.o_adder(w_fan_lvl_1[31 : 0])
	);

	edge_adder_switch #(
		.DATA_TYPE( 32 ),
		.NUM_IN( 2 ),
		.SEL_IN( 2 )) my_adder_2 (
		.clk(clk),
		.rst(rst),
		.i_valid(r_valid[0]),
		.i_data_bus(i_data_bus[127 : 64]),
		.i_add_en(i_add_en_bus[1]),
		.i_cmd(i_cmd_bus[5:3]),
		.i_sel(2'b00),
		.o_vn(w_vn_lvl_0[127 : 64]),
		.o_vn_valid(w_vn_lvl_0_valid[3 : 2]),
		.o_adder(w_fan_lvl_0[63 : 32])
	);


	// Flop last level adder cmd for timing matching
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			r_final_add <= 'd0;
			r_final_add2 <= 'd0;
			r_final_sum <= 'd0;
		end else begin
			r_final_add <= i_add_en_bus[2];
			r_final_add2 <= r_final_add;
			r_final_sum <= w_fan_lvl_1;
			end
	end


	// Assigning output bus (with correct timing and final adder mux)
	always @ (*) begin
		if (rst == 1'b1) begin
			o_data_bus <= 'd0;
		end else begin
			o_data_bus[31:0] <= r_lvl_output_ff[159:128];
			if (r_final_add2 == 1'b1) begin
				o_data_bus[63:32] <= r_final_sum;
			end else begin
				o_data_bus[63:32] <= r_lvl_output_ff[191:160];
			end
			o_data_bus[127:64] <= r_lvl_output_ff[255:192];
		end
	end


	// Assigning output valid (with correct timing and final adder mux)
	always @ (*) begin
		if (rst == 1'b1 || r_valid[3] == 1'b0) begin
			o_valid <= 'd0;
		end else begin
			o_valid[0:0] <= r_lvl_output_ff_valid[5:4];
			if (r_final_add2 == 1'b1) begin
				o_valid[1] <= 1'b1 ;
			end else begin
				o_valid[1] <= r_lvl_output_ff_valid[5];
			end
			o_valid[3:2] <= r_lvl_output_ff_valid[7:6];
		end
	end


endmodule
