module miniRV_SoC (
    input           fpga_rst,   // High active
    input           fpga_clk,

    output          debug_wb_have_inst, // 当前时钟周期是否有指令写回 (对单周期CPU，可在复位后恒置1)
    output  [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意值)
    output          debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意值)
    output  [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output  [31:0]  debug_wb_value      // 指令写回时，写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

    wire    [31:0]      imem_data   ;
    wire    [31:0]      dmem_rdata   ;
    wire    [31:0]      imem_addr   ;
    wire    [31:0]      dmem_addr   ;
    wire    [31:0]      dmem_wdata  ;
    wire                dmem_wen     ;
    wire    [2:0]       mask        ;
    

    CPU_CORE_TOP u_core (
        .clk             (fpga_clk),  
        .rst_n           (!fpga_rst),
        .imem_data       (imem_data),
        .dmem_rdata      (dmem_rdata),
        .imem_addr       (imem_addr),
        .dmem_addr       (dmem_addr),
        .dmem_wdata      (dmem_wdata),
        .mask            (mask),
        .dmem_wen        (dmem_wen),

        .debug_wb_have_inst  (debug_wb_have_inst),
        .debug_wb_pc     (debug_wb_pc),
        .debug_wb_ena    (debug_wb_ena),
        .debug_wb_reg    (debug_wb_reg),
        .debug_wb_value  (debug_wb_value)
    );

    dram_driver dram_driver_inst(
        .clk		        (fpga_clk),       
        .perip_addr	        (dmem_addr[17:0]),
        .perip_wdata        (dmem_wdata),
        .perip_mask	        (mask),
        .dram_wen           (dmem_wen),
        .perip_rdata        (dmem_rdata)
    );
    
    // 下面两个模块，只需要实例化代码和连线代码，不需要创建IP核
    IROM Mem_IROM (
        .a          (imem_addr[15:0]),
        .spo        (imem_data)
    );
/*
    DRAM Mem_DRAM (
        .clk        (fpga_clk),
        .a          (dmem_addr[17:2]),
        .spo        (dmem_rdata),
        .we         (dmem_wen),
        .d          (dmem_wdata)
    );
*/
endmodule