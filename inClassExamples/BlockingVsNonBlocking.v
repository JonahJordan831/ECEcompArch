`timescale 1ns / 1ps

module BlockingVsNonBlocking(A, B, Y, go);

	input [3:0] A, B;
	input go;
	output reg [7:0] Y;
	
	always @(posedge go) begin
	
	Y<=A;
	Y<= Y+B;
	end

endmodule
