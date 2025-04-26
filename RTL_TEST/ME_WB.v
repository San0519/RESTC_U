//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: ME_WB pipeline register
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
module ME_WB(
    input               clk,
    input               rst_n,
    input       [31:0]  ALU_result_M,
    input       [31:0]  Rdata_ext_M,//from data memory（extended）
    input       [4:0]   rd_M,
    input       [1:0]   wb_ctrl_M,
    input       [31:0]  PC_M,
    input               we_reg_M,
    
    output reg  [31:0]  ALU_result_W,
    output reg  [31:0]  Rdata_W,
    output reg  [4:0]   rd_W,   
    output reg  [1:0]   wb_ctrl_W,
    output reg  [31:0]  PC_W,
    output reg          we_reg_W
    );  


    always @(posedge clk , negedge rst_n) begin
        if (!rst_n) begin
            ALU_result_W <= 32'b0;
            Rdata_W <= 32'b0;
            rd_W <= 5'b0;
            wb_ctrl_W <= 2'b0;
            we_reg_W <= 1'b0;
            PC_W <= 32'b0;
        end else begin
            ALU_result_W <= ALU_result_M;
            Rdata_W <= Rdata_ext_M;
            rd_W <= rd_M;   
            wb_ctrl_W <= wb_ctrl_M;
            we_reg_W <= we_reg_M;
            PC_W <= PC_M;
        end
    end
    
endmodule