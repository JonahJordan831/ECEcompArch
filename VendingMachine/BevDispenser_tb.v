`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:48:28 02/16/2026
// Design Name:   BevDispenser
// Module Name:   /home/ise/Shared/CoinCounter/BevDispenser_tb.v
// Project Name:  CoinCounter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BevDispenser
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BevDispenser_tb;

	// Inputs
	reg inbev1;
	reg inbev2;
	reg inbev3;
	reg inbev4;
	reg [9:0] moneyin;
	reg clk;
	reg rst;

	// Outputs
	wire outbev1;
	wire outbev2;
	wire outbev3;
	wire outbev4;
	wire [9:0] moneyout;

	// Instantiate the Unit Under Test (UUT)
	BevDispenser uut (
		.inbev1(inbev1), 
		.inbev2(inbev2), 
		.inbev3(inbev3), 
		.inbev4(inbev4),
		.moneyin(moneyin), 
		.outbev1(outbev1), 
		.outbev2(outbev2), 
		.outbev3(outbev3),
		.outbev4(outbev4),
		.moneyout(moneyout),

		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		inbev1 = 0;
		inbev2 = 0;
		inbev3 = 0;
		inbev4 = 0;
		moneyin = 500;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		rst =1;
		#20;
		rst =0;
		#20;
		
		inbev1 =1;
		#20;
		inbev1 =0;
		#20;
		
		inbev2 =1;
		#20;
		inbev2 =0;
		#20;
		
		
		inbev3 =1;
		#20;
		inbev3 =0;
		#20;
		
		inbev4 =1;
		#20;
		inbev4 =0;
		#20;
		
		
		
     
		// Add stimulus here
		$finish;
	end
	always begin
      clk=~clk;
		#10;
		end
		
endmodule

