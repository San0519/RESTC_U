`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: ID_EX pipeline register
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

module ID_EX(
    input               clk,
    input               rst_n,
    input               flush_E,
    input       [31:0]  PC_D,
    input       [31:0]  rdata1_D,
    input       [31:0]  rdata2_D,
    input       [4:0]   rs1_D,
    input       [4:0]   rs2_D,
    input       [4:0]   rd_D,
    input       [1:0]   wb_ctrl_D,
    input       [3:0]   ALU_ctrl_D,
    input               ALU_src1_D,
    input               ALU_src2_D,
    input               we_reg_D,
    input               we_mem_D,
    input       [2:0]   ls_type_D,
    input       [31:0]  imm_D,
    
    output reg  [31:0]  PC_E,
    output reg  [31:0]  rdata1_E,
    output reg  [31:0]  rdata2_E,
    output reg  [4:0]   rd_E,   
    output reg  [31:0]  imm_E,
    output reg  [1:0]   wb_ctrl_E,
    output reg  [3:0]   ALU_ctrl_E,
    output reg          ALU_src1_E,
    output reg          ALU_src2_E,
    output reg          we_reg_E,
    output reg          we_mem_E,
    output reg  [2:0]   ls_type_E,
    output reg  [4:0]   rs1_E,
    output reg  [4:0]   rs2_E


    );

    always @(posedge clk ) begin
        if (!rst_n || flush_E) begin
            PC_E <= 32'b0;
            rdata1_E <= 32'b0;
            rdata2_E <= 32'b0;
            rd_E <= 5'b0;
            rs1_E <= 5'b0;
            rs2_E <= 5'b0;
            imm_E <= 32'b0;
            wb_ctrl_E <= 2'b0;
            ALU_ctrl_E <= 4'b0;
            ALU_src1_E <= 1'b0;
            ALU_src2_E <= 1'b0;
            we_reg_E <= 1'b0;
            we_mem_E <= 1'b0;
            ls_type_E <= 3'b0;

        end else begin
            PC_E <= PC_D;
            rdata1_E <= rdata1_D;
            rdata2_E <= rdata2_D;
            rd_E <= rd_D;
            rs1_E <= rs1_D;
            rs2_E <= rs2_D; 
            imm_E <= imm_D; 
            wb_ctrl_E <= wb_ctrl_D; 
            ALU_ctrl_E <= ALU_ctrl_D; 
            ALU_src1_E <= ALU_src1_D; 
            ALU_src2_E <= ALU_src2_D; 
            we_reg_E <= we_reg_D; 
            we_mem_E <= we_mem_D; 
            ls_type_E <= ls_type_D; 
        end
    end
endmodule