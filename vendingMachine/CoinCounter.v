`timescale 1ns / 1ps

module CoinCounter(inQuarter, inDime, inNickel, outCount, resetCount,);

parameter QUARTER_VALUE = 25;
parameter DIME_VALUE = 10;
parameter NICKEL_VALUE = 5;


input inQuarter, inDime, inNickel, resetCount;
output reg [9:0] outCount;
wire inMoney;
reg [9:0] moneyCounter;

assign inMoney = inQuarter | inDime | inNickel | resetCount;


always @(inMoney) begin

	if(resetCount == 1) begin
	outCount <=0;
	end else begin
	outCount <= outCount + (inQuarter*QUARTER_VALUE + inDime*DIME_VALUE + inNickel*NICKEL_VALUE);
	end

end



endmodule
