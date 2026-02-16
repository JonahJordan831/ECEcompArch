`timescale 1ns / 1ps

module CoinCounter_tb;

	// Inputs
	reg inQuarter;
	reg inDime;
	reg inNickel;
	reg resetCount;

	// Outputs
	wire [9:0] outCount;

	// Instantiate the Unit Under Test (UUT)
	CoinCounter uut (
		.inQuarter(inQuarter), 
		.inDime(inDime), 
		.inNickel(inNickel), 
		.outCount(outCount), 
		.resetCount(resetCount)
	);

	initial begin
		// Initialize Inputs
		inQuarter = 0;
		inDime = 0;
		inNickel = 0;
		resetCount = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		
		resetCount=1;
		#20;
		resetCount=0;
		#20;
		
		inQuarter=1;
		#20;
		inQuarter=0;
		#20;
		
		inDime=1;
		#20;
		inDime=0;
		#20;
		
		inNickel=1;
		#20;
		inNickel=0;
		#20;



		
			end
      
endmodule

