`timescale 1ns / 1ps

module RAM(dataIN, dataOUT, WR, RD, addr);

	input [3:0] dataIN;
	input WR;
	input RD;
	input [3:0] addr;
	
	output reg [3:0] dataOUT;
	
	reg [3:0] dataSTORE[15:0];
	
	always @(posedge WR) begin
	
	dataSTORE[addr] <= dataIN;
	end
	
	always @(posedge RD) begin
	
	dataOUT <= dataSTORE[addr];
	end
	

endmodule
