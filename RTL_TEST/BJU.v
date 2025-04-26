`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 16:01:31
// Design Name: 
// Module Name: Branch Jump Unit
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
//4.13修改了PC_src_D的赋值方�?.
module BJU(
    input       [31:0]   PC_D,
    input       [31:0]   rs1_D,
    input       [31:0]   rs2_D,
    input       [31:0]   imm_D,
    input       [31:0]   ALU_result_M,
    input       [31:0]   ALU_result_E,
    input       [2:0]    branch,
    input       [1:0]    forward_A_D,
    input       [1:0]    forward_B_D,
    input                jump,
    input                jump_type,
    output reg  [31:0]   PC_Target_D,
    output               PC_src_D


);

    localparam BEQ       =  3'b000;
    localparam BNE       =  3'b001;
    localparam BLT       =  3'b100;
    localparam BGE       =  3'b101;
    localparam BLTU      =  3'b110;
    localparam BGEU      =  3'b111;
    localparam BNT       =  3'b010; // Not taken

    localparam JAL       =  1'b1;
    localparam JALR      =  1'b0; 

    localparam Forward_E2D =2'b01; //forward from Execute to Decode stage
    localparam Forward_M2D =2'b10; //forward from Memory to Decode stage
    localparam Forward_ND =2'b00; //no forward

    wire [31:0] rs1_D_fwd;
    wire [31:0] rs2_D_fwd;
    reg         BT; //branch taken

    assign PC_src_D= (BT || jump) ? 1'b1 : 1'b0;
    //如果是Branch Taken或�?�分支指令，则PC_src_D�?1，否则为0

    assign rs1_D_fwd = (forward_A_D == Forward_E2D) ? ALU_result_E : 
                        (forward_A_D == Forward_M2D) ? ALU_result_M : 
                         rs1_D; //forward from Execute to Decode stage or Memory to Decode stage

    assign rs2_D_fwd = (forward_B_D == Forward_E2D) ? ALU_result_E :
                        (forward_B_D == Forward_M2D) ? ALU_result_M : 
                         rs2_D; //forward from Execute to Decode stage or Memory to Decode stage
    
    always@(*)
    begin
        if(jump)
        begin
            case(jump_type)
                JAL:
                    begin // JAL
                        PC_Target_D = PC_D + imm_D;
                    end
                JALR:
                    begin // JALR
                        PC_Target_D = (rs1_D + imm_D) & 32'hFFFFFFFE;
                    end
                default:
                    begin
                        PC_Target_D = PC_D + imm_D;
                    end

            endcase
        end

        else
            begin
                PC_Target_D = PC_D + imm_D;
                case(branch)
                    BEQ:
                        begin // BEQ
                            if(rs1_D_fwd == rs2_D_fwd)
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BNE:
                        begin // BNE
                            if(rs1_D_fwd != rs2_D_fwd)
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BLT:
                        begin // BLT
                            if($signed(rs1_D_fwd) < $signed(rs2_D_fwd))
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BGE:
                        begin // BGE
                            if($signed(rs1_D_fwd) >= $signed(rs2_D_fwd))
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BLTU:   
                        begin // BLTU
                            if(rs1_D_fwd < rs2_D_fwd)
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BGEU:
                        begin // BGEU
                            if(rs1_D_fwd >= rs2_D_fwd)
                                begin
                                    BT = 1'b1;
                                end
                            else    BT = 1'b0;
                        end
                    BNT:
                        begin
                            BT = 1'b0; // Not taken
                        end
                    default:
                        begin
                            BT = 1'b0; // Not taken
                        end
                endcase

            end

        
    end
endmodule