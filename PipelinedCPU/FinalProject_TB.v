`timescale 1ns / 1ps

module FinalProject_TB;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [5:0] debug_pc;
	wire debug_Z;
	wire debug_N;
	wire debug_C;
	wire debug_V;

	// Instantiate the Unit Under Test (UUT)
	FinalProjectTop uut (
		.clk(clk), 
		.reset(reset), 
		.debug_pc(debug_pc), 
		.debug_Z(debug_Z), 
		.debug_N(debug_N), 
		.debug_C(debug_C), 
		.debug_V(debug_V)
	);

	// Clock generator
	// 10 ns period = 100 MHz
	always begin
		#5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Hold reset active for a few clock cycles
		#30;
		reset = 0;

		// Let CPU run so you can inspect waveforms
		#3000;

		// Stop simulation
		$stop;
	end
      
endmodule