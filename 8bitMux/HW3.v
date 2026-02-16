`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Jonah Jordan, R11886590
//////////////////////////////////////////////////////////////////////////////////
module HW3(A, B, C, D, sel, X);

input [7:0] A, B,C, D;
input [1:0] sel;   //two bits for select, inputs and outputs need to  be 8

output reg [7:0] X;

always @(A,B,C,D,sel) begin case (sel)

	2'b00: X = A;
	2'b01: X = B;  // stating whatever number "select" is at is what output x shows
	2'b10: X = C;
	2'b11: X =D;
	
	default X = 8'd0; //making everything be 0 by default


	endcase

end
endmodule
