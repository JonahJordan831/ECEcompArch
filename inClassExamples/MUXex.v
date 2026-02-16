`timescale 1ns / 1ps

module MUXex(sel, A, B, C, D,Y );

	input [1:0] sel;
	input [3:0] A, B, C,D;
	
	output reg [3:0] Y;
	
	always @(sel, A, B, C, D) begin
		case(sel)
		2'd0:
			Y <= A;
		2'd1:
			Y <= B;
		2'd2:
			Y <= C;
		2'd3:
			Y <= D;
		endcase
	
	end

endmodule
