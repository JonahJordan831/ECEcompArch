`timescale 1ns / 1ps

module NOR( A, B, Y);

input A;
input B;

output Y;


assign Y = ~(A | B);

endmodule
