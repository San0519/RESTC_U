`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/04 17:49:38
// Design Name: 
// Module Name: Dependence_Stall
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
/// 4.13增添了branch prediction 的flush_D信号
//4.15 删除了rd_D信号
module Dependence_Stall(
    input       [4:0]   rs1_D,
    input       [4:0]   rs2_D,
    input       [4:0]   rs1_E,
    input       [4:0]   rs2_E,
    input       [4:0]   rd_E,
    input       [4:0]   rd_M,
    input       [4:0]   rd_W,
    input       [1:0]   wb_ctrl_E,
    input       [1:0]   wb_ctrl_M,
    input       [2:0]   branch,
    input               we_reg_E,
    input               we_reg_M,
    input               we_reg_W,
    input               PC_src_D,
    output              stall_F,
    output              stall_D,
    output              flush_D,
    output              flush_E,
    output      [1:0]   forward_A_D,
    output      [1:0]   forward_B_D,
    output      [1:0]   forward_A_E,
    output      [1:0]   forward_B_E

    );


    localparam Forward_M2E =2'b01; //forward from Memory to Execute stage
    localparam Forward_W2E =2'b10; //forward from Writeback to Execute stage
    localparam Forward_NE =2'b00; //no forward
    
    localparam Forward_E2D =2'b01; //forward from Execute to Decode stage
    localparam Forward_M2D =2'b10; //forward from Memory to Decode stage
    localparam Forward_ND =2'b00; //no forward

    localparam BNT       =  3'b010; // Branch not taken
    
    wire       lwStall;//load stall
    wire       brStall;//branch stall

    //forwarding logic
    assign forward_A_E =(rs1_E!=0 && rs1_E == rd_M && we_reg_M)? Forward_M2E://背靠背RAW型Data Hazard
                        (rs1_E!=0 && rs1_E == rd_W && we_reg_W)? Forward_W2E://隔行式RAW型Data Hazard
                        Forward_NE;
    assign forward_B_E =(rs2_E!=0 && rs2_E == rd_M && we_reg_M)? Forward_M2E:
                        (rs2_E!=0 && rs2_E == rd_W && we_reg_W)? Forward_W2E:
                        Forward_NE;

    assign forward_A_D =(rs1_D!=0 && rs1_D == rd_E && we_reg_E)? Forward_E2D://背靠背RAW型Data Hazard
                        (rs1_D!=0 && rs1_D == rd_M && we_reg_M)? Forward_M2D://隔行式RAW型Data Hazard
                        Forward_ND;
    assign forward_B_D =(rs2_D!=0 && rs2_D == rd_E && we_reg_E)? Forward_E2D:
                        (rs2_D!=0 && rs2_D == rd_M && we_reg_M)? Forward_M2D:
                        Forward_ND;

    //stall/flush logic
    assign lwStall =   (rs1_D == rd_E || rs2_D == rd_E) 
                    && (wb_ctrl_E == 2'b01) 
                    && (rs1_D != 0 || rs2_D != 0); //&& we_reg_E,判断是否为load且存在RAW
    
    assign brStall =   (branch!=BNT && wb_ctrl_M == 2'b01)
                    && ((rs1_D == rd_M || rs2_D == rd_M) && (rs1_D != 0 || rs2_D != 0)); 
                        //检测分支使用的寄存器是否为正在进行的load指令的目的寄存器
    assign stall_F = lwStall || brStall; 
    assign stall_D = lwStall || brStall; 
    assign flush_D = PC_src_D;
    //如果是branch prediction的版本：assign flush_D = (PC_src_D == pred_jump_D) ? 1'b0 : 1'b1;
    assign flush_E = lwStall || brStall;

endmodule
