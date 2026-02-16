`timescale 1ns / 1ps


module BlockingVsNonBlocking_tb;

	// Inputs
	reg [3:0] A;
	reg [3:0] B;
	reg go;

	// Outputs
	wire [7:0] Y;

	// Instantiate the Unit Under Test (UUT)
	BlockingVsNonBlocking uut (
		.A(A), 
		.B(B), 
		.Y(Y), 
		.go(go)
	);

	initial begin
		// Initialize Inputs
		A = 1;
		B = 3;
		go = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		go = 1;
		#20;
		go=0;
		#20;
		go=1;
		#20;
		
		
		$finish;
	end
      
endmodule

