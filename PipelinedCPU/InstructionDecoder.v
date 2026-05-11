`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module InstructionDecoder(
    input  wire [48:0] instr,

    output wire [4:0]  opcode,
    output wire [1:0]  mode,
    output wire [4:0]  src,
    output wire [4:0]  dst,
    output wire [31:0] lit,

    output wire        uses_src,
    output wire        uses_lit_reg,
    output wire        reg_write,
    output wire        mem_read,
    output wire        mem_write,
    output wire        is_alu,
    output wire        is_branch
);

    localparam OP_LD  = 5'h01;
    localparam OP_ST  = 5'h02;
    localparam OP_ADD = 5'h03;
    localparam OP_SUB = 5'h04;
    localparam OP_AND = 5'h05;
    localparam OP_OR  = 5'h06;
    localparam OP_XOR = 5'h07;
    localparam OP_NOT = 5'h08;
    localparam OP_SL  = 5'h09;
    localparam OP_SR  = 5'h0A;
    localparam OP_BZ  = 5'h10;
    localparam OP_BNZ = 5'h11;
    localparam OP_BRA = 5'h12;

    localparam MODE_IMM = 2'b00;
    localparam MODE_ADR = 2'b01;
    localparam MODE_REG = 2'b10;

    assign opcode = instr[48:44];
    assign mode   = instr[43:42];
    assign src    = instr[41:37];
    assign dst    = instr[36:32];
    assign lit    = instr[31:0];

    assign is_alu = (opcode == OP_ADD) ||
                    (opcode == OP_SUB) ||
                    (opcode == OP_AND) ||
                    (opcode == OP_OR ) ||
                    (opcode == OP_XOR) ||
                    (opcode == OP_NOT) ||
                    (opcode == OP_SL ) ||
                    (opcode == OP_SR );

    assign is_branch = (opcode == OP_BZ) ||
                       (opcode == OP_BNZ) ||
                       (opcode == OP_BRA);

    assign mem_read  = (opcode == OP_LD) && (mode == MODE_ADR);
    assign mem_write = (opcode == OP_ST) && (mode == MODE_ADR);

    assign reg_write = (opcode == OP_LD) || is_alu;

    assign uses_src = (opcode == OP_ST) || is_alu;

    assign uses_lit_reg = is_alu &&
                          (mode == MODE_REG) &&
                          (opcode != OP_NOT);

endmodule