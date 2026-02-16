`timescale 1ns / 1ps

module NAND(A, B, X );

input A;
input B;

output X;




assign X = ~(A & B);
endmodule
