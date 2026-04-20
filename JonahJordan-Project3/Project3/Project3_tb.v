`timescale 1ns / 1ps
/* 
Name: Jonah Jordan 
R-Number: R-11886590 
Assignment: Project 3 
*/
module Project3_tb;
	// Inputs
	reg clk;
	reg reset;
	reg [31:0] busA;
	reg [31:0] busB;
	reg [4:0] opcode;
	// Outputs
	wire [31:0] result;
	wire Z;
	wire N;
	wire C;
	wire V;
	// Instantiate the Unit Under Test (UUT)
	ALU_FU uut (
		.clk(clk), 
		.reset(reset), 
		.busA(busA), 
		.busB(busB), 
		.opcode(opcode), 
		.result(result), 
		.Z(Z), 
		.N(N), 
		.C(C), 
		.V(V)
	);

	// Clock: toggle every 10 ns → 20 ns period
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		busA = 0;
		busB = 0;
		opcode = 0;
		// Wait 20 ns for global reset to finish
		#20;

		// -------------------------------------------------------
		// LD - pass through busA, no flags affected
		// -------------------------------------------------------
		busA = 32'hDEADBEEF; busB = 32'h0; opcode = 5'h01; #20;
		busA = 32'h00000000; busB = 32'hFFFFFFFF; opcode = 5'h01; #20;
		busA = 32'h12345678; busB = 32'hABCDEF00; opcode = 5'h01; #20;

		// -------------------------------------------------------
		// ADD - Z, N, C, V affected
		// -------------------------------------------------------
		busA = 32'd5;        busB = 32'd3;        opcode = 5'h03; #20; // 5 + 3 = 8
		busA = 32'd0;        busB = 32'd0;        opcode = 5'h03; #20; // 0 + 0 = 0, Z=1
		busA = 32'hFFFFFFFE; busB = 32'h00000001; opcode = 5'h03; #20; // negative result, N=1
		busA = 32'hFFFFFFFF; busB = 32'h00000001; opcode = 5'h03; #20; // carry out, C=1 Z=1
		busA = 32'h7FFFFFFF; busB = 32'h00000001; opcode = 5'h03; #20; // signed overflow, V=1 N=1
		busA = 32'h7FFFFFFF; busB = 32'h7FFFFFFF; opcode = 5'h03; #20; // both max positive, V=1 N=1

		// -------------------------------------------------------
		// SUB - Z, N, C, V affected
		// -------------------------------------------------------
		busA = 32'd10;       busB = 32'd3;        opcode = 5'h04; #20; // 10 - 3 = 7
		busA = 32'd5;        busB = 32'd5;        opcode = 5'h04; #20; // 5 - 5 = 0, Z=1
		busA = 32'd3;        busB = 32'd10;       opcode = 5'h04; #20; // negative result, N=1
		busA = 32'h80000000; busB = 32'h00000001; opcode = 5'h04; #20; // signed overflow, V=1

		// -------------------------------------------------------
		// AND - Z only affected
		// -------------------------------------------------------
		busA = 32'hFF00FF00; busB = 32'h0F0F0F0F; opcode = 5'h05; #20; // typical AND
		busA = 32'hAAAAAAAA; busB = 32'h55555555; opcode = 5'h05; #20; // result zero, Z=1
		busA = 32'hFFFFFFFF; busB = 32'hFFFFFFFF; opcode = 5'h05; #20; // all ones

		// -------------------------------------------------------
		// OR - Z only affected
		// -------------------------------------------------------
		busA = 32'hF0F0F0F0; busB = 32'h0F0F0F0F; opcode = 5'h06; #20; // all ones result
		busA = 32'h00000000; busB = 32'h00000000; opcode = 5'h06; #20; // zero result, Z=1
		busA = 32'hA5A5A5A5; busB = 32'h5A5A5A5A; opcode = 5'h06; #20; // typical OR

		// -------------------------------------------------------
		// XOR - Z only affected
		// -------------------------------------------------------
		busA = 32'hABCDEF01; busB = 32'hABCDEF01; opcode = 5'h07; #20; // same values → 0, Z=1
		busA = 32'hFF00FF00; busB = 32'h0F0F0F0F; opcode = 5'h07; #20; // typical XOR
		busA = 32'hFFFFFFFF; busB = 32'h00000000; opcode = 5'h07; #20; // XOR with zero = self

		// -------------------------------------------------------
		// NOT - Z only affected (busB ignored)
		// -------------------------------------------------------
		busA = 32'h00000000; busB = 32'h0; opcode = 5'h08; #20; // NOT zeros → all ones
		busA = 32'hFFFFFFFF; busB = 32'h0; opcode = 5'h08; #20; // NOT ones → zero, Z=1
		busA = 32'hA5A5A5A5; busB = 32'h0; opcode = 5'h08; #20; // typical NOT

		// -------------------------------------------------------
		// SL - Z and C affected
		// -------------------------------------------------------
		busA = 32'h00000001; busB = 32'd4;  opcode = 5'h09; #20; // shift left 4
		busA = 32'h80000001; busB = 32'd1;  opcode = 5'h09; #20; // MSB shifted out, C=1
		busA = 32'h00000001; busB = 32'd31; opcode = 5'h09; #20; // shift to MSB position
		busA = 32'h80000000; busB = 32'd1;  opcode = 5'h09; #20; // shifts to zero, Z=1 C=1
		busA = 32'hABCDEF12; busB = 32'd0;  opcode = 5'h09; #20; // shift by 0, no change

		// -------------------------------------------------------
		// SR - Z only affected
		// -------------------------------------------------------
		busA = 32'h00000010; busB = 32'd4;  opcode = 5'h0A; #20; // shift right 4
		busA = 32'h00000001; busB = 32'd1;  opcode = 5'h0A; #20; // shifts to zero, Z=1
		busA = 32'hFFFFFFFF; busB = 32'd1;  opcode = 5'h0A; #20; // logical shift (MSB = 0)
		busA = 32'hDEADBEEF; busB = 32'd0;  opcode = 5'h0A; #20; // shift by 0, no change
		busA = 32'h80000000; busB = 32'd31; opcode = 5'h0A; #20; // shift MSB all the way down

		#20;
		$finish;
	end

	      
endmodule