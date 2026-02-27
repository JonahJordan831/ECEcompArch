`timescale 1ns / 1ps

module BevDispenser(inbev1, inbev2, inbev3, inbev4, moneyin, outbev1, outbev2, outbev3, outbev4, moneyout, clk, rst);

parameter BEV1_COST = 125;
parameter BEV2_COST = 220;
parameter BEV3_COST = 175;
parameter BEV4_COST = 310;

input inbev1, inbev2, inbev3, inbev4, rst, clk;
input [9:0] moneyin;
output reg outbev1, outbev2, outbev3, outbev4;
output reg [9:0] moneyout;

reg start;


always @(posedge clk) begin
	if(rst == 1) begin
		outbev1 <= 0;
		outbev2 <= 0;
		outbev3 <= 0;
		outbev4 <= 0;
		moneyout <= 10'd0;
		start <=0;
	end else begin
	if(inbev1 == 1&& moneyin >= BEV1_COST) begin
		moneyout <= moneyin - BEV1_COST;
		outbev1 <= 1;
		outbev2 <= 0;
		outbev3 <= 0;
		outbev4 <= 0;
		start <=1;
		end else if (inbev2 == 1&& moneyin >= BEV2_COST) begin
		moneyout <= moneyin - BEV2_COST;
		outbev1 <= 0;
		outbev2 <= 1;
		outbev3 <= 0;
		outbev4 <= 0;

		start <=1;
		end else if (inbev3 == 1&& moneyin >= BEV3_COST) begin
		moneyout <= moneyin - BEV3_COST;
		outbev1 <= 0;
		outbev2 <= 0;
		outbev3 <= 1;
		outbev4 <= 0;
		
		start <=1;
		end else if (inbev4 == 1&& moneyin >= BEV4_COST) begin
		moneyout <= moneyin - BEV4_COST;
		outbev1 <= 0;
		outbev2 <= 0;
		outbev3 <= 0;
		outbev4 <= 1;
		
		start <=1;
	end
	if(start ==1) begin
		start <=0;
		outbev1 <=0;
		outbev2 <=0;
		outbev3 <=0;
		outbev4 <=0;
		
	end
end
end

endmodule
