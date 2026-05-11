`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/

module FinalProjectTop(
    input  wire clk,
    input  wire reset,

    output wire [5:0] debug_pc,
    output wire       debug_Z,
    output wire       debug_N,
    output wire       debug_C,
    output wire       debug_V
);

    wire [5:0]  rom_addr;
    wire [48:0] rom_data;

    wire [9:0]  ram_addr;
    wire [31:0] ram_din;
    wire [31:0] ram_dout;
    wire        ram_we;

    CPU cpu0(
        .clk(clk),
        .reset(reset),

        .rom_addr(rom_addr),
        .rom_data(rom_data),

        .ram_addr(ram_addr),
        .ram_din(ram_din),
        .ram_dout(ram_dout),
        .ram_we(ram_we),

        .debug_pc(debug_pc),
        .debug_Z(debug_Z),
        .debug_N(debug_N),
        .debug_C(debug_C),
        .debug_V(debug_V)
    );

    // Real ROM IP core
    // 
    ROM rom0(
        .clka(clk),
        .ena(1'b1),
        .addra(rom_addr),
        .douta(rom_data)
    );

    // Real RAM IP core
    // 
    RAM ram0(
        .clka(clk),
        .ena(1'b1),
        .wea({ram_we}),
        .addra(ram_addr[9:2]),
        .dina(ram_din),
        .douta(ram_dout)
    );

endmodule