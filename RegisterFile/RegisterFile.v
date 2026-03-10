`timescale 1ns / 1ps
/*

Name: Jonah Jordan 
R-Number: R-11886590 
Assignment: Project 2

*/
module RegisterFile(

input wire clk,
input wire RL,  //   register load (write adress)

	input  wire [4:0]  DA,          // Bus D address  (write address)
   input  wire [31:0] BusD,        // Bus D data     (write data)
   input  wire [4:0]  AA,          // Bus A address  (read address)
   input  wire [4:0]  BA,          // Bus B address  (read address)
   output wire [31:0] BusA,        // Bus A data out
	output wire [31:0] BusB         // Bus B data out




    );
	 
	 reg [31:0] regfile [0:31];

    always @(posedge clk) begin
        if (RL)
            regfile[DA] <= BusD;
    end
	 
	 assign BusA = regfile[AA];
    assign BusB = regfile[BA];


endmodule
