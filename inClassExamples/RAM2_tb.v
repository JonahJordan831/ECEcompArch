`timescale 1ns / 1ps

module RAM2_tb;

	// Inputs
	reg [3:0] dataIN;
	reg WR;
	reg [3:0] addr;
	reg rst;
	reg clk;

	// Outputs
	wire [3:0] dataOUT;

	// Instantiate the Unit Under Test (UUT)
	RAM2 uut (
		.dataIN(dataIN), 
		.dataOUT(dataOUT), 
		.WR(WR), 
		.addr(addr), 
		.rst(rst), 
		.clk(clk)
	);
	integer index;
	initial begin
		// Initialize Inputs
		dataIN = 0;
		WR = 0;
		addr = 0;
		rst = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		rst=1;
		#20;
		rst=0;
		#20;
        
		// Add stimulus here
		
		for(index = 0; index<16; index=index+1) begin
		addr = index;
		dataIN=index;
		#20;
		WR=1;
		#20;
		WR=0;
		#20;
		end
		
		
		
		
		end
		
	always begin
	
	clk=~clk;
	#5;

	end
      
endmodule

