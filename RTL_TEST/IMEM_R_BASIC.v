/*module IMEM #(parameter IMEM_SIZE = 1024) (
    input  [31:0] PC,
    output [31:0] instruction
);

    // Byte-addressable instruction memory
    reg [7:0] memory [0:IMEM_SIZE-1];

    // 输出指令（小端序拼接）
    assign instruction = { memory[PC + 3],
                           memory[PC + 2],
                           memory[PC + 1],
                           memory[PC + 0] };

    // 初始化 ROM 内容
    initial begin
        // 指令 0: addi x10, x0, 0  → 00000513
        memory[0]  = 8'h13;
        memory[1]  = 8'h05;
        memory[2]  = 8'h00;
        memory[3]  = 8'h00;

        // 指令 1: addi x11, x0, 4  → 00400593
        memory[4]  = 8'h93;
        memory[5]  = 8'h05;
        memory[6]  = 8'h40;
        memory[7]  = 8'h00;

        // 指令 2: sw x11, 0(x10)   → 00b52023
        memory[8]  = 8'h23;
        memory[9]  = 8'h20;
        memory[10] = 8'hb5;
        memory[11] = 8'h00;

        // 指令 3: lw x12, 0(x10)   → 00052603
        memory[12] = 8'h03;
        memory[13] = 8'h26;
        memory[14] = 8'h05;
        memory[15] = 8'h00;

        // 指令 4: add x12,x11,x12  → 00c58633
        memory[16] = 8'h33;
        memory[17] = 8'h86;
        memory[18] = 8'hc5;
        memory[19] = 8'h00;

        // 指令 5: sub x13,x11,x11  → 40b586b3
        memory[20] = 8'hb3;
        memory[21] = 8'h86;
        memory[22] = 8'hb5;
        memory[23] = 8'h40;

        // 指令 6: slt x14,x11,x11  → 00b5a733
        memory[24] = 8'h33;
        memory[25] = 8'ha7;
        memory[26] = 8'hb5;
        memory[27] = 8'h00;

        // 指令 7: sltu x15,x11,x11 → 00b5b7b3
        memory[28] = 8'hb3;
        memory[29] = 8'hb7;
        memory[30] = 8'hb5;
        memory[31] = 8'h00;

        // 指令 8: xor x16,x11,x11  → 00b5c833
        memory[32] = 8'h33;
        memory[33] = 8'hc8;
        memory[34] = 8'hb5;
        memory[35] = 8'h00;

        // 指令 9: srl x17,x11,x11  → 00b5d8b3
        memory[36] = 8'hb3;
        memory[37] = 8'hd8;
        memory[38] = 8'hb5;
        memory[39] = 8'h00;

        // 指令 10: sra x18,x11,x11 → 40b5d933
        memory[40] = 8'h33;
        memory[41] = 8'hd9;
        memory[42] = 8'hb5;
        memory[43] = 8'h40;

        // 指令 11: or x19,x11,x11  → 00b5e9b3
        memory[44] = 8'hb3;
        memory[45] = 8'he9;
        memory[46] = 8'hb5;
        memory[47] = 8'h00;

        // 指令 12: and x20,x11,x11 → 00b5f9b3
        memory[48] = 8'hb3;
        memory[49] = 8'hf9;
        memory[50] = 8'hb5;
        memory[51] = 8'h00;

        // 指令 13: sw x12, 0(x10)  → 00c52023
        memory[52] = 8'h23;
        memory[53] = 8'h20;
        memory[54] = 8'hc5;
        memory[55] = 8'h00;
    end

endmodule
*/

module IMEM #(parameter IMEM_SIZE = 1024) (
    input  [31:0] PC,
    output [31:0] instruction
);

    reg [7:0] memory [0:IMEM_SIZE-1];

    // 组合读取（小端拼接）
    assign instruction = { memory[PC + 3],
                           memory[PC + 2],
                           memory[PC + 1],
                           memory[PC + 0] };

    initial begin
        // --- 指令 0: NOP (addi x0, x0, 0) ---
        memory[0]  = 8'h00;
        memory[1]  = 8'h00;
        memory[2]  = 8'h00;
        memory[3]  = 8'h00;

        // --- 指令 1: addi x1, x0, 4 (0x00400093) ---
        memory[4]  = 8'h93;
        memory[5]  = 8'h00;
        memory[6]  = 8'h40;
        memory[7]  = 8'h00;

        // --- 指令 2: addi x2, x0, 1 (0x00100113) ---
        memory[8]  = 8'h13;
        memory[9]  = 8'h01;
        memory[10] = 8'h10;
        memory[11] = 8'h00;

        // --- 指令 3: add x3, x1, x2 (0x002081b3) ---
        memory[12] = 8'hb3;
        memory[13] = 8'h81;
        memory[14] = 8'h20;
        memory[15] = 8'h00;

        // --- 指令 4: sub x4, x1, x2 (0x40208233) ---
        memory[16] = 8'h33;
        memory[17] = 8'h82;
        memory[18] = 8'h20;
        memory[19] = 8'h40;

        // --- 指令 5: slt x5, x1, x2 (0x0020a2b3) ---
        memory[20] = 8'hb3;
        memory[21] = 8'ha2;
        memory[22] = 8'h20;
        memory[23] = 8'h00;



        // --- 指令 6: xor x6, x1, x2 (0x0020c333) ---
        memory[24] = 8'h33;
        memory[25] = 8'hc3;
        memory[26] = 8'h20;
        memory[27] = 8'h00;

        // --- 指令 7: srl x7, x1, x2 (0x0020d3b3) ---
        memory[28] = 8'hb3;
        memory[29] = 8'hd3;
        memory[30] = 8'h20;
        memory[31] = 8'h00;



        // --- sra x8, x1, x1 (0x4010e433) 原来是 32~35，现在放到 36~39 ---
        memory[32] = 8'h33;
        memory[33] = 8'he4;
        memory[34] = 8'h10;
        memory[35] = 8'h40;

        // --- or x9, x1, x2 ---
        memory[36] = 8'hb3;
        memory[37] = 8'he4;
        memory[38] = 8'h20;
        memory[39] = 8'h00;

        // --- and x10, x1, x2 ---
        memory[40] = 8'h33;
        memory[41] = 8'hf5;
        memory[42] = 8'h20;
        memory[43] = 8'h00;

                // lui x11, 1
        memory[44] = 8'hb7;
        memory[45] = 8'h15;
        memory[46] = 8'h00;
        memory[47] = 8'h00;
        //AUIPC x12, 1
        memory[48] = 8'h17;
        memory[49] = 8'h16;
        memory[50] = 8'h00;
        memory[51] = 8'h00;
/*
        // --- 指令 8: sra x8, x1, x1 (0x4010e433) ---0100 0000// 0001 0000 1//110 //0100 0 //011 0011这里的func3有点问题Decode阶段检查完毕，明天查EX阶段的逻辑
        memory[32] = 8'h33;
        memory[33] = 8'he4;
        memory[34] = 8'h10;
        memory[35] = 8'h40;

        // --- 指令 9: or x9, x1, x2 (0x0020e4b3) ---
        memory[36] = 8'hb3;
        memory[37] = 8'he4;
        memory[38] = 8'h20;
        memory[39] = 8'h00;

        // --- 指令 10: and x10, x1, x2 (0x0020f533) ---
        memory[40] = 8'h33;
        memory[41] = 8'hf5;
        memory[42] = 8'h20;
        memory[43] = 8'h00;
*/

    end

endmodule