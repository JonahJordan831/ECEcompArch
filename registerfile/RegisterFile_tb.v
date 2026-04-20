`timescale 1ns / 1ps

/*
Name: Jonah Jordan 
R-Number: R-11886590 
Assignment: Project 2
*/

module RegisterFile_tb;

    // Inputs
    reg clk;
    reg RL;
    reg [4:0] DA;
    reg [31:0] BusD;
    reg [4:0] AA;
    reg [4:0] BA;

    // Outputs
    wire [31:0] BusA;
    wire [31:0] BusB;

    // Instantiate the Unit Under Test (UUT)
    RegisterFile uut (
        .clk(clk), 
        .RL(RL), 
        .DA(DA), 
        .BusD(BusD), 
        .AA(AA), 
        .BA(BA), 
        .BusA(BusA), 
        .BusB(BusB)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk  = 0;
        RL   = 0;
        DA   = 0;
        BusD = 0;
        AA   = 0;
        BA   = 0;

        #20;

        // ================================================
        // Write all 32 registers
        // ================================================
        RL = 1;

        DA = 5'd0;  BusD = 32'hA0000000; @(posedge clk); #1;
        DA = 5'd1;  BusD = 32'hA0000001; @(posedge clk); #1;
        DA = 5'd2;  BusD = 32'hA0000002; @(posedge clk); #1;
        DA = 5'd3;  BusD = 32'hA0000003; @(posedge clk); #1;
        DA = 5'd4;  BusD = 32'hA0000004; @(posedge clk); #1;
        DA = 5'd5;  BusD = 32'hA0000005; @(posedge clk); #1;
        DA = 5'd6;  BusD = 32'hA0000006; @(posedge clk); #1;
        DA = 5'd7;  BusD = 32'hA0000007; @(posedge clk); #1;
        DA = 5'd8;  BusD = 32'hA0000008; @(posedge clk); #1;
        DA = 5'd9;  BusD = 32'hA0000009; @(posedge clk); #1;
        DA = 5'd10; BusD = 32'hA000000A; @(posedge clk); #1;
        DA = 5'd11; BusD = 32'hA000000B; @(posedge clk); #1;
        DA = 5'd12; BusD = 32'hA000000C; @(posedge clk); #1;
        DA = 5'd13; BusD = 32'hA000000D; @(posedge clk); #1;
        DA = 5'd14; BusD = 32'hA000000E; @(posedge clk); #1;
        DA = 5'd15; BusD = 32'hA000000F; @(posedge clk); #1;
        DA = 5'd16; BusD = 32'hA0000010; @(posedge clk); #1;
        DA = 5'd17; BusD = 32'hA0000011; @(posedge clk); #1;
        DA = 5'd18; BusD = 32'hA0000012; @(posedge clk); #1;
        DA = 5'd19; BusD = 32'hA0000013; @(posedge clk); #1;
        DA = 5'd20; BusD = 32'hA0000014; @(posedge clk); #1;
        DA = 5'd21; BusD = 32'hA0000015; @(posedge clk); #1;
        DA = 5'd22; BusD = 32'hA0000016; @(posedge clk); #1;
        DA = 5'd23; BusD = 32'hA0000017; @(posedge clk); #1;
        DA = 5'd24; BusD = 32'hA0000018; @(posedge clk); #1;
        DA = 5'd25; BusD = 32'hA0000019; @(posedge clk); #1;
        DA = 5'd26; BusD = 32'hA000001A; @(posedge clk); #1;
        DA = 5'd27; BusD = 32'hA000001B; @(posedge clk); #1;
        DA = 5'd28; BusD = 32'hA000001C; @(posedge clk); #1;
        DA = 5'd29; BusD = 32'hA000001D; @(posedge clk); #1;
        DA = 5'd30; BusD = 32'hA000001E; @(posedge clk); #1;
        DA = 5'd31; BusD = 32'hA000001F; @(posedge clk); #1;

        RL = 0;
        #10;

        
        // Read all registers, Bus A and Bus B should show opposite registers 
        
        
        AA = 5'd0;  BA = 5'd31; #10;
        AA = 5'd1;  BA = 5'd30; #10;
        AA = 5'd2;  BA = 5'd29; #10;
        AA = 5'd3;  BA = 5'd28; #10;
        AA = 5'd4;  BA = 5'd27; #10;
        AA = 5'd5;  BA = 5'd26; #10;
        AA = 5'd6;  BA = 5'd25; #10;
        AA = 5'd7;  BA = 5'd24; #10;
        AA = 5'd8;  BA = 5'd23; #10;
        AA = 5'd9;  BA = 5'd22; #10;
        AA = 5'd10; BA = 5'd21; #10;
        AA = 5'd11; BA = 5'd20; #10;
        AA = 5'd12; BA = 5'd19; #10;
        AA = 5'd13; BA = 5'd18; #10;
        AA = 5'd14; BA = 5'd17; #10;
        AA = 5'd15; BA = 5'd16; #10;
        AA = 5'd16; BA = 5'd15; #10;
        AA = 5'd17; BA = 5'd14; #10;
        AA = 5'd18; BA = 5'd13; #10;
        AA = 5'd19; BA = 5'd12; #10;
        AA = 5'd20; BA = 5'd11; #10;
        AA = 5'd21; BA = 5'd10; #10;
        AA = 5'd22; BA = 5'd9;  #10;
        AA = 5'd23; BA = 5'd8;  #10;
        AA = 5'd24; BA = 5'd7;  #10;
        AA = 5'd25; BA = 5'd6;  #10;
        AA = 5'd26; BA = 5'd5;  #10;
        AA = 5'd27; BA = 5'd4;  #10;
        AA = 5'd28; BA = 5'd3;  #10;
        AA = 5'd29; BA = 5'd2;  #10;
        AA = 5'd30; BA = 5'd1;  #10;
        AA = 5'd31; BA = 5'd0;  #10;

        #20;
		  // testing some middle bit value cases
		  
		  RL = 1;
        DA = 5'd0;  BusD = 32'hDEADBEEF; @(posedge clk); #1;
        DA = 5'd1;  BusD = 32'h12345678; @(posedge clk); #1;
        DA = 5'd2;  BusD = 32'hCAFEBABE; @(posedge clk); #1;
        DA = 5'd3;  BusD = 32'hBEEFCAFE; @(posedge clk); #1;
        DA = 5'd4;  BusD = 32'h55AA55AA; @(posedge clk); #1;
        DA = 5'd5;  BusD = 32'hAA55AA55; @(posedge clk); #1;
        RL = 0;
        #10;
		  
		  AA = 5'd0; BA = 5'd1; #10; // BusA = DEADBEEF, BusB = 12345678
        AA = 5'd2; BA = 5'd3; #10; // BusA = CAFEBABE, BusB = BEEFCAFE
        AA = 5'd4; BA = 5'd5; #10; // BusA = 55AA55AA, BusB = AA55AA55
        AA = 5'd1; BA = 5'd0; #10; // Swap: BusA = 12345678, BusB = DEADBEEF
        AA = 5'd3; BA = 5'd2; #10; // Swap: BusA = BEEFCAFE, BusB = CAFEBABE
        AA = 5'd5; BA = 5'd4; #10; // Swap: BusA = AA55AA55, BusB = 55AA55AA
        #10;
		  
        $finish;
    end

endmodule
