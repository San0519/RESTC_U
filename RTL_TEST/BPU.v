`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/12 16:01:31
// Design Name: 
// Module Name: Branch Prediction Unit, using 2-bit saturating counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Used for predicting branch instructions
// 分为地址预测和目标预测两部分，地址预测使用 2-bit 饱和计数器Branch History Table，
// 目标预测使用 Branch Target Buffer,对于每一条指令都会有一个对应的目标地址，无论是否是跳转指令
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module BranchPredictor #( 
    parameter BHT_SIZE = 64,  // 可调大小，表示支持 64 个entry 的 BHT
    parameter BTB_SIZE = 32 
)(
    input              clk,
    input              rst_n,

    // 输入：来自 IF 阶段的 PC
    input      [31:0]  PC_F,
    output reg         pred_jump_F,       // IF 阶段输出：是否预测跳转
    output reg [31:0]  pred_target,     // IF 阶段输出：预测的跳转地址

    // 输入：来自 DECODE 阶段的实际跳转信息
    input              PC_src_D,       // 实际的PC选择信号
    input      [31:0]  PC_D,            // 分支指令的 PC
    input      [31:0]  real_target      // 实际跳转目标地址,PC_target_D
);

    // --- 2-bit 饱和计数器 BHT ---
    reg [1:0] bht [0:BHT_SIZE-1];
    reg [31:0] btb [0:BTB_SIZE-1];
    //Branch Target Buffer,
    wire [5:0] index_F = PC_F[7:2];
    wire [5:0] index_D = PC_D[7:2];



    always @(*) begin
        case (bht[index_F])
            2'b00, 2'b01: pred_jump_F = 0;  // 弱/强不跳
            2'b10, 2'b11: pred_jump_F = 1;  // 弱/强跳
        endcase
        if (pred_jump_F)    
        begin // 如果预测跳转，则输出预测的目标地址
            pred_target = btb[index_F]; // 预测的目标地址为 BTB 中存储的地址
        end
        else
            begin // 如果预测不跳转，则输出 PC + 4
            pred_target = PC_F + 4; // 预测的目标地址为 PC + 4
            end
    end

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < BHT_SIZE; i = i + 1) begin
                bht[i] <= 2'b01;     // 初始化为弱不跳
                btb[i] <= 32'b0;
            end
        end else begin
            // 更新 BHT 预测状态
            case ({PC_src_D, bht[index_D]})
                3'b000: 
                    begin
                        bht[index_D] <= 2'b00; // 强不跳 -> 保持
                    end
                3'b001:
                    begin
                        bht[index_D] <= 2'b00; // 弱不跳 -> 强不跳
                    end
                3'b010:
                    begin
                        bht[index_D] <= 2'b01; // 弱跳 -> 弱不跳
                    end
                3'b011: 
                    begin
                        bht[index_D] <= 2'b10; // 强跳 -> 弱跳
                    end
                3'b100: 
                    begin
                        bht[index_D] <= 2'b01; // 强不跳 -> 弱不跳
                    end
                3'b101:
                    begin
                        bht[index_D] <= 2'b10; // 弱不跳 -> 弱跳
                    end
                3'b110:
                    begin
                        bht[index_D] <= 2'b11; // 弱跳 -> 强跳
                    end
                3'b111:
                    begin
                        bht[index_D] <= 2'b11; // 强跳 -> 保持
                    end
                default:
                    begin
                        bht[index_D] <= 2'b01; // 默认设置为弱不跳
                    end
            endcase
            // 更新 BTB
            if (PC_src_D)
                begin
                    btb[index_D] <= real_target;
                end
        end
    end


endmodule
