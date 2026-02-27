`timescale 1ns / 1ps



module main_tb;

	// Inputs
	reg inbev1;
	reg inbev2;
	reg inbev3;
	reg inbev4;
	reg inQuarter;
	reg inDime;
	reg inNickel;
	reg resetCount;
	reg clk;
	reg rst;
	reg cancel;


	// Outputs
	wire outbev1;
	wire outbev2;
	wire outbev3;
	wire outbev4;
	wire outquarter;
	wire outdime;
	wire outnickel;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.inbev1(inbev1), 
		.inbev2(inbev2), 
		.inbev3(inbev3), 
		.inbev4(inbev4), 
		.inQuarter(inQuarter), 
		.inDime(inDime), 
		.inNickel(inNickel), 
		.resetCount(resetCount), 
		.outbev1(outbev1), 
		.outbev2(outbev2), 
		.outbev3(outbev3), 
		.outbev4(outbev4), 
		.outquarter(outquarter), 
		.outdime(outdime), 
		.outnickel(outnickel), 
		.clk(clk), 
		.rst(rst),
		.cancel(cancel)
	);

	initial begin
		// Initialize Inputs
		inbev1 = 0;
		inbev2 = 0;
		inbev3 = 0;
		inbev4 = 0;
		inQuarter = 0;
		inDime = 0;
		inNickel = 0;
		resetCount = 0;
		clk = 0;
		rst = 0;
		cancel = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		rst = 1; #20;
    rst = 0; #20;
	 
	 
	 // =====================
    // Test 1: insert 150 cents (6 quarters), buy bev1 (costs 125)
    // expect outbev1 pulse, change = 25 (1 quarter back)
    // =====================
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    #40;
    inbev1 = 1; #20; inbev1 = 0;
    #200;
    rst = 1; #60;
    rst = 0; #40;

    // =====================
    // Test 2: insert 220 cents exact (8 quarters + 2 dimes), buy bev2 (costs 220)
    // expect outbev2 pulse, no change back
    // =====================
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inDime = 1; #20; inDime = 0; #20;
    inDime = 1; #20; inDime = 0; #20;
    #40;
    inbev2 = 1; #20; inbev2 = 0;
    #200;
    rst = 1; #60;
    rst = 0; #40;

    // =====================
    // Test 3: insert 200 cents (8 quarters), buy bev3 (costs 175)
    // expect outbev3 pulse, change = 25 (1 quarter back)
    // =====================
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    #40;
    inbev3 = 1; #20; inbev3 = 0;
    #200;
    rst = 1; #60;
    rst = 0; #40;

    // =====================
    // Test 4: insert 1 quarter 1 dime 1 nickel (40 cents), cancel
    // expect 1 quarter, 1 dime, 1 nickel back
    // =====================
    inQuarter = 1; #20; inQuarter = 0; #20;
    inDime    = 1; #20; inDime    = 0; #20;
    inNickel  = 1; #20; inNickel  = 0; #20;
    #40;
    cancel = 1; #20; cancel = 0;
    #200;

    


// =====================
   
 rst = 1; #60;
    rst = 0; #40;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
	 inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inNickel = 1; #20; inNickel = 0; #20;
	 inNickel = 1; #20; inNickel = 0; #20;
	inNickel = 1; #20; inNickel = 0; #20;
    #40;
    inbev4 = 1; #20; inbev4 = 0;
    #200;
	 
	 inbev1 = 0;
		inbev2 = 0;
		inbev3 = 0;
		inbev4 = 0;
		inQuarter = 0;
		inDime = 0;
		inNickel = 0;
		resetCount = 0;
		clk = 0;
		rst = 0;
		cancel = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		rst = 1; #20;
    rst = 0; #20;

// Test 6 not enough money, bev4 costs 310, only insert 200 (8 quarters)
    // expect NO beverage dispensed, NO change
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
	 inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    inQuarter = 1; #20; inQuarter = 0; #20;
    #40;
    inbev4 = 1; #20; inbev4 = 0;
    #100;

	 
	 
    $finish;

	 


	end
      always begin
    clk = ~clk;
    #10;
end
endmodule

