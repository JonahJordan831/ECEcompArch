`timescale 1ns / 1ps

module MUX(sel,A, B,Y);

input sel, A, B;
output Y;

assign Y= sel ? B:A;
/*
if (sel ==1) {
Y=B;
} else { 
Y=A;}
*/
endmodule
