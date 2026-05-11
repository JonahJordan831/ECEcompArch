`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module ALU_FU(
    input  wire [31:0] busA,
    input  wire [31:0] busB,
    input  wire [4:0]  opcode,
    output reg  [31:0] result,
    output reg         Z,
    output reg         N,
    output reg         C,
    output reg         V
);

    reg [32:0] temp;

    always @(*) begin
        result = 32'b0;
        Z      = 1'b0;
        N      = 1'b0;
        C      = 1'b0;
        V      = 1'b0;
        temp   = 33'b0;

        case (opcode)

            5'h03: begin // ADD
                temp   = {1'b0, busA} + {1'b0, busB};
                result = temp[31:0];
                C      = temp[32];
                V      = (busA[31] == busB[31]) && (result[31] != busA[31]);
            end

            5'h04: begin // SUB
                temp   = {1'b0, busA} + {1'b0, ~busB} + 33'd1;
                result = temp[31:0];
                C      = temp[32];
                V      = (busA[31] != busB[31]) && (result[31] != busA[31]);
            end

            5'h05: begin // AND
                result = busA & busB;
            end

            5'h06: begin // OR
                result = busA | busB;
            end

            5'h07: begin // XOR
                result = busA ^ busB;
            end

            5'h08: begin // NOT
                result = ~busA;
            end

            5'h09: begin // SL
                result = busA << busB[4:0];

                case (busB[4:0])
                    5'd0:  C = 1'b0;
                    5'd1:  C = busA[31];
                    5'd2:  C = busA[30];
                    5'd3:  C = busA[29];
                    5'd4:  C = busA[28];
                    5'd5:  C = busA[27];
                    5'd6:  C = busA[26];
                    5'd7:  C = busA[25];
                    5'd8:  C = busA[24];
                    5'd9:  C = busA[23];
                    5'd10: C = busA[22];
                    5'd11: C = busA[21];
                    5'd12: C = busA[20];
                    5'd13: C = busA[19];
                    5'd14: C = busA[18];
                    5'd15: C = busA[17];
                    5'd16: C = busA[16];
                    5'd17: C = busA[15];
                    5'd18: C = busA[14];
                    5'd19: C = busA[13];
                    5'd20: C = busA[12];
                    5'd21: C = busA[11];
                    5'd22: C = busA[10];
                    5'd23: C = busA[9];
                    5'd24: C = busA[8];
                    5'd25: C = busA[7];
                    5'd26: C = busA[6];
                    5'd27: C = busA[5];
                    5'd28: C = busA[4];
                    5'd29: C = busA[3];
                    5'd30: C = busA[2];
                    5'd31: C = busA[1];
                endcase
            end

            5'h0A: begin // SR
                result = busA >> busB[4:0];
            end

            default: begin
                result = 32'b0;
            end

        endcase

        Z = (result == 32'b0);
        N = result[31];
    end

endmodule