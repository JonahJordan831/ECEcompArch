`timescale 1ns / 1ps

module CoinDispenser(change, outquarter, outdime, outnickel, rst, clk);
input clk, rst;
input [9:0] change;
output reg outquarter, outdime, outnickel;
reg [9:0] remaining;
reg [9:0] prev_change;


always @(posedge clk) begin
    if(rst) begin
        outquarter  <= 0;
        outdime     <= 0;
        outnickel   <= 0;
        remaining   <= 0;
        prev_change <= 0;
    end else begin
        outquarter <= 0;
        outdime    <= 0;
        outnickel  <= 0;
        prev_change <= change;
		  
		if(prev_change == 0 && change > 0) begin
            remaining <= change;
        end else if(remaining >= 25) begin
            outquarter <= 1;
            remaining  <= remaining - 25;
        end else if(remaining >= 10) begin
            outdime    <= 1;
            remaining  <= remaining - 10;
        end else if(remaining >= 5) begin
            outnickel  <= 1;
            remaining  <= remaining - 5;
        end
    end
end

endmodule
