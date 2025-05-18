`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/12 16:01:31
// Design Name: 
// Module Name: PC(always not taken version)
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Used for Updating PC
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PC (
    input                   clk,
    input                   rst_n,
    input                   stall_F,
    input                   PC_src,
    input           [31:0]  PC_Plus4,// PC source0, always not taken version, PC_Plus4 is always PC + 4
    input           [31:0]  PC_target_D,//PC source1, branch target address
    output          [31:0]  PC_next,// next PC address
    output reg      [31:0]  PC_F// the selected PC address
    
);

    assign PC_next = PC_F + 4; // PC_next is always PC + 4
    //assign PC_next = PC_F + 1;
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            PC_F <= 32'h8000_0000; // Reset PC to 0
        end
        else if(stall_F)begin // If stall signal is high, keep PC unchanged
            PC_F <= PC_F;
        end
        else begin
            if(PC_src)begin // If branch or jump taken, update PC to target address
                PC_F <= PC_target_D;
            end
            else begin // Otherwise, increment PC by 4
                PC_F <= PC_Plus4 ;
            end
        end
    end

    
endmodule