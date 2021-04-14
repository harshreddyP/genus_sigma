//##########################################################
// Generated Fowarding Adder Network Controller (FAN topology routing)
// Author: Eric Qin
// Contact: ecqin@gatech.edu
//##########################################################


module fan_ctrl # (
	parameter DATA_TYPE =  32 ,
	parameter NUM_PES =  4 ,
	parameter LOG2_PES =  2 ) (
	clk,
	rst,
	i_vn,
	i_stationary,
	i_data_valid,
	o_reduction_add,
	o_reduction_cmd,
	o_reduction_sel,
	o_reduction_valid
);
	input clk;
	input rst;
	input [NUM_PES*LOG2_PES-1: 0] i_vn; // different partial sum bit seperator
	input i_stationary; // if input data is for stationary or streaming
	input i_data_valid; // if input data is valid or not
	output reg [(NUM_PES-1)-1:0] o_reduction_add; // determine to add or not
	output reg [3*(NUM_PES-1)-1:0] o_reduction_cmd; // reduction command (for VN commands)
	output reg [-1 : 0] o_reduction_sel; // select bits for FAN topology
	output reg o_reduction_valid; // if reduction output from FAN is valid or not

	// reduction cmd and sel control bits (not flopped for timing yet)
	reg [(NUM_PES-1)-1:0] r_reduction_add;
	reg [3*(NUM_PES-1)-1:0] r_reduction_cmd;
	reg [-1 : 0] r_reduction_sel;


	// diagonal flops for timing fix across different levels in tree (add_en signal)
	reg [1 : 0] r_add_lvl_0;
	reg [1 : 0] r_add_lvl_1;


	// diagonal flops for timing fix across different levels in tree (cmd signal)
	reg [5 : 0] r_cmd_lvl_0;
	reg [5 : 0] r_cmd_lvl_1;


	// diagonal flops for timing fix across different levels in tree (sel signal)


	// timing alignment for i_vn delay and for output valid
	reg [2*NUM_PES*LOG2_PES-1:0] r_vn;
	reg [NUM_PES*LOG2_PES-1:0] w_vn;
	reg [4 : 0 ] r_valid;


	genvar i, x;;
	// add flip flops to delay i_vn
	generate
		for (i=0; i < 2; i=i+1) begin : vn_ff
			if (i == 0) begin: pass
				always @ (posedge clk) begin
					if (rst == 1'b1) begin
						r_vn[(i+1)*NUM_PES*LOG2_PES-1:i*NUM_PES*LOG2_PES] <= 'd0;
					end else begin
						r_vn[(i+1)*NUM_PES*LOG2_PES-1:i*NUM_PES*LOG2_PES] <= i_vn;
					end
				end
			end else begin: flop
				always @ (posedge clk) begin
					if (rst == 1'b1) begin
						r_vn[(i+1)*NUM_PES*LOG2_PES-1:i*NUM_PES*LOG2_PES] <= 'd0;
					end else begin
						r_vn[(i+1)*NUM_PES*LOG2_PES-1:i*NUM_PES*LOG2_PES] <= r_vn[i*NUM_PES*LOG2_PES-1:(i-1)*NUM_PES*LOG2_PES];
					end
				end
			end
		end
	endgenerate

	// assign last flop to w_vn
	always @(*) begin
		w_vn = r_vn[2*NUM_PES*LOG2_PES-1:1*NUM_PES*LOG2_PES];
	end


	// generating control bits for lvl: 0
	// Note: lvl 0 and 1 do not require sel bits
	generate
		for (x=0; x < 2; x=x+1) begin: adders_lvl_0
			if (x == 0) begin: l_edge_case
				always @ (*) begin
					if (rst == 1'b1) begin
						r_reduction_add[0+x] = 'd0;
						r_reduction_cmd[3*0+3*x+:3] = 'd0;
					end else begin
						// generate cmd logic
						if (r_valid[1] == 1'b1) begin
							if (w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_add[0+x] = 1'b1; // add enable
							end else begin
								r_reduction_add[0+x] = 1'b0;
							end


							if (w_vn[(2*x+1)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+2)*LOG2_PES+:LOG2_PES] && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b101; // both vn done
							end else if (w_vn[(2*x+1)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+2)*LOG2_PES+:LOG2_PES] && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b011; // left vn done
							end else begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b000; // nothing
							end
						end else begin
							r_reduction_add[0+x] = 1'b0;
							r_reduction_cmd[3*0+3*x+:3] = 3'b000; // nothing
						end

					end
				end
			end else if (x == 1) begin: r_edge_case
				always @ (*) begin
					if (rst == 1'b1) begin
						r_reduction_add[0+x] = 'd0;
						r_reduction_cmd[3*0+3*x+:3] = 'd0;
					end else begin
						// generate cmd logic
						if (r_valid[1] == 1'b1) begin
							if (w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_add[0+x] = 1'b1; // add enable
							end else begin
								r_reduction_add[0+x] = 1'b0;
							end


							if (w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+-1)*LOG2_PES+:LOG2_PES] && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b101; // both vn done
							end else if (w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+-1)*LOG2_PES+:LOG2_PES] && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b100; // right vn done
							end else begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b000; // nothing
							end

						end else begin
							r_reduction_add[0+x] = 1'b0;
							r_reduction_cmd[3*0+3*x+:3] = 3'b000; // nothing
						end

					end
				end
			end else begin: normal
				always @ (*) begin
					if (rst == 1'b1) begin
						r_reduction_add[0+x] = 'd0;
						r_reduction_cmd[3*0+3*x+:3] = 'd0;
					end else begin
						// generate cmd logic
						if (r_valid[1] == 1'b1) begin
							if (w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_add[0+x] = 1'b1; // add enable
							end else begin
								r_reduction_add[0+x] = 1'b0;
							end


							if ((w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+-1)*LOG2_PES+:LOG2_PES]) && (w_vn[(2*x+1)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+2)*LOG2_PES+:LOG2_PES]) && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b101; // both vn done
							end else if ((w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+-1)*LOG2_PES+:LOG2_PES]) && (w_vn[(2*x+1)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+2)*LOG2_PES+:LOG2_PES]) && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b100; // right vn done
							end else if ((w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+-1)*LOG2_PES+:LOG2_PES]) && (w_vn[(2*x+1)*LOG2_PES+:LOG2_PES] == w_vn[(2*x+2)*LOG2_PES+:LOG2_PES]) && w_vn[(2*x+0)*LOG2_PES+:LOG2_PES] != w_vn[(2*x+1)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b011; // left vn done
							end else begin
								r_reduction_cmd[3*0+3*x+:3] = 3'b001; // bypass
							end

						end else begin
							r_reduction_add[0+x] = 1'b0;
					r_reduction_cmd[3*0+3*x+:3] = 3'b000; // nothing
						end

					end
				end
			end
		end
	endgenerate

	// generating control bits for lvl: 1
	generate
		for (x=0; x < 1; x=x+1) begin: adders_lvl_1
			if (x == 0) begin: middle_case
				always @ (*) begin
					if (rst == 1'b1) begin
						r_reduction_add[2+x] = 'd0;
						r_reduction_cmd[3*2+3*x+:3] = 'd0;
					end else begin
						// generate cmd logic
						if (r_valid[1] == 1'b1) begin
							if (w_vn[(4*x+1)*LOG2_PES+:LOG2_PES] == w_vn[(4*x+2)*LOG2_PES+:LOG2_PES]) begin
								r_reduction_add[2+x] = 1'b1; // add enable
							end else begin
								r_reduction_add[2+x] = 1'b0;
							end


