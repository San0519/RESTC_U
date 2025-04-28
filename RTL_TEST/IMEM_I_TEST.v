

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
        
            // --- 指令 3: andi x3, x1, 4 (0x0040F193) ---
            memory[12] = 8'h93;
            memory[13] = 8'hF1;
            memory[14] = 8'h40;
            memory[15] = 8'h00;
        
            // --- 指令 4: andi x4, x1, 1 (0x0010F213) ---
            memory[16] = 8'h13;
            memory[17] = 8'hF2;
            memory[18] = 8'h10;
            memory[19] = 8'h00;
        
            // --- 指令 5: ori x5, x1, 3 (0x0030E293) ---
            memory[20] = 8'h93;
            memory[21] = 8'hE2;
            memory[22] = 8'h30;
            memory[23] = 8'h00;
        
            // --- 指令 6: xori x6, x1, 15 (0x00F0C313) ---
            memory[24] = 8'h13;
            memory[25] = 8'hC3;
            memory[26] = 8'hF0;
            memory[27] = 8'h00;
        
            // --- 指令 7: slti x7, x1, -2 (0xFFE0A393) ---
            memory[28] = 8'h93;
            memory[29] = 8'hA3;
            memory[30] = 8'hE0;
            memory[31] = 8'hFF;
        
            // --- 指令 8: slti x8, x1, 5 (0x0050A413) ---
            memory[32] = 8'h13;
            memory[33] = 8'hA4;
            memory[34] = 8'h50;
            memory[35] = 8'h00;
        
            // --- 指令 9: sltiu x9, x1, -2 (0xFFE0B493) ---
            memory[36] = 8'h93;
            memory[37] = 8'hB4;
            memory[38] = 8'hE0;
            memory[39] = 8'hFF;
        
            // --- 指令 10: slli x10, x2, 1 (0x00111513) ---
            memory[40] = 8'h13;
            memory[41] = 8'h15;
            memory[42] = 8'h11;
            memory[43] = 8'h00;
        
            // --- 指令 11: srli x11, x1, 2 (0x0020D593) ---
            memory[44] = 8'h93;
            memory[45] = 8'hD5;
            memory[46] = 8'h20;
            memory[47] = 8'h00;
        
            // --- 指令 12: srli x12, x1, 3 (0x0030D613) ---
            memory[48] = 8'h13;
            memory[49] = 8'hD6;
            memory[50] = 8'h30;
            memory[51] = 8'h00;
        
            // --- 指令 13: srai x13, x1, 3 (0x4030D613) ---
            memory[52] = 8'h93;
            memory[53] = 8'hD6;
            memory[54] = 8'h30;
            memory[55] = 8'h40;

            //指令14: addi x14, x0, -3 (FFD00713)
            memory[56] = 8'h13;
            memory[57] = 8'h07;
            memory[58] = 8'hD0;
            memory[59] = 8'hFF;

            // --- 指令 15: srai x15, x14, 4 (0x40475793)
            memory[60] = 8'h93;
            memory[61] = 8'h57;
            memory[62] = 8'h47;
            memory[63] = 8'h40;
        

    end

endmodule