`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:46:06 02/04/2026
// Design Name:   ThreeToEightDEC
// Module Name:   /home/ise/Shared/ThreeToEightDecoder/ThreeToEightDEC_tb.v
// Project Name:  ThreeToEightDecoder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ThreeToEightDEC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ThreeToEightDEC_tb;

	// Inputs
	reg [2:0] A;

	// Outputs
	wire H;
	wire I;
	wire J;
	wire K;
	wire L;
	wire M;
	wire N;
	wire O;

	// Instantiate the Unit Under Test (UUT)
	ThreeToEightDEC uut (
		.A(A), 
		.H(H), 
		.I(I), 
		.J(J), 
		.K(K), 
		.L(L), 
		.M(M), 
		.N(N), 
		.O(O)
	);

	initial begin
		// Initialize Inputs
		A = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

