`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/13 17:49:38
// Design Name: 
// Module Name: IF_ID pipeline register
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

module IF_ID(
    input               clk,
    input               rst_n,
    input               stall_D,
    input               flush_D,
    input       [31:0]  PC_F,
    input       [31:0]  imem_data,
    output reg  [31:0]  PC_D,
    output reg  [31:0]  instruction_D
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush_D) begin
            PC_D <= 32'b0;
            instruction_D <= 32'b0;
        end else if (stall_D) begin
            PC_D <= PC_D;
            instruction_D <= instruction_D;
        end else if (!stall_D) begin
            PC_D <= PC_F;
            instruction_D <= imem_data;
        end
    end

endmodule