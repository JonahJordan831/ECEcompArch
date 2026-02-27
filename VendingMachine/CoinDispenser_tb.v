`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:11:04 02/27/2026
// Design Name:   CoinDispenser
// Module Name:   /home/ise/Shared/CoinCounter/CoinDispenser_tb.v
// Project Name:  CoinCounter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CoinDispenser
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CoinDispenser_tb;

	// Inputs
	reg [9:0] change;
	wire outquarter;
	wire outdime;
	wire outnickel;
	reg rst;
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	CoinDispenser uut (
		.change(change), 
		.outquarter(outquarter), 
		.outdime(outdime), 
		.outnickel(outnickel), 
		.rst(rst), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		change = 0;
		rst = 0;
		clk = 0;
		#20
		rst = 1;
#20;
rst = 0;
#20;

		// Wait 100 ns for global reset to finish
	change = 40;
#140;
change = 0;
#60;  // give more time instead of just #20

change = 60;
#100;
change = 0;
#60;

change = 75;
#120;
change = 0;
#60;

$finish;
			
		// Add stimulus here

	end
       always begin
        clk = ~clk;
        #10;
    end
endmodule

