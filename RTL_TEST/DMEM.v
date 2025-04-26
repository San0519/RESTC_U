module DMEM #(parameter DMEM_SIZE = 1024) (
    input              clk,
    input              rst_n,
    input              mem_we,
    input      [2:0]   mem_type,     // 000: SB, 001: SH, 010: SW
    input      [31:0]  addr,
    input      [31:0]  wdata,
    output reg [31:0]  rdata
);

    reg [7:0] memory [0:DMEM_SIZE-1];

    integer i;

    // 同步写和复位清零
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DMEM_SIZE; i = i + 1)
                memory[i] <= 8'b0;
        end
        else if (mem_we) begin
            case (mem_type)
                3'b000: memory[addr]     <= wdata[7:0];       // SB
                3'b001: begin                                  // SH
                    memory[addr]     <= wdata[7:0];
                    memory[addr + 1] <= wdata[15:8];
                end
                3'b010: begin                                  // SW
                    memory[addr]     <= wdata[7:0];
                    memory[addr + 1] <= wdata[15:8];
                    memory[addr + 2] <= wdata[23:16];
                    memory[addr + 3] <= wdata[31:24];
                end
                default: ; // Do nothing
            endcase
        end
    end

    // 异步读取（组合逻辑读取4字节）
    always @(*) begin
        rdata = { memory[addr + 3],
                  memory[addr + 2],
                  memory[addr + 1],
                  memory[addr + 0] };
    end

endmodule
