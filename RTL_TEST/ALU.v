`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/04 16:01:31
// Design Name: 
// Module Name: ALU
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


module ALU (
    input       [31:0]   src1,
    input       [31:0]   src2,
    input       [3:0]    ALU_ctrl, // 与Decoder中定义保持一致
    output reg  [31:0]   ALU_result
);
    // 与 Decoder 保持一致的控制码定义
    localparam ADD       =  4'b0000;
    localparam SUB       =  4'b0001;
    localparam SLL       =  4'b0101;
    localparam SLT       =  4'b0110;
    localparam SLTU      =  4'b0111;
    localparam XOR       =  4'b0100;
    localparam SRL       =  4'b1000;
    localparam SRA       =  4'b1001;
    localparam OR        =  4'b0011;
    localparam AND       =  4'b0010;
    localparam NOP       =  4'b1110;


    always @(*) begin
        case (ALU_ctrl)
            ADD:begin
                ALU_result = src1 + src2;
            end
            SUB:begin
                ALU_result = src1 - src2;
            end
            SLL:begin
                ALU_result = src1 << src2[4:0];
            end
            SLT:begin
                ALU_result = ($signed(src1) < $signed(src2)) ? 32'b1 : 32'b0;
            end
            SLTU:begin
                ALU_result = (src1 < src2) ? 32'b1 : 32'b0;
            end
            XOR:begin
                ALU_result = src1 ^ src2;
            end
            SRL:begin
                ALU_result = src1 >> src2[4:0];
            end
            SRA:begin
                ALU_result = $signed(src1) >>> src2[4:0];
            end
            OR:begin
                ALU_result = src1 | src2;
            end
            AND:begin
                ALU_result = src1 & src2;
            end
            NOP:begin
                ALU_result = 32'b0;
            end
            default:begin
                ALU_result = 32'b0;
            end
        endcase  
    end
endmodule
