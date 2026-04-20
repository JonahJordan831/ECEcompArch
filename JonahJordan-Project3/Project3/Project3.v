`timescale 1ns / 1ps
/* 
Name: Jonah Jordan 
R-Number: R-11886590 
Assignment: Project 3 
*/

module ALU_FU (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] busA,
    input  wire [31:0] busB,
    input  wire [4:0]  opcode,
    output reg  [31:0] result,
    output reg         Z,
    output reg         N,
    output reg         C,
    output reg         V
);

    // Next-flag registers (combinational)
    reg next_Z, next_N, next_C, next_V;

    // -----------------------------------------------------------------------
    // Combinational block: compute result and next flag values
    // -----------------------------------------------------------------------
    always @(*) begin
        // Default: hold current flag values, zero result  ---- Looking back i wish i just did a posedge but this worked fine
        result = 32'b0;
        next_Z = Z;
        next_N = N;
        next_C = C;
        next_V = V;

        case (opcode)

            5'h01: begin // LD - pass through busA, no flags affected
                result = busA;
            end

            5'h03: begin // ADD
                {next_C, result} = {1'b0, busA} + {1'b0, busB};
                next_Z = (result == 32'b0);
                next_N = result[31];
                next_V = (busA[31] == busB[31]) && (result[31] != busA[31]);
            end

            5'h04: begin // SUB
                {next_C, result} = {1'b0, busA} + {1'b0, ~busB} + 33'd1;
                next_Z = (result == 32'b0);
                next_N = result[31];
                next_V = (busA[31] != busB[31]) && (result[31] != busA[31]);
            end

            5'h05: begin // AND - Z only
                result = busA & busB;
                next_Z = (result == 32'b0);
            end

            5'h06: begin // OR - Z only
                result = busA | busB;
                next_Z = (result == 32'b0);
            end

            5'h07: begin // XOR - Z only
                result = busA ^ busB;
                next_Z = (result == 32'b0);
            end

            5'h08: begin // NOT - Z only
                result = ~busA;
                next_Z = (result == 32'b0);
            end

            5'h09: begin // SL - Z and C only
                result = busA << busB[4:0];
                next_Z = (result == 32'b0);
                next_C = (busB[4:0] == 5'd0) ? 1'b0 : busA[32 - busB[4:0]];
            end

            5'h0A: begin // SR - Z only
                result = busA >> busB[4:0];
                next_Z = (result == 32'b0);
            end

            default: begin
                result = 32'b0;
            end

        endcase
    end

    // -----------------------------------------------------------------------
    // Flag registers: update on rising clock edge
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            Z <= 1'b0;
            N <= 1'b0;
            C <= 1'b0;
            V <= 1'b0;
        end else begin
            Z <= next_Z;
            N <= next_N;
            C <= next_C;
            V <= next_V;
        end
    end

endmodule