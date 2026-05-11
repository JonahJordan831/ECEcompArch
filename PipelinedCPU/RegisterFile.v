`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module RegisterFile(
    input  wire        clk,
    input  wire        reset,
    input  wire        RL,
    input  wire [4:0]  DA,
    input  wire [31:0] BusD,
    input  wire [4:0]  AA,
    input  wire [4:0]  BA,
    output wire [31:0] BusA,
    output wire [31:0] BusB
);

    reg [31:0] regfile [0:31];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'b0;
        end else begin
            if (RL)
                regfile[DA] <= BusD;
        end
    end

    assign BusA = regfile[AA];
    assign BusB = regfile[BA];

endmodule