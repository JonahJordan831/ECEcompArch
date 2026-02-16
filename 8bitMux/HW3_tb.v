`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Jonah Jordan, R11886590
////////////////////////////////////////////////////////////////////////////////

module HW3_tb;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;
	reg [7:0] C;
	reg [7:0] D;
	reg [1:0] sel;

	// Outputs
	wire [7:0] X;

	// Instantiate the Unit Under Test (UUT)
	HW3 uut (
		.A(A), 
		.B(B), 
		.C(C), 
		.D(D), 
		.sel(sel), 
		.X(X)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		C = 0;
		D = 0;
		sel = 0;
		
		

		// Wait 20 ns for global reset to finish
		#20;
        
		// Add stimulus here
		A = 17; B = 34; C = 51; D = 68; sel = 0; #20;  // X = 17
		A = 17; B = 34; C = 51; D = 68; sel = 1; #20;  // X = 34    testing random numbers within the range of 8-bit to see if mux works
		A = 17; B = 34; C = 51; D = 68; sel = 2; #20;  // X = 51
		A = 17; B = 34; C = 51; D = 68; sel = 3; #20;  // X = 68
		
		A = 230; B = 154; C = 1; D = 254; sel = 0;#20;
		A = 230; B = 154; C = 1; D = 254; sel = 1;#20;  // another test case
		A = 230; B = 154; C = 1; D = 254; sel = 2;#20;
		A = 230; B = 154; C = 1; D = 254; sel = 3;#20;

		
$finish;

		end
      
endmodule

