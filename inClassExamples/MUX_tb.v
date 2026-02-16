`timescale 1ns / 1ps


module MUX_tb;

	// Outputs
	wire Y;

	// Instantiate the Unit Under Test (UUT)
	MUX uut (
		.()
	);

	initial begin
		// Initialize Inputs
		sel = 0;
		A=0;
		B=0;
		// Wait 100 ns for global reset to finish
		#20;
        
		A=1;
		
		#20;
		B=1;
		#20;
		A=0;
		
		sel=1;
		#20;
		A=0;
		B=0;
		
		$finish
		// Add stimulus here

	end
      
endmodule

