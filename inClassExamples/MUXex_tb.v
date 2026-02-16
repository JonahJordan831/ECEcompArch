`timescale 1ns / 1ps

module MUXex_tb;

	// Inputs
	reg [1:0] sel;
	reg [3:0] A;
	reg [3:0] B;
	reg [3:0] C;
	reg [3:0] D;

	// Outputs
	wire [3:0] Y;

	// Instantiate the Unit Under Test (UUT)
	MUXex uut (
		.sel(sel), 
		.A(A), 
		.B(B), 
		.C(C), 
		.D(D), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		sel = 2'd0;
		A = 4'd0;
		B = 4'd4;
		C = 4'hA;
		D = 4'h7;

		// Wait 100 ns for global reset to finish
		#20;
		
		sel= 2'd1;
		#20;
		sel= 2'd2;
		#20;
		sel= 2'd3;
		#20;
		$finish;
        
		// Add stimulus here

	end
      
endmodule

