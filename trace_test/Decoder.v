`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 19:20:01
// Design Name: 
// Module Name: Decoder
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
//
//当rs_D,rs2_D,rd_D 都不需要赋值时，值不变
//需要一个信号告诉寄存器或者内存是否是word,half,byte
//4.4修改了(1)we_reg_D的赋值逻辑(2)在JAL和JARL中ALU_ctrl_D的赋值逻辑，在这两个指令中，PC值不用ALU计算，正常的+4值由PC模块计算
//4.5增添sext_type信号，来选择不同的立即数扩展方式
//4.10 增添 load/store type信号，来选择不同的load/store方式
//4.13,将instruction改为instruction_D
//4.17 branch的ALU操作 应该改为NOP？
//4.24 LUI修改RS1
module Decoder(
    input       [31:0]  instruction_D,
    output reg  [4:0]   rs1_D,
    output reg  [4:0]   rs2_D,
    output reg  [4:0]   rd_D,
    output reg  [3:0]   ALU_ctrl_D,
    output reg  [2:0]   branch,
    output reg  [3:0]   ls_type_D,//load/store type
    output      [2:0]   sext_type,
    output      [1:0]   wb_ctrl_D,
    output              jump,
    output              jump_type,
    output              ALU_src1_D,
    output              ALU_src2_D,
    output              we_reg_D,
    output              we_mem_D

    );

    localparam EXE_R     =  7'b0110011;
    localparam EXE_I     =  7'b0010011;
    localparam EXE_S     =  7'b0100011;
    localparam EXE_B     =  7'b1100011;
    localparam EXE_JAL   =  7'b1101111;
    localparam EXE_JALR  =  7'b1100111;
    localparam EXE_L     =  7'b0000011;
    localparam EXE_AUIPC =  7'b0010111;
    localparam EXE_LUI   =  7'b0110111;
    localparam EXE_NOP   =  7'b0000000;

    localparam BEQ       =  3'b000;
    localparam BNE       =  3'b001;
    localparam BLT       =  3'b100;
    localparam BGE       =  3'b101;
    localparam BLTU      =  3'b110;
    localparam BGEU      =  3'b111;
    localparam BNT       =  3'b010; // Not taken

    localparam JAL       =1'b1;
    localparam JALR       =1'b0;

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
    //localparam JALR      =  4'b1111;
    localparam NOP       =  4'b1110;
    
    localparam LB_F3     =  3'b000;
    localparam LH_F3     =  3'b001;
    localparam LW_F3     =  3'b010;
    localparam LBU_F3    =  3'b100;
    localparam LHU_F3    =  3'b101;
    localparam SB_F3     =  3'b000;
    localparam SH_F3     =  3'b001;
    localparam SW_F3     =  3'b010;




    localparam LB        =  4'b0000;
    localparam LH        =  4'b0010;
    localparam LW        =  4'b0100;
    localparam LBU       =  4'b1000;
    localparam LHU       =  4'b1010;
    localparam SB        =  4'b0001;
    localparam SH        =  4'b0011;
    localparam SW        =  4'b0101;


    
    wire    [6:0]   opcode;
    reg     [2:0]   funct3;
    reg     [6:0]   funct7;

    assign opcode = instruction_D[6:0];
    //assign we_reg_D  = (opcode == EXE_R || opcode == EXE_I || opcode == EXE_JAL || opcode == EXE_JALR) ? 1'b1 : 1'b0; // Write to register or not,R,I,Load
    //assign we_reg_D  = (opcode == EXE_R || opcode == EXE_I || opcode == EXE_JAL || opcode == EXE_JALR || opcode == EXE_LUI || opcode == EXE_AUIPC || opcode == EXE_L) ? 1'b1 : 1'b0;
    assign we_reg_D  = (opcode == EXE_S || opcode == EXE_B|| opcode==EXE_NOP ) ? 1'b0 : 1'b1; // Write to register or not,R,I,Load
    assign we_mem_D  = (opcode == EXE_S) ? 1'b1 : 1'b0; // Write to memory or not,Store
    assign wb_ctrl_D = (opcode == EXE_I || opcode == EXE_R || opcode == EXE_AUIPC || opcode == EXE_LUI) ? 2'b00 :  
                       (opcode == EXE_JAL || opcode == EXE_JALR) ? 2'b11 : // J
                       (opcode == EXE_L) ? 2'b01 : // Load
                        2'b00; //

    assign ALU_src2_D = (opcode == EXE_I || opcode == EXE_S || opcode == EXE_L|| opcode == EXE_AUIPC || opcode == EXE_LUI ) ? 1'b1 : 1'b0; // ALU source, I-type and S-type instruction_Ds
    assign ALU_src1_D = (opcode == EXE_AUIPC) ? 1'b1 : 1'b0; // ALU source, AUIPC instruction_D
    // ALU_src1_D is used for AUIPC instruction_D, which adds the immediate value to the PC
    assign jump = (opcode == EXE_JAL || opcode == EXE_JALR) ? 1'b1 : 1'b0; // Jump control, JAL and JALR instruction_Ds
    // Jump is used to indicate whether the instruction_D is a jump instruction_D or not
    assign jump_type = (opcode == EXE_JAL)? JAL :JALR; // JALR or JAL


    localparam EXT_I     = 3'b000;  // I-type,JALR,Load,Store.
    localparam EXT_B     = 3'b001;  // B-type: BEQ, etc.
    localparam EXT_U     = 3'b011;  // U-type: LUI, AUIPC
    localparam EXT_JAL   = 3'b010;  // J-type: JAL
    localparam EXT_S     = 3'b110;  // S-type: Store
    assign sext_type = (opcode == EXE_I ||  opcode == EXE_L || opcode == EXE_JALR) ? EXT_I : // I-type, S-type, Load
                       (opcode == EXE_B) ? EXT_B : // B-type
                       (opcode == EXE_AUIPC || opcode == EXE_LUI) ? EXT_U : // U-type
                       (opcode == EXE_JAL) ? EXT_JAL : // J-type
                        (opcode == EXE_S)? EXT_S : // S-type
                        EXT_I; // Default to I-type


    always @(*) begin
        case (opcode)

            EXE_R: begin // R-type
                rs1_D = instruction_D[19:15];
                rs2_D = instruction_D[24:20];
                rd_D = instruction_D[11:7];
                funct3 = instruction_D[14:12];
                funct7 = instruction_D[31:25];
                branch = BNT; // Not used in R-type
                case (funct3)
                    3'b000: begin // ADD/SUB
                        if (funct7 == 7'b0000000) begin
                            ALU_ctrl_D = ADD; // ADD
                        end else if (funct7 == 7'b0100000) begin
                            ALU_ctrl_D = SUB; // SUB
                        end
                    end
                    3'b001: begin // SLL
                        ALU_ctrl_D = SLL;
                    end
                    3'b010: begin // SLT
                        ALU_ctrl_D = SLT;
                    end
                    3'b011: begin // SLTU
                        ALU_ctrl_D = SLTU;
                    end
                    3'b100: begin // XOR
                        ALU_ctrl_D = XOR;
                    end
                    3'b101: begin // SRL/SRA
                        if (funct7 == 7'b0000000) begin
                            ALU_ctrl_D = SRL; // SRL
                        end else if (funct7 == 7'b0100000) begin
                            ALU_ctrl_D = SRA; // SRA
                        end
                    end
                    3'b110: begin // OR
                        ALU_ctrl_D = OR;
                    end
                    3'b111: begin // AND
                        ALU_ctrl_D = AND;
                    end
                    default: begin
                        ALU_ctrl_D = ADD; // Default to ADD
                    end
                endcase
            end

            EXE_I: begin // I-type load
                rs1_D = instruction_D[19:15];
                rs2_D = rs2_D;// Not using rs2_D in I-type
                rd_D = instruction_D[11:7];
                funct3 = instruction_D[14:12];
                funct7 = instruction_D[31:25];//used for SRLI/SRAI
                branch = BNT; // Not used in I-type
                case(funct3)
                3'b000: begin // ADDI
                        ALU_ctrl_D = ADD; // ADD
                end
                3'b001: begin // SLL
                        ALU_ctrl_D = SLL;
                end
                3'b010: begin // SLT
                        ALU_ctrl_D = SLT;
                end
                3'b011: begin // SLTU
                        ALU_ctrl_D = SLTU;
                end
                3'b100: begin // XORI
                        ALU_ctrl_D = XOR;
                end
                3'b101: begin // SRLI/SRAI
                        if (funct7 == 7'b0000000) begin
                            ALU_ctrl_D = SRL; // SRLI
                        end else if (funct7 == 7'b0100000) begin
                            ALU_ctrl_D = SRA; // SRAI
                        end
                end
                3'b110: begin // ORI
                        ALU_ctrl_D = OR;
                end
                3'b111: begin // ANDI
                        ALU_ctrl_D = AND;
                end
                default: begin
                    ALU_ctrl_D = ADD; // Default to ADD
                end
                endcase

            end


            EXE_B: begin // B-type branch
                rs1_D = instruction_D[19:15];
                rs2_D = instruction_D[24:20];
                rd_D = rd_D; // Not using rd_D in B-type
                funct3 = instruction_D[14:12];
                ALU_ctrl_D = NOP; // 应该改为NOP？
                case(funct3)
                3'b000: begin // BEQ
                    branch = BEQ;
                end
                3'b001: begin // BNE
                    branch = BNE;
                end
                3'b100: begin // BLT
                    branch = BLT;
                end
                3'b101: begin // BGE
                    branch = BGE;
                end
                3'b110: begin // BLTU
                    branch = BLTU;
                end
                3'b111: begin // BGEU
                    branch = BGEU;
                end
                default: begin
                    branch = BNT; // Default to BEQ,not taken
                end
                endcase
            end
            EXE_JAL: begin // J-type jump
                rs1_D = rs1_D; // Not using rs1 in J-type
                rs2_D = rs2_D; // Not using rs2_D in J-type
                rd_D = instruction_D[11:7]; 
                ALU_ctrl_D = NOP; // ADD for address calculation
                branch = BNT; // Not used in JAL
            end
            EXE_JALR: begin // JALR
                rs1_D = instruction_D[19:15];
                rs2_D = rs2_D; // Not using rs2_D in JALR
                rd_D = instruction_D[11:7]; 
                ALU_ctrl_D = NOP; // ADD for address calculation
                branch = BNT; // Not used in JALR
            end
            EXE_L: begin // Load
                rs1_D = instruction_D[19:15];
                rs2_D = rs2_D; // Not using rs2_D in Load
                rd_D = instruction_D[11:7]; 
                funct3 = instruction_D[14:12];
                ALU_ctrl_D = ADD; // ADD for address calculation
                branch = BNT; // Not used in Load
                case(funct3)
                    LB_F3: begin
                        ls_type_D = LB; // Sign-extend for LB
                    end
                    LH_F3: begin
                        ls_type_D = LH; // Sign-extend for LH
                    end
                    LW_F3: begin
                        ls_type_D = LW; // Sign-extend for LW
                    end
                    LBU_F3: begin
                        ls_type_D = LBU; // Zero-extend for LBU
                    end
                    LHU_F3: begin
                        ls_type_D = LHU; // Zero-extend for LHU
                    end
                    default: begin
                        ls_type_D = LB; // Default to sign-extend
                    end
                endcase
                
            end
            EXE_S: begin // S-type store
                rs1_D = instruction_D[19:15];
                rs2_D = instruction_D[24:20];
                rd_D = rd_D; // Not using rd_D in S-type
                funct3 = instruction_D[14:12];
                ALU_ctrl_D = ADD; // ADD for address calculation
                branch = BNT; // Not used in S
                case(funct3)
                    SB_F3: begin
                        ls_type_D = SB; // Sign-extend for SB
                    end
                    SH_F3: begin
                        ls_type_D = SH; // Sign-extend for SH
                    end
                    SW_F3: begin
                        ls_type_D = SW; // Sign-extend for SW
                    end
                    default: begin
                        ls_type_D = SB; // Default to StoreB
                    end
                endcase
            end
            
            EXE_AUIPC: begin // AUIPC
                rs1_D = rs1_D; // Not using rs1 in AUIPC
                rs2_D = rs2_D; // Not using rs2_D in AUIPC
                rd_D = instruction_D[11:7]; 
                ALU_ctrl_D = ADD; // ADD for address calculation
                branch = BNT; // Not used in AUIPC
            end
            EXE_LUI: begin // LUI
                rs1_D = 5'b00000; // Using x0 as rs1
                rs2_D = rs2_D; // Not using rs2_D in LUI
                rd_D = instruction_D[11:7]; 
                ALU_ctrl_D = ADD; // ADD for address calculation
                branch = BNT; // Not used in LUI
            end
            EXE_NOP: begin // NOP
                rs1_D = rs1_D; // Not using rs1 in NOP
                rs2_D = rs2_D; // Not using rs2_D in NOP
                rd_D = rd_D; // Not using rd_D in NOP
                ALU_ctrl_D = NOP;  // NOP operation
                branch = BNT; // Not used in NOP
            end

            default: begin
                rs1_D = 5'b0;
                rs2_D = 5'b0;
                rd_D = 5'b0;
                ALU_ctrl_D = NOP; // Default to NOP
                branch = BNT; // Not used in default

            end
        endcase
        
    end
endmodule
