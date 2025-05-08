//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: CPU_CORE_TOP
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

module CPU_CORE_TOP(
    input               clk             ,
    input               rst_n           ,
    input       [31:0]  imem_data       ,
    input       [31:0]  dmem_rdata       ,
    output      [31:0]  imem_addr       ,
    output      [31:0]  dmem_addr       ,
    output      [31:0]  dmem_wdata      ,
    output      [1:0]   mask            ,
    output              dmem_we         ,
    //debug ports
    output              debug_wb_have_inst,
    output      [31:0]  debug_wb_pc     ,
    output              debug_wb_ena    ,
    output      [4:0]   debug_wb_reg    ,
    output      [31:0]  debug_wb_value  
);
    
    wire [31:0] PC_F;
    wire [31:0] PC_D;
    wire [31:0] PC_E;
    wire [31:0] PC_M;
    wire [31:0] PC_W;
    wire [31:0] PC_next;
    wire [31:0] PC_target_D;
    wire [31:0] instruction_D;
    wire [4:0] rs1_D;
    wire [4:0] rs2_D;
    wire [4:0] rd_D;
    wire [3:0] ALU_ctrl_D;
    wire [2:0] branch;
    wire [3:0] ls_type_D; 
    wire [2:0] sext_type;
    wire [1:0] wb_ctrl_D;
    wire [31:0] WB_data;
    wire [31:0] rdata1_D;
    wire [31:0] rdata2_D;
    wire [31:0] imm_D;
    wire [31:0] ALU_result_E;
    wire [31:0] ALU_result_M;
    wire [1:0] forward_A_D;
    wire [1:0] forward_B_D;
    wire [1:0] forward_A_E;
    wire [1:0] forward_B_E;
    wire [31:0] rdata1_E;
    wire [31:0] rdata2_E;
    wire [4:0] rd_E;
    wire [31:0] imm_E;
    wire [1:0] wb_ctrl_E;
    wire [3:0] ALU_ctrl_E;
    wire [2:0] ls_type_E;
    wire [4:0] rs1_E;
    wire [4:0] rs2_E;
    wire [31:0] write_data_E;
    wire [31:0] write_data_M;
    wire [4:0] rd_M;
    wire [1:0] wb_ctrl_M;
    wire [2:0] ls_type_M; 
    wire [31:0] Rdata_ext_M;
    wire [31:0] ALU_result_W; 
    wire [31:0] Rdata_W;
    wire [4:0] rd_W;
    wire [1:0] wb_ctrl_W;

    reg [3:0] wb_inst_delay;
    wire wb_inst_have_flag;

    //debug ports assignment
    assign debug_wb_have_inst = (we_reg_W || wb_inst_delay[2]);
    assign debug_wb_pc = PC_W * 4;
    assign debug_wb_ena = we_reg_W;
    assign debug_wb_reg = rd_W;
    assign debug_wb_value = WB_data;

    always @(posedge clk)   begin
        if(!rst_n)    begin
            wb_inst_delay <= 2'b0;
        end
        else begin
            wb_inst_delay[0] <= (branch != 3'b010) | wb_inst_have_flag;
            wb_inst_delay[1] <= wb_inst_delay[0];
            wb_inst_delay[2] <= wb_inst_delay[1];
            //wb_inst_delay[3] <= wb_inst_delay[2];
        end
    end

    assign imem_addr = PC_F;
    assign dmem_addr = ALU_result_M;
    assign dmem_wdata = write_data_Masked;
    assign dmem_we = we_mem_M;
    assign mask = we;
    //assign dmem_type = ls_type_M;

                    /*  Instruction Fetch(IF) Stage    */
    //PC module
    wire [31:0] PC_Plus4;
    

    PC u_PC(
        .clk(clk),
        .rst_n(rst_n),
        .stall_F(stall_F),
        .PC_src(PC_src_D),
        .PC_Plus4(PC_Plus4),
        .PC_target_D(PC_target_D),
        .PC_next(PC_next),
        .PC_F(PC_F)
    );
    assign PC_Plus4 = PC_next; // PC_Plus4 is always PC + 4(always not taken version)
    /* Branch Prediction Version PC
    PC_BP u_PC_BP(
        .clk(clk),
        .rst_n(rst_n),
        .stall_F(stall_F),
        .PC_src(PC_src_D),
        .pred_target(pred_target),
        .PC_target_D(PC_target_D),
        .PC_next(PC_next),
        .PC_F(PC_F)
    );
        //Branch Prediction Unit(BPU)
    BPU u_BPU(
        .clk(clk),
        .rst_n(rst_n),
        .PC_F(PC_F),
        .pred_jump_F(pred_jump_F),
        .pred_target(pred_target),
        .PC_src_D(PC_src_D),
        .PC_D(PC_D),
        .real_target(PC_Target_D)
    );
    */
    //IF_ID pipeline register
    IF_ID u_IF_ID(
        .clk(clk),
        .rst_n(rst_n),
        .stall_D(stall_D),
        .flush_D(flush_D),
        .PC_F(PC_F),
        .imem_data(imem_data),
        .PC_D(PC_D),
        .instruction_D(instruction_D)
    );


                    /*  Instruction Decode(ID) Stage    */
    //Decoder
    Decoder u_Decoder(
        .instruction_D(instruction_D),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_D(rd_D),
        .ALU_ctrl_D(ALU_ctrl_D),
        .branch(branch),
        .ls_type_D(ls_type_D),//load/store type
        .sext_type(sext_type),
        .wb_ctrl_D(wb_ctrl_D),
        .jump(jump),
        .jump_type(jump_type),
        .ALU_src1_D(ALU_src1_D),
        .ALU_src2_D(ALU_src2_D),
        .we_reg_D(we_reg_D),
        .we_mem_D(we_mem_D),
        .wb_inst_have_flag(wb_inst_have_flag)
    );

    //RegisterFile(RegFiles)
    RegFiles u_RegFiles(
        .clk(clk),
        .rst_n(rst_n),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_W(rd_W),//修改
        .Wdata(WB_data),
        .we_reg_W(we_reg_W),
        .rdata1_D(rdata1_D),
        .rdata2_D(rdata2_D)
    );

    //Branch Jump Unit(BJU)
    BJU u_BJU(
        .PC_D(PC_D),
        .rs1_D(rdata1_D),
        .rs2_D(rdata2_D),
        .imm_D(imm_D),
        .ALU_result_M(ALU_result_M),
        .ALU_result_E(ALU_result_E),
        .WB_data(WB_data),//修改
        .branch(branch),
        .forward_A_D(forward_A_D),
        .forward_B_D(forward_B_D),
        .jump(jump),
        .jump_type(jump_type),
        .PC_Target_D(PC_target_D),
        .PC_src_D(PC_src_D)
    );

    //SignExtend(Sext)
    ImmExtend u_Sext(
        .instruction(instruction_D),
        .sext_type(sext_type),
        .imm_D(imm_D)
    );

    //ID_EX pipeline register
ID_EX u_ID_EX(
        .clk(clk),
        .rst_n(rst_n),
        .flush_E(flush_E),
        .PC_D(PC_D),
        .rdata1_D(rdata1_D),
        .rdata2_D(rdata2_D),
        .WB_data(WB_data),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_D(rd_D),
        .wb_ctrl_D(wb_ctrl_D),
        .ALU_ctrl_D(ALU_ctrl_D),
        .ALU_src1_D(ALU_src1_D),
        .ALU_src2_D(ALU_src2_D),
        .we_reg_D(we_reg_D),
        .we_mem_D(we_mem_D),
        .ls_type_D(ls_type_D),
        .imm_D(imm_D),
        .forward_1_D(forward_1_D),
        .forward_2_D(forward_2_D),

        .PC_E(PC_E),
        .rdata1_E(rdata1_E),
        .rdata2_E(rdata2_E),
        .rd_E(rd_E),   
        .imm_E(imm_E),
        .wb_ctrl_E(wb_ctrl_E),
        .ALU_ctrl_E(ALU_ctrl_E),
        .ALU_src1_E(ALU_src1_E),
        .ALU_src2_E(ALU_src2_E),
        .we_reg_E(we_reg_E),
        .we_mem_E(we_mem_E),
        .ls_type_E(ls_type_E),
        .rs1_E(rs1_E),
        .rs2_E(rs2_E)
    );



                    /*  Execute(EX) Stage    */
    //Eexecute Module
    ExecuteModule u_EexecuteModule(
        .rdata1_E(rdata1_E),
        .rdata2_E(rdata2_E),
        .imm_E(imm_E),
        .PC_E(PC_E),
        .ALU_result_M(ALU_result_M),
        .WB_data(WB_data),
        .forward_A_E(forward_A_E),
        .forward_B_E(forward_B_E),
        .ALU_ctrl_E(ALU_ctrl_E),
        .ALU_src1_E(ALU_src1_E),
        .ALU_src2_E(ALU_src2_E),
        .ALU_result_E(ALU_result_E),
        .write_data_E(write_data_E)
    );

    //EX_ME pipeline register
    EX_ME u_EX_ME(
        .clk(clk),
        .rst_n(rst_n),
        .ALU_result_E(ALU_result_E),
        .write_data_E(write_data_E),
        .rd_E(rd_E),
        .wb_ctrl_E(wb_ctrl_E),
        .we_reg_E(we_reg_E),
        .we_mem_E(we_mem_E),
        .ls_type_E(ls_type_E),
        .PC_E(PC_E),

        .ALU_result_M(ALU_result_M),
        .write_data_M(write_data_M),
        .rd_M(rd_M),   
        .wb_ctrl_M(wb_ctrl_M),
        .we_reg_M(we_reg_M),
        .we_mem_M(we_mem_M),
        .ls_type_M(ls_type_M),
        .PC_M(PC_M)
    );


                    /*  Memory Access(ME) Stage    */
    //Load Store Unit(LSU)
    LSU u_LSU(
        .Rdata_M(dmem_data),
        .ls_type_M(ls_type_M),
        .write_data_M(write_data_M),
        .Rdata_ext_M(Rdata_ext_M),
        .write_data_Masked(write_data_Masked),
        .we(we)
    );

    //ME_WB pipeline register
    ME_WB u_ME_WB(
        .clk(clk),
        .rst_n(rst_n),
        .ALU_result_M(ALU_result_M),
        .Rdata_ext_M(Rdata_ext_M),
        .rd_M(rd_M),
        .wb_ctrl_M(wb_ctrl_M),
        .PC_M(PC_M),
        .we_reg_M(we_reg_M),

        .ALU_result_W(ALU_result_W),
        .Rdata_W(Rdata_W),
        .rd_W(rd_W),   
        .wb_ctrl_W(wb_ctrl_W),
        .PC_W(PC_W),
        .we_reg_W(we_reg_W)
    );


                    /*  Write Back(WB) Stage    */
    //Write Back
    WB u_WB(
        .ALU_result_W(ALU_result_W),
        .Rdata_W(Rdata_W),
        .PC_W(PC_W),
        .wb_ctrl_W(wb_ctrl_W),
        .WB_data(WB_data)
    );
                    /*  Non-Pipelined Module    */
    //Amendment Logic
Dependence_Stall u_Dependence_Stall(
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rs1_E(rs1_E),
        .rs2_E(rs2_E),
        .rd_E(rd_E),
        .rd_M(rd_M),
        .rd_W(rd_W),
        .wb_ctrl_E(wb_ctrl_E),
        .wb_ctrl_M(wb_ctrl_M),
        .branch(branch),
        .we_reg_E(we_reg_E),
        .we_reg_M(we_reg_M),
        .we_reg_W(we_reg_W),
        .PC_src_D(PC_src_D),
        .stall_F(stall_F),
        .stall_D(stall_D),
        .flush_D(flush_D),
        .flush_E(flush_E),
        .forward_A_D(forward_A_D),
        .forward_B_D(forward_B_D),
        .forward_A_E(forward_A_E),
        .forward_B_E(forward_B_E),
        .forward_1_D(forward_1_D),
        .forward_2_D(forward_2_D)
    );

endmodule
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: CPU_CORE_TOP
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

module CPU_CORE_TOP(
    input               clk             ,
    input               rst_n           ,
    input       [31:0]  imem_data       ,
    input       [31:0]  dmem_rdata       ,
    output      [31:0]  imem_addr       ,
    output      [31:0]  dmem_addr       ,
    output      [31:0]  dmem_wdata      ,
    output      [1:0]   mask            ,
    output              dmem_we         ,
    //debug ports
    output              debug_wb_have_inst,
    output      [31:0]  debug_wb_pc     ,
    output              debug_wb_ena    ,
    output      [4:0]   debug_wb_reg    ,
    output      [31:0]  debug_wb_value  
);
    
    wire [31:0] PC_F;
    wire [31:0] PC_D;
    wire [31:0] PC_E;
    wire [31:0] PC_M;
    wire [31:0] PC_W;
    wire [31:0] PC_next;
    wire [31:0] PC_target_D;
    wire [31:0] instruction_D;
    wire [4:0] rs1_D;
    wire [4:0] rs2_D;
    wire [4:0] rd_D;
    wire [3:0] ALU_ctrl_D;
    wire [2:0] branch;
    wire [3:0] ls_type_D; 
    wire [2:0] sext_type;
    wire [1:0] wb_ctrl_D;
    wire [31:0] WB_data;
    wire [31:0] rdata1_D;
    wire [31:0] rdata2_D;
    wire [31:0] imm_D;
    wire [31:0] ALU_result_E;
    wire [31:0] ALU_result_M;
    wire [1:0] forward_A_D;
    wire [1:0] forward_B_D;
    wire [1:0] forward_A_E;
    wire [1:0] forward_B_E;
    wire [31:0] rdata1_E;
    wire [31:0] rdata2_E;
    wire [4:0] rd_E;
    wire [31:0] imm_E;
    wire [1:0] wb_ctrl_E;
    wire [3:0] ALU_ctrl_E;
    wire [2:0] ls_type_E;
    wire [4:0] rs1_E;
    wire [4:0] rs2_E;
    wire [31:0] write_data_E;
    wire [31:0] write_data_M;
    wire [4:0] rd_M;
    wire [1:0] wb_ctrl_M;
    wire [2:0] ls_type_M; 
    wire [31:0] Rdata_ext_M;
    wire [31:0] ALU_result_W; 
    wire [31:0] Rdata_W;
    wire [4:0] rd_W;
    wire [1:0] wb_ctrl_W;

    reg [3:0] wb_inst_delay;
    wire wb_inst_have_flag;

    //debug ports assignment
    assign debug_wb_have_inst = (we_reg_W || wb_inst_delay[2]);
    assign debug_wb_pc = PC_W * 4;
    assign debug_wb_ena = we_reg_W;
    assign debug_wb_reg = rd_W;
    assign debug_wb_value = WB_data;

    always @(posedge clk)   begin
        if(!rst_n)    begin
            wb_inst_delay <= 2'b0;
        end
        else begin
            wb_inst_delay[0] <= (branch != 3'b010) | wb_inst_have_flag;
            wb_inst_delay[1] <= wb_inst_delay[0];
            wb_inst_delay[2] <= wb_inst_delay[1];
            //wb_inst_delay[3] <= wb_inst_delay[2];
        end
    end

    assign imem_addr = PC_F;
    assign dmem_addr = ALU_result_M;
    assign dmem_wdata = write_data_Masked;
    assign dmem_we = we_mem_M;
    assign mask = we;
    //assign dmem_type = ls_type_M;

                    /*  Instruction Fetch(IF) Stage    */
    //PC module
    wire [31:0] PC_Plus4;
    

    PC u_PC(
        .clk(clk),
        .rst_n(rst_n),
        .stall_F(stall_F),
        .PC_src(PC_src_D),
        .PC_Plus4(PC_Plus4),
        .PC_target_D(PC_target_D),
        .PC_next(PC_next),
        .PC_F(PC_F)
    );
    assign PC_Plus4 = PC_next; // PC_Plus4 is always PC + 4(always not taken version)
    /* Branch Prediction Version PC
    PC_BP u_PC_BP(
        .clk(clk),
        .rst_n(rst_n),
        .stall_F(stall_F),
        .PC_src(PC_src_D),
        .pred_target(pred_target),
        .PC_target_D(PC_target_D),
        .PC_next(PC_next),
        .PC_F(PC_F)
    );
        //Branch Prediction Unit(BPU)
    BPU u_BPU(
        .clk(clk),
        .rst_n(rst_n),
        .PC_F(PC_F),
        .pred_jump_F(pred_jump_F),
        .pred_target(pred_target),
        .PC_src_D(PC_src_D),
        .PC_D(PC_D),
        .real_target(PC_Target_D)
    );
    */
    //IF_ID pipeline register
    IF_ID u_IF_ID(
        .clk(clk),
        .rst_n(rst_n),
        .stall_D(stall_D),
        .flush_D(flush_D),
        .PC_F(PC_F),
        .imem_data(imem_data),
        .PC_D(PC_D),
        .instruction_D(instruction_D)
    );


                    /*  Instruction Decode(ID) Stage    */
    //Decoder
    Decoder u_Decoder(
        .instruction_D(instruction_D),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_D(rd_D),
        .ALU_ctrl_D(ALU_ctrl_D),
        .branch(branch),
        .ls_type_D(ls_type_D),//load/store type
        .sext_type(sext_type),
        .wb_ctrl_D(wb_ctrl_D),
        .jump(jump),
        .jump_type(jump_type),
        .ALU_src1_D(ALU_src1_D),
        .ALU_src2_D(ALU_src2_D),
        .we_reg_D(we_reg_D),
        .we_mem_D(we_mem_D),
        .wb_inst_have_flag(wb_inst_have_flag)
    );

    //RegisterFile(RegFiles)
    RegFiles u_RegFiles(
        .clk(clk),
        .rst_n(rst_n),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_W(rd_W),//修改
        .Wdata(WB_data),
        .we_reg_W(we_reg_W),
        .rdata1_D(rdata1_D),
        .rdata2_D(rdata2_D)
    );

    //Branch Jump Unit(BJU)
    BJU u_BJU(
        .PC_D(PC_D),
        .rs1_D(rdata1_D),
        .rs2_D(rdata2_D),
        .imm_D(imm_D),
        .ALU_result_M(ALU_result_M),
        .ALU_result_E(ALU_result_E),
        .WB_data(WB_data),//修改
        .branch(branch),
        .forward_A_D(forward_A_D),
        .forward_B_D(forward_B_D),
        .jump(jump),
        .jump_type(jump_type),
        .PC_Target_D(PC_target_D),
        .PC_src_D(PC_src_D)
    );

    //SignExtend(Sext)
    ImmExtend u_Sext(
        .instruction(instruction_D),
        .sext_type(sext_type),
        .imm_D(imm_D)
    );

    //ID_EX pipeline register
ID_EX u_ID_EX(
        .clk(clk),
        .rst_n(rst_n),
        .flush_E(flush_E),
        .PC_D(PC_D),
        .rdata1_D(rdata1_D),
        .rdata2_D(rdata2_D),
        .WB_data(WB_data),
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rd_D(rd_D),
        .wb_ctrl_D(wb_ctrl_D),
        .ALU_ctrl_D(ALU_ctrl_D),
        .ALU_src1_D(ALU_src1_D),
        .ALU_src2_D(ALU_src2_D),
        .we_reg_D(we_reg_D),
        .we_mem_D(we_mem_D),
        .ls_type_D(ls_type_D),
        .imm_D(imm_D),
        .forward_1_D(forward_1_D),
        .forward_2_D(forward_2_D),

        .PC_E(PC_E),
        .rdata1_E(rdata1_E),
        .rdata2_E(rdata2_E),
        .rd_E(rd_E),   
        .imm_E(imm_E),
        .wb_ctrl_E(wb_ctrl_E),
        .ALU_ctrl_E(ALU_ctrl_E),
        .ALU_src1_E(ALU_src1_E),
        .ALU_src2_E(ALU_src2_E),
        .we_reg_E(we_reg_E),
        .we_mem_E(we_mem_E),
        .ls_type_E(ls_type_E),
        .rs1_E(rs1_E),
        .rs2_E(rs2_E)
    );



                    /*  Execute(EX) Stage    */
    //Eexecute Module
    ExecuteModule u_EexecuteModule(
        .rdata1_E(rdata1_E),
        .rdata2_E(rdata2_E),
        .imm_E(imm_E),
        .PC_E(PC_E),
        .ALU_result_M(ALU_result_M),
        .WB_data(WB_data),
        .forward_A_E(forward_A_E),
        .forward_B_E(forward_B_E),
        .ALU_ctrl_E(ALU_ctrl_E),
        .ALU_src1_E(ALU_src1_E),
        .ALU_src2_E(ALU_src2_E),
        .ALU_result_E(ALU_result_E),
        .write_data_E(write_data_E)
    );

    //EX_ME pipeline register
    EX_ME u_EX_ME(
        .clk(clk),
        .rst_n(rst_n),
        .ALU_result_E(ALU_result_E),
        .write_data_E(write_data_E),
        .rd_E(rd_E),
        .wb_ctrl_E(wb_ctrl_E),
        .we_reg_E(we_reg_E),
        .we_mem_E(we_mem_E),
        .ls_type_E(ls_type_E),
        .PC_E(PC_E),

        .ALU_result_M(ALU_result_M),
        .write_data_M(write_data_M),
        .rd_M(rd_M),   
        .wb_ctrl_M(wb_ctrl_M),
        .we_reg_M(we_reg_M),
        .we_mem_M(we_mem_M),
        .ls_type_M(ls_type_M),
        .PC_M(PC_M)
    );


                    /*  Memory Access(ME) Stage    */
    //Load Store Unit(LSU)
    LSU u_LSU(
        .Rdata_M(dmem_rdata),
        .ls_type_M(ls_type_M),
        .write_data_M(write_data_M),
        .Rdata_ext_M(Rdata_ext_M),
        .write_data_Masked(write_data_Masked),
        .we(we)
    );

    //ME_WB pipeline register
    ME_WB u_ME_WB(
        .clk(clk),
        .rst_n(rst_n),
        .ALU_result_M(ALU_result_M),
        .Rdata_ext_M(Rdata_ext_M),
        .rd_M(rd_M),
        .wb_ctrl_M(wb_ctrl_M),
        .PC_M(PC_M),
        .we_reg_M(we_reg_M),

        .ALU_result_W(ALU_result_W),
        .Rdata_W(Rdata_W),
        .rd_W(rd_W),   
        .wb_ctrl_W(wb_ctrl_W),
        .PC_W(PC_W),
        .we_reg_W(we_reg_W)
    );


                    /*  Write Back(WB) Stage    */
    //Write Back
    WB u_WB(
        .ALU_result_W(ALU_result_W),
        .Rdata_W(Rdata_W),
        .PC_W(PC_W),
        .wb_ctrl_W(wb_ctrl_W),
        .WB_data(WB_data)
    );
                    /*  Non-Pipelined Module    */
    //Amendment Logic
Dependence_Stall u_Dependence_Stall(
        .rs1_D(rs1_D),
        .rs2_D(rs2_D),
        .rs1_E(rs1_E),
        .rs2_E(rs2_E),
        .rd_E(rd_E),
        .rd_M(rd_M),
        .rd_W(rd_W),
        .wb_ctrl_E(wb_ctrl_E),
        .wb_ctrl_M(wb_ctrl_M),
        .branch(branch),
        .we_reg_E(we_reg_E),
        .we_reg_M(we_reg_M),
        .we_reg_W(we_reg_W),
        .PC_src_D(PC_src_D),
        .stall_F(stall_F),
        .stall_D(stall_D),
        .flush_D(flush_D),
        .flush_E(flush_E),
        .forward_A_D(forward_A_D),
        .forward_B_D(forward_B_D),
        .forward_A_E(forward_A_E),
        .forward_B_E(forward_B_E),
        .forward_1_D(forward_1_D),
        .forward_2_D(forward_2_D)
    );
    
    ila_1 core_inner_ila (
	.clk(clk), // input wire clk

	.probe0(imem_data ), // input wire [31:0]  probe0  
	.probe1(dmem_rdata), // input wire [31:0]  probe1 
	.probe2(imem_addr ), // input wire [31:0]  probe2 
	.probe3(dmem_addr ), // input wire [31:0]  probe3 
	.probe4(dmem_wdata), // input wire [31:0]  probe4 
	.probe5(mask      ), // input wire [1:0]  probe5 
	.probe6(dmem_we   ) // input wire [0:0]  probe6
    );

endmodule