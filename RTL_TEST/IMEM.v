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

        // --- 插入：jalr x8, x1, 16 
// --- 插入：jal x8, 8 → 0x0080046f ---   测试
        memory[24] = 8'h6f;
        memory[25] = 8'h04;
        memory[26] = 8'h00;
        memory[27] = 8'h01;
/*
        // jalr x8, x1, 36 → 0x02408467
        memory[24] = 8'h67;
        memory[25] = 8'h84;
        memory[26] = 8'h40;
        memory[27] = 8'h02;
*/
        // --- 指令 6: xor x6, x1, x2 (0x0020c333) ---
        memory[28] = 8'h33;
        memory[29] = 8'hc3;
        memory[30] = 8'h20;
        memory[31] = 8'h00;

        // --- 指令 7: srl x7, x1, x2 (0x0020d3b3) ---
        memory[32] = 8'hb3;
        memory[33] = 8'hd3;
        memory[34] = 8'h20;
        memory[35] = 8'h00;

        // --- sra x8, x1, x1 (0x4010e433) 
        memory[36] = 8'h33;
        memory[37] = 8'he4;
        memory[38] = 8'h10;
        memory[39] = 8'h40;

        // --- or x9, x1, x2 ---
        memory[40] = 8'hb3;
        memory[41] = 8'he4;
        memory[42] = 8'h20;
        memory[43] = 8'h00;

        // --- and x10, x1, x2 ---
        memory[44] = 8'h33;
        memory[45] = 8'hf5;
        memory[46] = 8'h20;
        memory[47] = 8'h00;


    end

endmodule
