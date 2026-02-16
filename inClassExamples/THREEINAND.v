`timescale 1ns / 1ps

module THREEINAND(A, B, C, Y);

input A, B, C;
output Y;

wire Yout;

TWOINAND AND1 (.A(A), .B(B), .Y(Yout);
TWOINAND AND2 (.A(Yout), .B(C), .Y(Y);

endmodule
