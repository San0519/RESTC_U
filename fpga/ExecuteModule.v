`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/04 16:01:14
// Design Name: 
// Module Name: ExecuteModule
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


module ExecuteModule(
    input       [31:0]   rdata1_E,
    input       [31:0]   rdata2_E,
    input       [31:0]   imm_E,
    input       [31:0]   PC_E,
    input       [31:0]   ALU_result_M,
    input       [31:0]   WB_data,
    input       [1:0]    forward_A_E,
    input       [1:0]    forward_B_E,
    input       [3:0]    ALU_ctrl_E,
    input                ALU_src1_E,
    input                ALU_src2_E,
    input       [1:0]    wb_ctrl_M,
    input       [31:0]   Rdata_ext_M,


    output      [31:0]   ALU_result_E,
    output      [31:0]   write_data_E


    );
    
    localparam Forward_M2E =2'b01; //forward from Memory to Execute stage
    localparam Forward_W2E =2'b10; //forward from Writeback to Execute stage
    localparam Forward_NE =2'b00; //no forward

    wire        [31:0]   src1;
    wire        [31:0]   src2;
    reg        [31:0]   rdata1_f_E;
    reg        [31:0]   rdata2_f_E;


    assign src1 = ALU_src1_E ? (PC_E) : rdata1_f_E;
    assign src2 = ALU_src2_E ? imm_E : rdata2_f_E;
    assign write_data_E = rdata2_f_E;
    
    always @(*)begin

        case(forward_A_E)
            Forward_NE:begin
                rdata1_f_E = rdata1_E;
            end
            Forward_M2E:begin
                if(wb_ctrl_M == 2'b01)
                begin
                    rdata1_f_E = Rdata_ext_M;
                end
                else 
                begin
                    rdata1_f_E = ALU_result_M;
                end
            end
            Forward_W2E:begin
                rdata1_f_E = WB_data;
            end
            default:begin
                rdata1_f_E = rdata1_E;
            end
        endcase
    end

    always @(*)begin

        case(forward_B_E)
            Forward_NE:begin
                rdata2_f_E = rdata2_E;
            end
            Forward_M2E:begin
                if(wb_ctrl_M == 2'b01)
                begin
                    rdata2_f_E = Rdata_ext_M;
                end
                else 
                begin
                    rdata2_f_E = ALU_result_M;
                end
            end
            Forward_W2E:begin
                rdata2_f_E = WB_data;
            end
            default:begin
                rdata2_f_E = rdata2_E;
            end
        endcase
    end


    ALU u_ALU1(
        .src1(src1),
        .src2(src2),
        .ALU_ctrl(ALU_ctrl_E),
        .ALU_result(ALU_result_E)
    );

endmodule