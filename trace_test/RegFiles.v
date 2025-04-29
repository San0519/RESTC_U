//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/15 17:49:38
// Design Name: 
// Module Name: Reg(ister) Files
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
module RegFiles(
    input               clk,
    input               rst_n,
    input       [4:0]   rs1_D, //read address 1
    input       [4:0]   rs2_D, //read address 2
    input       [4:0]   rd_W,  //write address
    input       [31:0]  Wdata,//write data
    input               we_reg_W,//write enable
    output      [31:0]  rdata1_D,//read data 1
    output      [31:0]  rdata2_D//read data 2
    );
    
    reg [31:0] Regs[31:0];//32 registers
    
    integer i;
    
    always @(posedge clk ) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                Regs[i] <= 32'b0;
            end
        end else 
            begin 
                Regs[0] <= 32'b0;//x0 always 0
                if (we_reg_W && rd_W != 5'b0) begin//write to register except x0
                    Regs[rd_W] <= Wdata;
                end
            end
    end

    assign rdata1_D = (rs1_D == 5'b0) ? 32'b0 : Regs[rs1_D];//read register 1
    assign rdata2_D = (rs2_D == 5'b0) ? 32'b0 : Regs[rs2_D];//read register 2


endmodule