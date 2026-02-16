`timescale 1ns / 1ps

module RAM_tb;

	// Inputs
	reg [3:0] dataIN;
	reg WR;
	reg RD;
	reg [3:0] addr;

	// Outputs
	wire [3:0] dataOUT;

	// Instantiate the Unit Under Test (UUT)
	RAM uut (
		.dataIN(dataIN), 
		.dataOUT(dataOUT), 
		.WR(WR), 
		.RD(RD), 
		.addr(addr)
	);
	integer index;
	initial begin
		// Initialize Inputs
		dataIN = 0;
		WR = 0;
		RD = 0;
		addr = 0;

		// Wait 20 ns for global reset to finish
		#20;
		
		for(index=0; index<16; index= index+1) begin
		
		addr=index[3:0];
        
		dataIN = 4'h5 + index;
		#5;
		WR = 1;
		#20;
		WR=0;
		#20;
	end
		$finish;

	end
      
endmodule

