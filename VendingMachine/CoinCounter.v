`timescale 1ns / 1ps
module CoinCounter(inQuarter, inDime, inNickel, outCount, resetCount, clk, rst);
parameter QUARTER_VALUE = 25;
parameter DIME_VALUE = 10;
parameter NICKEL_VALUE = 5;
input inQuarter, inDime, inNickel, resetCount, clk, rst;
output reg [9:0] outCount;
wire inMoney;
assign inMoney = inQuarter | inDime | inNickel | resetCount;
always @(posedge clk) begin
    if(rst) begin
        outCount <= 0;
    end else if(resetCount == 1) begin
        outCount <= 0;
    end else if(inMoney) begin
        outCount <= outCount + (inQuarter*QUARTER_VALUE + inDime*DIME_VALUE + inNickel*NICKEL_VALUE);
		  end
end
endmodule