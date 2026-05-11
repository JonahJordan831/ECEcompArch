`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module HazardUnit(
    input  wire        if_id_valid,

    input  wire        id_ex_valid,
    input  wire        id_ex_mem_read,
    input  wire        id_ex_reg_write,
    input  wire [4:0]  id_ex_dst,

    input  wire        ex_mem_valid,
    input  wire        mem_wb_valid,

    input  wire        dec_is_branch,

    input  wire        dec_uses_src,
    input  wire [4:0]  dec_src,

    input  wire        dec_uses_lit_reg,
    input  wire [4:0]  dec_lit_reg,

    output wire        load_use_stall,
    output wire        branch_flag_stall,
    output wire        pipeline_stall
);

    /*
        Load-use hazard example:

            ld  r18, $200
            add r19, r18, #1

        The loaded RAM value is not ready immediately so the CPU must
        insert a bubble and then perform a small fetch recovery because
        the real ROM IP is synchronous.
    */
    assign load_use_stall =
        if_id_valid &&
        id_ex_valid &&
        id_ex_mem_read &&
        id_ex_reg_write &&
        (
            (dec_uses_src     && (id_ex_dst == dec_src)) ||
            (dec_uses_lit_reg && (id_ex_dst == dec_lit_reg))
        );

    /*
        Very conservative branch hazard handling

        If a branch is in decode, wait until older instructions have
        drained out of ID/EX, EX/MEM, and MEM/WB before resolving it.
        This guarantees flag_Z is stable.
    */
    assign branch_flag_stall =
        if_id_valid &&
        dec_is_branch &&
        (
            id_ex_valid ||
            ex_mem_valid ||
            mem_wb_valid
        );

    assign pipeline_stall = load_use_stall || branch_flag_stall;

endmodule