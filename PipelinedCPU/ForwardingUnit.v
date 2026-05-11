`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module ForwardingUnit(
    input  wire        id_ex_uses_src,
    input  wire        id_ex_uses_lit_reg,
    input  wire [4:0]  id_ex_src,
    input  wire [4:0]  id_ex_lit_reg,

    input  wire        ex_mem_valid,
    input  wire        ex_mem_reg_write,
    input  wire        ex_mem_mem_read,
    input  wire [4:0]  ex_mem_dst,

    input  wire        mem_wb_valid,
    input  wire        mem_wb_reg_write,
    input  wire [4:0]  mem_wb_dst,

    output reg  [1:0]  forwardA,
    output reg  [1:0]  forwardB
);

    /*
        Forwarding select values:

            00 = normal ID/EX value
            01 = forward from MEM/WB
            10 = forward from EX/MEM

        Important:
        Do not forward from EX/MEM if EX/MEM is a memory read.
        Load data is not ready until the MEM/WB stage.
    */

    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (id_ex_uses_src) begin
            if (ex_mem_valid &&
                ex_mem_reg_write &&
                !ex_mem_mem_read &&
                (ex_mem_dst == id_ex_src)) begin
                forwardA = 2'b10;
            end else if (mem_wb_valid &&
                         mem_wb_reg_write &&
                         (mem_wb_dst == id_ex_src)) begin
                forwardA = 2'b01;
            end
        end

        if (id_ex_uses_lit_reg) begin
            if (ex_mem_valid &&
                ex_mem_reg_write &&
                !ex_mem_mem_read &&
                (ex_mem_dst == id_ex_lit_reg)) begin
                forwardB = 2'b10;
            end else if (mem_wb_valid &&
                         mem_wb_reg_write &&
                         (mem_wb_dst == id_ex_lit_reg)) begin
                forwardB = 2'b01;
            end
        end
    end

endmodule