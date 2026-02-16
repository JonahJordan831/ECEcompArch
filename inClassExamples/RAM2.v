`timescale 1ns / 1ps

module RAM2(dataIN, dataOUT, WR, addr, rst, clk);

	input [3:0] dataIN;
	input WR, rst, clk;
	input [3:0] addr;
	
	output [3:0] dataOUT;
	reg [3:0] dataSTORE[15:0];
	
	assign dataOUT = dataSTORE[addr];
	
	integer index;
	
	always @(posedge clk) begin
	if(rst==1)begin
		for(index=0;index<8;index=index+1) begin
		dataSTORE[index] <= 0;
		end
	end else begin
		if(WR ==1) begin
			dataSTORE[addr] <= dataIN;
			end
	end
	
	end

endmodule
