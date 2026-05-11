`timescale 1ns / 1ps
/*
Name: Jonah Jordan
R-Number: R-11886590
Assignment: Final Project
*/


// module is a little longer than i expected, i had to keep adding things for the hazards
module CPU(
    input  wire        clk,
    input  wire        reset,

    output wire [5:0]  rom_addr,
    input  wire [48:0] rom_data,

    output wire [9:0]  ram_addr,
    output wire [31:0] ram_din,
    input  wire [31:0] ram_dout,
    output wire        ram_we,

    output wire [5:0]  debug_pc,
    output wire        debug_Z,
    output wire        debug_N,
    output wire        debug_C,
    output wire        debug_V
);

    localparam OP_NOP = 5'h00;
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

    reg [5:0] pc;
    reg [2:0] branch_flush_count;

    // Load-use recovery state for synchronous ROM realignment
    reg [1:0] load_recover_count;
    reg [5:0] load_recover_pc;

    assign rom_addr = pc;
    assign debug_pc = pc;

    // ============================================================
    // IF/ID pipeline register
    // ============================================================

    reg        if_id_valid;
    reg [5:0]  if_id_pc;
    reg [48:0] if_id_instr;

    // ============================================================
    // Instruction decoder
    // ============================================================

    wire [4:0]  dec_opcode;
    wire [1:0]  dec_mode;
    wire [4:0]  dec_src;
    wire [4:0]  dec_dst;
    wire [31:0] dec_lit;
    wire        dec_uses_src;
    wire        dec_uses_lit_reg;
    wire        dec_reg_write;
    wire        dec_mem_read;
    wire        dec_mem_write;
    wire        dec_is_alu;
    wire        dec_is_branch;

    InstructionDecoder decoder(
        .instr(if_id_instr),

        .opcode(dec_opcode),
        .mode(dec_mode),
        .src(dec_src),
        .dst(dec_dst),
        .lit(dec_lit),

        .uses_src(dec_uses_src),
        .uses_lit_reg(dec_uses_lit_reg),
        .reg_write(dec_reg_write),
        .mem_read(dec_mem_read),
        .mem_write(dec_mem_write),
        .is_alu(dec_is_alu),
        .is_branch(dec_is_branch)
    );

    // ============================================================
    // MEM/WB pipeline register
    // ============================================================

    reg        mem_wb_valid;
    reg        mem_wb_reg_write;
    reg [4:0]  mem_wb_dst;
    reg [31:0] mem_wb_result;

    // ============================================================
    // Register file
    // ============================================================

    wire [31:0] rf_busA;
    wire [31:0] rf_busB;

    RegisterFile rf(
        .clk(clk),
        .reset(reset),

        .RL(mem_wb_valid && mem_wb_reg_write),
        .DA(mem_wb_dst),
        .BusD(mem_wb_result),

        .AA(dec_src),
        .BA(dec_lit[4:0]),

        .BusA(rf_busA),
        .BusB(rf_busB)
    );

    // Same-cycle writeback/read bypass
    wire [31:0] id_readA_value;
    wire [31:0] id_readB_value;

    assign id_readA_value =
        (mem_wb_valid && mem_wb_reg_write && (mem_wb_dst == dec_src)) ?
        mem_wb_result : rf_busA;

    assign id_readB_value =
        (mem_wb_valid && mem_wb_reg_write && (mem_wb_dst == dec_lit[4:0])) ?
        mem_wb_result : rf_busB;

    // ============================================================
    // ID/EX pipeline register
    // ============================================================

    reg        id_ex_valid;
    reg [5:0]  id_ex_pc;
    reg [4:0]  id_ex_opcode;
    reg [1:0]  id_ex_mode;
    reg [4:0]  id_ex_src;
    reg [4:0]  id_ex_dst;
    reg [31:0] id_ex_lit;
    reg [31:0] id_ex_busA;
    reg [31:0] id_ex_busB;
    reg        id_ex_reg_write;
    reg        id_ex_mem_read;
    reg        id_ex_mem_write;
    reg        id_ex_is_alu;
    reg        id_ex_is_branch;
    reg        id_ex_uses_src;
    reg        id_ex_uses_lit_reg;

    // ============================================================
    // EX/MEM pipeline register
    // ============================================================

    reg        ex_mem_valid;
    reg [4:0]  ex_mem_opcode;
    reg [4:0]  ex_mem_dst;
    reg        ex_mem_reg_write;
    reg        ex_mem_mem_read;
    reg        ex_mem_mem_write;
    reg [31:0] ex_mem_result;
    reg [9:0]  ex_mem_ram_addr;
    reg [31:0] ex_mem_store_data;

    // ============================================================
    // Hazard detection unit
    // ============================================================

    wire load_use_stall;
    wire branch_flag_stall;
    wire pipeline_stall;

    HazardUnit hazard0(
        .if_id_valid(if_id_valid),

        .id_ex_valid(id_ex_valid),
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_reg_write(id_ex_reg_write),
        .id_ex_dst(id_ex_dst),

        .ex_mem_valid(ex_mem_valid),
        .mem_wb_valid(mem_wb_valid),

        .dec_is_branch(dec_is_branch),

        .dec_uses_src(dec_uses_src),
        .dec_src(dec_src),

        .dec_uses_lit_reg(dec_uses_lit_reg),
        .dec_lit_reg(dec_lit[4:0]),

        .load_use_stall(load_use_stall),
        .branch_flag_stall(branch_flag_stall),
        .pipeline_stall(pipeline_stall)
    );

    // ============================================================
    // Forwarding unit
    // ============================================================

    wire [1:0] forwardA;
    wire [1:0] forwardB;

    ForwardingUnit forwarding0(
        .id_ex_uses_src(id_ex_uses_src),
        .id_ex_uses_lit_reg(id_ex_uses_lit_reg),

        .id_ex_src(id_ex_src),
        .id_ex_lit_reg(id_ex_lit[4:0]),

        .ex_mem_valid(ex_mem_valid),
        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_mem_read(ex_mem_mem_read),
        .ex_mem_dst(ex_mem_dst),

        .mem_wb_valid(mem_wb_valid),
        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_dst(mem_wb_dst),

        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // ============================================================
    // Forwarded EX-stage values
    // ============================================================

    reg [31:0] ex_src_value;
    reg [31:0] ex_lit_reg_value;

    always @(*) begin
        case (forwardA)
            2'b10:   ex_src_value = ex_mem_result;
            2'b01:   ex_src_value = mem_wb_result;
            default: ex_src_value = id_ex_busA;
        endcase

        case (forwardB)
            2'b10:   ex_lit_reg_value = ex_mem_result;
            2'b01:   ex_lit_reg_value = mem_wb_result;
            default: ex_lit_reg_value = id_ex_busB;
        endcase
    end

    // ============================================================
    // RAM interface
    // ============================================================

    assign ram_addr = (id_ex_valid && (id_ex_mem_read || id_ex_mem_write)) ?
                      id_ex_lit[9:0] : 10'd0;

    assign ram_din = ex_src_value;
    assign ram_we  = id_ex_valid && id_ex_mem_write;

    // ============================================================
    // ALU
    // ============================================================

    wire [31:0] alu_busA;
    wire [31:0] alu_busB;

    assign alu_busA = ex_src_value;
    assign alu_busB = (id_ex_mode == MODE_REG) ? ex_lit_reg_value : id_ex_lit;

    wire [31:0] alu_result;
    wire alu_Z;
    wire alu_N;
    wire alu_C;
    wire alu_V;

    ALU_FU alu(
        .busA(alu_busA),
        .busB(alu_busB),
        .opcode(id_ex_opcode),

        .result(alu_result),
        .Z(alu_Z),
        .N(alu_N),
        .C(alu_C),
        .V(alu_V)
    );

    // ============================================================
    // CPU flags
    // ============================================================

    reg flag_Z;
    reg flag_N;
    reg flag_C;
    reg flag_V;

    assign debug_Z = flag_Z;
    assign debug_N = flag_N;
    assign debug_C = flag_C;
    assign debug_V = flag_V;

    // ============================================================
    // Branch logic
    // ============================================================

    wire dec_branch_taken;

    assign dec_branch_taken =
        if_id_valid &&
        dec_is_branch &&
        (
            (dec_opcode == OP_BRA) ||
            ((dec_opcode == OP_BZ ) &&  flag_Z) ||
            ((dec_opcode == OP_BNZ) && !flag_Z)
        );

    wire branch_taken;
    wire [5:0] branch_target;

    assign branch_taken =
        dec_branch_taken &&
        !pipeline_stall &&
        (branch_flush_count == 3'd0) &&
        (load_recover_count == 2'd0);

    assign branch_target = dec_lit[5:0];

    // ============================================================
    // EX result mux
    // ============================================================

    reg [31:0] ex_result_selected;

    always @(*) begin
        ex_result_selected = 32'b0;

        case (id_ex_opcode)

            OP_LD: begin
                if (id_ex_mode == MODE_IMM)
                    ex_result_selected = id_ex_lit;
                else
                    ex_result_selected = 32'b0;
            end

            OP_ADD,
            OP_SUB,
            OP_AND,
            OP_OR,
            OP_XOR,
            OP_NOT,
            OP_SL,
            OP_SR: begin
                ex_result_selected = alu_result;
            end

            default: begin
                ex_result_selected = 32'b0;
            end

        endcase
    end

    // ============================================================
    // Helper tasks
    // ============================================================

    task clear_id_ex;
    begin
        id_ex_valid        <= 1'b0;
        id_ex_pc           <= 6'd0;
        id_ex_opcode       <= OP_NOP;
        id_ex_mode         <= MODE_IMM;
        id_ex_src          <= 5'd0;
        id_ex_dst          <= 5'd0;
        id_ex_lit          <= 32'd0;
        id_ex_busA         <= 32'd0;
        id_ex_busB         <= 32'd0;
        id_ex_reg_write    <= 1'b0;
        id_ex_mem_read     <= 1'b0;
        id_ex_mem_write    <= 1'b0;
        id_ex_is_alu       <= 1'b0;
        id_ex_is_branch    <= 1'b0;
        id_ex_uses_src     <= 1'b0;
        id_ex_uses_lit_reg <= 1'b0;
    end
    endtask

    task clear_if_id;
    begin
        if_id_valid <= 1'b0;
        if_id_pc    <= 6'd0;
        if_id_instr <= 49'b0;
    end
    endtask

    // ============================================================
    // Main pipeline always block
    // ============================================================

    always @(posedge clk) begin
        if (reset) begin
            pc                 <= 6'd0;
            branch_flush_count <= 3'd0;
            load_recover_count <= 2'd0;
            load_recover_pc    <= 6'd0;

            if_id_valid <= 1'b0;
            if_id_pc    <= 6'd0;
            if_id_instr <= 49'b0;

            id_ex_valid        <= 1'b0;
            id_ex_pc           <= 6'd0;
            id_ex_opcode       <= OP_NOP;
            id_ex_mode         <= MODE_IMM;
            id_ex_src          <= 5'd0;
            id_ex_dst          <= 5'd0;
            id_ex_lit          <= 32'd0;
            id_ex_busA         <= 32'd0;
            id_ex_busB         <= 32'd0;
            id_ex_reg_write    <= 1'b0;
            id_ex_mem_read     <= 1'b0;
            id_ex_mem_write    <= 1'b0;
            id_ex_is_alu       <= 1'b0;
            id_ex_is_branch    <= 1'b0;
            id_ex_uses_src     <= 1'b0;
            id_ex_uses_lit_reg <= 1'b0;

            ex_mem_valid      <= 1'b0;
            ex_mem_opcode     <= OP_NOP;
            ex_mem_dst        <= 5'd0;
            ex_mem_reg_write  <= 1'b0;
            ex_mem_mem_read   <= 1'b0;
            ex_mem_mem_write  <= 1'b0;
            ex_mem_result     <= 32'd0;
            ex_mem_ram_addr   <= 10'd0;
            ex_mem_store_data <= 32'd0;

            mem_wb_valid     <= 1'b0;
            mem_wb_reg_write <= 1'b0;
            mem_wb_dst       <= 5'd0;
            mem_wb_result    <= 32'd0;

            flag_Z <= 1'b0;
            flag_N <= 1'b0;
            flag_C <= 1'b0;
            flag_V <= 1'b0;
        end else begin

            // ====================================================
            // CASE 1: taken branch
            // ====================================================
            if (branch_taken) begin
                pc                 <= branch_target;
                branch_flush_count <= 3'd4;
                load_recover_count <= 2'd0;
                load_recover_pc    <= 6'd0;

                clear_if_id();
                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= 1'b0;
                ex_mem_opcode     <= OP_NOP;
                ex_mem_dst        <= 5'd0;
                ex_mem_reg_write  <= 1'b0;
                ex_mem_mem_read   <= 1'b0;
                ex_mem_mem_write  <= 1'b0;
                ex_mem_result     <= 32'd0;
                ex_mem_ram_addr   <= 10'd0;
                ex_mem_store_data <= 32'd0;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end

            // ====================================================
            // CASE 2: branch flush delay for synchronous ROM
            // ====================================================
            else if (branch_flush_count != 3'd0) begin
                pc                 <= pc;
                branch_flush_count <= branch_flush_count - 3'd1;
                load_recover_count <= 2'd0;
                load_recover_pc    <= 6'd0;

                clear_if_id();
                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= 1'b0;
                ex_mem_opcode     <= OP_NOP;
                ex_mem_dst        <= 5'd0;
                ex_mem_reg_write  <= 1'b0;
                ex_mem_mem_read   <= 1'b0;
                ex_mem_mem_write  <= 1'b0;
                ex_mem_result     <= 32'd0;
                ex_mem_ram_addr   <= 10'd0;
                ex_mem_store_data <= 32'd0;
            end

            // ====================================================
            // CASE 2B: load-use recovery stage 3
            // Execute held IF/ID instruction, then request saved next PC.
            // ====================================================
            else if (load_recover_count == 2'd3) begin
                pc                 <= load_recover_pc;
                branch_flush_count <= 3'd0;
                load_recover_count <= 2'd2;

                id_ex_valid        <= if_id_valid;
                id_ex_pc           <= if_id_pc;
                id_ex_opcode       <= dec_opcode;
                id_ex_mode         <= dec_mode;
                id_ex_src          <= dec_src;
                id_ex_dst          <= dec_dst;
                id_ex_lit          <= dec_lit;
                id_ex_busA         <= id_readA_value;
                id_ex_busB         <= id_readB_value;
                id_ex_reg_write    <= dec_reg_write;
                id_ex_mem_read     <= dec_mem_read;
                id_ex_mem_write    <= dec_mem_write;
                id_ex_is_alu       <= dec_is_alu;
                id_ex_is_branch    <= dec_is_branch;
                id_ex_uses_src     <= dec_uses_src;
                id_ex_uses_lit_reg <= dec_uses_lit_reg;

                clear_if_id();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= id_ex_valid;
                ex_mem_opcode     <= id_ex_opcode;
                ex_mem_dst        <= id_ex_dst;
                ex_mem_reg_write  <= id_ex_valid && id_ex_reg_write;
                ex_mem_mem_read   <= id_ex_valid && id_ex_mem_read;
                ex_mem_mem_write  <= id_ex_valid && id_ex_mem_write;
                ex_mem_result     <= ex_result_selected;
                ex_mem_ram_addr   <= id_ex_lit[9:0];
                ex_mem_store_data <= ex_src_value;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end

            // ====================================================
            // CASE 2C: load-use recovery stage 2
            // Hold saved next PC so synchronous ROM can output it.
            // ====================================================
            else if (load_recover_count == 2'd2) begin
                pc                 <= load_recover_pc;
                branch_flush_count <= 3'd0;
                load_recover_count <= 2'd1;

                clear_if_id();
                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= id_ex_valid;
                ex_mem_opcode     <= id_ex_opcode;
                ex_mem_dst        <= id_ex_dst;
                ex_mem_reg_write  <= id_ex_valid && id_ex_reg_write;
                ex_mem_mem_read   <= id_ex_valid && id_ex_mem_read;
                ex_mem_mem_write  <= id_ex_valid && id_ex_mem_write;
                ex_mem_result     <= ex_result_selected;
                ex_mem_ram_addr   <= id_ex_lit[9:0];
                ex_mem_store_data <= ex_src_value;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end

            // ====================================================
            // CASE 2D: load-use recovery stage 1
            // Capture re-fetched instruction into IF/ID.
            // ====================================================
            else if (load_recover_count == 2'd1) begin
                pc                 <= load_recover_pc + 6'd1;
                branch_flush_count <= 3'd0;
                load_recover_count <= 2'd0;

                if_id_valid <= 1'b1;
                if_id_pc    <= load_recover_pc;
                if_id_instr <= rom_data;

                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= id_ex_valid;
                ex_mem_opcode     <= id_ex_opcode;
                ex_mem_dst        <= id_ex_dst;
                ex_mem_reg_write  <= id_ex_valid && id_ex_reg_write;
                ex_mem_mem_read   <= id_ex_valid && id_ex_mem_read;
                ex_mem_mem_write  <= id_ex_valid && id_ex_mem_write;
                ex_mem_result     <= ex_result_selected;
                ex_mem_ram_addr   <= id_ex_lit[9:0];
                ex_mem_store_data <= ex_src_value;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end

            // ====================================================
            // CASE 3: pipeline stall
            // ====================================================
            else if (pipeline_stall) begin
                pc                 <= pc;
                branch_flush_count <= 3'd0;

                if (load_use_stall) begin
                    load_recover_count <= 2'd3;

                    // id_ex_pc is lining up one ahead in this real ROM pipeline.
                    // This recovers the skipped instruction correctly.
                    load_recover_pc <= id_ex_pc + 6'd1;
                end else begin
                    load_recover_count <= 2'd0;
                    load_recover_pc    <= 6'd0;
                end

                if_id_valid <= if_id_valid;
                if_id_pc    <= if_id_pc;
                if_id_instr <= if_id_instr;

                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= id_ex_valid;
                ex_mem_opcode     <= id_ex_opcode;
                ex_mem_dst        <= id_ex_dst;
                ex_mem_reg_write  <= id_ex_valid && id_ex_reg_write;
                ex_mem_mem_read   <= id_ex_valid && id_ex_mem_read;
                ex_mem_mem_write  <= id_ex_valid && id_ex_mem_write;
                ex_mem_result     <= ex_result_selected;
                ex_mem_ram_addr   <= id_ex_lit[9:0];
                ex_mem_store_data <= ex_src_value;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end

            // ====================================================
            // CASE 4: branch in decode, not taken
            // ====================================================
            else if (if_id_valid && dec_is_branch) begin
                pc                 <= pc + 6'd1;
                branch_flush_count <= 3'd0;
                load_recover_count <= 2'd0;
                load_recover_pc    <= 6'd0;

                if_id_valid <= 1'b1;
                if_id_pc    <= pc;
                if_id_instr <= rom_data;

                clear_id_ex();

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= 1'b0;
                ex_mem_opcode     <= OP_NOP;
                ex_mem_dst        <= 5'd0;
                ex_mem_reg_write  <= 1'b0;
                ex_mem_mem_read   <= 1'b0;
                ex_mem_mem_write  <= 1'b0;
                ex_mem_result     <= 32'd0;
                ex_mem_ram_addr   <= 10'd0;
                ex_mem_store_data <= 32'd0;
            end

            // ====================================================
            // CASE 5: normal pipeline advance
            // ====================================================
            else begin
                pc                 <= pc + 6'd1;
                branch_flush_count <= 3'd0;
                load_recover_count <= 2'd0;
                load_recover_pc    <= 6'd0;

                if_id_valid <= 1'b1;
                if_id_pc    <= pc;
                if_id_instr <= rom_data;

                id_ex_valid        <= if_id_valid;
                id_ex_pc           <= if_id_pc;
                id_ex_opcode       <= dec_opcode;
                id_ex_mode         <= dec_mode;
                id_ex_src          <= dec_src;
                id_ex_dst          <= dec_dst;
                id_ex_lit          <= dec_lit;
                id_ex_busA         <= id_readA_value;
                id_ex_busB         <= id_readB_value;
                id_ex_reg_write    <= dec_reg_write;
                id_ex_mem_read     <= dec_mem_read;
                id_ex_mem_write    <= dec_mem_write;
                id_ex_is_alu       <= dec_is_alu;
                id_ex_is_branch    <= dec_is_branch;
                id_ex_uses_src     <= dec_uses_src;
                id_ex_uses_lit_reg <= dec_uses_lit_reg;

                mem_wb_valid     <= ex_mem_valid;
                mem_wb_reg_write <= ex_mem_reg_write;
                mem_wb_dst       <= ex_mem_dst;

                if (ex_mem_mem_read)
                    mem_wb_result <= ram_dout;
                else
                    mem_wb_result <= ex_mem_result;

                ex_mem_valid      <= id_ex_valid;
                ex_mem_opcode     <= id_ex_opcode;
                ex_mem_dst        <= id_ex_dst;
                ex_mem_reg_write  <= id_ex_valid && id_ex_reg_write;
                ex_mem_mem_read   <= id_ex_valid && id_ex_mem_read;
                ex_mem_mem_write  <= id_ex_valid && id_ex_mem_write;
                ex_mem_result     <= ex_result_selected;
                ex_mem_ram_addr   <= id_ex_lit[9:0];
                ex_mem_store_data <= ex_src_value;

                if (id_ex_valid && id_ex_is_alu) begin
                    flag_Z <= alu_Z;
                    flag_N <= alu_N;
                    flag_C <= alu_C;
                    flag_V <= alu_V;
                end
            end
        end
    end

endmodule