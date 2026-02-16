`timescale 1ns / 1ps

module TOP(A,B,C,Q);

input A, B, C;

wire X, Y;

output Q;

NAND jonah(

.A(A), .B(B), .X(X)
);

NOR jonah2 (

.A(A), .B(B), .Y(Y)
);

AND jonah3 (

.X(X), .Y(Y), .C(C), .Q(Q)
);




endmodule
