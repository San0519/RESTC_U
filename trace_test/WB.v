`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 16:01:31
// Design Name: 
// Module Name: WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//4.13,增加了对JAL和JALR的支持，假设在流水线中传递到信号是PC而不是PC+4，因此在WB阶段需要加4
module WB(
    input       [31:0]   ALU_result_W,
    input       [31:0]   Rdata_W,
    input       [31:0]   PC_W,
    input       [1:0]    wb_ctrl_W,
    output reg  [31:0]   WB_data
);
    localparam ALU = 2'b00; // ALU result
    localparam MEM = 2'b01; // Memory data
    localparam PC4 = 2'b11; // PC + 4,from JAL and JALR

    always @(*)
    begin
        case(wb_ctrl_W)
            ALU:begin
                WB_data = ALU_result_W;
            end
            MEM:begin
                WB_data = Rdata_W;
            end
            PC4:begin
                WB_data = PC_W+4;// PC + 4,from JAL and JALR
            end
            default:begin
                WB_data = ALU_result_W;
            end
        endcase
    end


endmodule