`timescale 1ns / 1ps


module THREEINAND_tb;

	// Inputs
	reg A;
	reg B;
	reg C;

	// Outputs
	wire Y;

	// Instantiate the Unit Under Test (UUT)
	THREEINAND uut (
		.A(A), 
		.B(B), 
		.C(C), 
		.Y(Y)
	);
		integer index;
		
	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		C = 0;
		for(index=0; index<8; index=index+1) begin
			{A, B, C} = index[2:0];
		end
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

