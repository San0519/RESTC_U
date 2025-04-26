`timescale 1ns / 1ps

module CPU_TestTop;

    // === 时钟与复位 ===
    reg clk;
    reg rst_n;

    // === 中间信号定义 ===
    wire [31:0] imem_data;
    wire [31:0] dmem_data;
    wire [31:0] imem_addr;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire        dmem_we;
    wire [2:0]  dmem_type;

    // === 实例化 DUT ===
    CPU_CORE_TOP u_CPU (
        .clk(clk),
        .rst_n(rst_n),
        .imem_data(imem_data),
        .dmem_data(dmem_data),
        .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_we(dmem_we),
        .dmem_type(dmem_type)
    );

    // === 实例化 IMEM ===
    IMEM u_IMEM (
        .PC(imem_addr),
        .instruction(imem_data)
    );

    // === 实例化 DMEM ===
    DMEM u_DMEM (
        .clk(clk),
        .rst_n(rst_n),
        .mem_we(dmem_we),
        .mem_type(dmem_type),
        .addr(dmem_addr),
        .wdata(dmem_wdata),
        .rdata(dmem_data)
    );

    // === 时钟生成 ===
    initial clk = 0;
    always #5 clk = ~clk; // 10ns 周期

    // === 初始化过程 ===
    initial begin
        $display("---- Begin Simulation ----");
        rst_n = 0;
        #25;
        rst_n = 1;
    end


    // === 仿真时间限制 ===
    initial begin
        #250;
        $finish;
    end

endmodule
