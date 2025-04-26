module ImmExtend (
    input       [31:0] instruction,
    input       [1:0]  sext_type,     // 类型选择信号
    output reg  [31:0] imm_D
);

    // 定义立即数类型
    localparam EXT_I     = 2'b00;  // I-type,JALR,Load,Store.
    localparam EXT_B     = 2'b01;  // B-type: BEQ, etc.
    localparam EXT_U     = 2'b10;  // U-type: LUI, AUIPC
    localparam EXT_JAL   = 2'b11;  // J-type: JAL

    always @(*) begin
        case (sext_type)
            EXT_I: begin//
                // imm[11:0], sign-extended
                imm_D = {{20{instruction[31]}}, instruction[31:20]};
            end

            EXT_B: begin//
                // {imm[12], imm[10:5], imm[4:1], imm[11], 0}, sign-extended
                imm_D = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end

            EXT_U: begin//
                // imm[31:12] << 12 (already aligned), sign-extended
                imm_D = {instruction[31:12], 12'b0};
            end

            EXT_JAL: begin//
                // {imm[20], imm[10:1], imm[11], imm[19:12], 0}, sign-extended
                imm_D = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end

            default: begin
                imm_D = {{20{instruction[31]}}, instruction[31:20]};
            end

        endcase
    end

endmodule
