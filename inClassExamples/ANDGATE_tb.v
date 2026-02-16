`timescale 1ns / 1ps

module ANDGATE_tb;

	// Inputs
	reg A;
	reg B;

	// Outputs
	wire Y;

	// Instantiate the Unit Under Test (UUT)
	ANDGATE uut (
		.A(A), 
		.B(B), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		
		A=1;
		B=0;
		#20;
		
		A=0;
		B=1;
		
		#20;
		
		A=1;
		B=1;
		#20;
		$finish
		

	end
      
endmodule

