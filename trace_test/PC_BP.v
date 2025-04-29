`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/13 16:01:31
// Design Name: 
// Module Name: PC(Branch Prediction Version), using 2-bit saturating counter
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

module PC_BP (
    input                   clk,
    input                   rst_n,
    input                   stall_F,
    input                   PC_src,
    input           [31:0]  pred_target,// PC source0, predicted target address
    input           [31:0]  PC_target_D,//PC source1,calculated branch target address
    output          [31:0]  PC_next,// next PC address
    output reg      [31:0]  PC_F// the selected PC address
    
);

    assign PC_next = pred_target; // PC_next is the predicted target address
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            PC_F <= 32'h0000_0000; // Reset PC to 0
        end
        else if(stall_F)begin // If stall signal is high, keep PC unchanged
            PC_F <= PC_F;
        end
        else begin
            if(PC_src)begin // If branch or jump taken, update PC to target address
                PC_F <= PC_target_D;
            end
            else begin // Otherwise, increment PC by 4
                PC_F <= pred_target ;
            end
        end
    end

endmodule