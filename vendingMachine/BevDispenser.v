`timescale 1ns / 1ps

module BevDispenser(inbev1, inbev2, inbev3, moneyin, outbev1, outbev2, outbev3, clk, rst);

parameter BEV1_COST = 125;
parameter BEV2_COST = 220;
parameter BEV3_COST = 175;

input inbev1, inbev2, inbev3, rst, clk;
input [9:0] moneyin;
output reg outbev1, outbev2, outbev3;

reg start;


always @(posedge clk) begin
	if(rst == 1) begin
		outbev1 <= 0;
		outbev2 <= 0;
		outbev3 <= 0;
		start <=0;
	end else begin
	if(inbev1 == 1&& moneyin >= BEV1_COST) begin
		outbev1 <= 1;
		outbev2 <= 0;
		outbev3 <= 0;
		start <=1;
		end else if (inbev2 == 1&& moneyin >= BEV2_COST) begin
		outbev1 <= 0;
		outbev2 <= 1;
		outbev3 <= 0;
		start <=1;
		end else if (inbev3 == 1&& moneyin >= BEV3_COST) begin
		outbev1 <= 0;
		outbev2 <= 0;
		outbev3 <= 1;
		start <=1;
	end
	if(start ==1) begin
		start <=0;
		outbev1 <=0;
		outbev2 <=0;
		outbev3 <=0;
	end
end
end

endmodule
