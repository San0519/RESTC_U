`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: EX_ME pipeline register
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
module EX_ME(
    input               clk,
    input               rst_n,
    input       [31:0]  ALU_result_E,
    input       [31:0]  write_data_E,//from rdata2_f_E
    input       [4:0]   rd_E,
    input       [1:0]   wb_ctrl_E,
    input               we_reg_E,
    input               we_mem_E,
    input       [3:0]   ls_type_E,
    input       [31:0]  PC_E,
    
    output reg  [31:0]  ALU_result_M,
    output reg  [31:0]  write_data_M,
    output reg  [4:0]   rd_M,   
    output reg  [1:0]   wb_ctrl_M,
    output reg          we_reg_M,
    output reg          we_mem_M,
    output reg  [3:0]   ls_type_M,
    output reg  [31:0]  PC_M

    );
    
    always @(posedge clk ) begin
        if (!rst_n) begin
            ALU_result_M <= 32'b0;
            write_data_M <= 32'b0;
            rd_M <= 5'b0;
            wb_ctrl_M <= 2'b0;
            we_reg_M <= 1'b0;
            we_mem_M <= 1'b0;
            ls_type_M <= 4'b0;
            PC_M <= 32'b0;
        end else begin
            ALU_result_M <= ALU_result_E;
            write_data_M <= write_data_E;
            rd_M <= rd_E;   
            wb_ctrl_M <= wb_ctrl_E;
            we_reg_M <= we_reg_E;
            we_mem_M <= we_mem_E;
            ls_type_M <= ls_type_E;
            PC_M <= PC_E; 
        end
    end
endmodule