`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 16:01:31
// Design Name: 
// Module Name: LSU
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
module LSU(
    input       [31:0]   Rdata_M,
    input       [2:0]   ls_type_M,
    output reg  [31:0]   Rdata_ext_M

);

    localparam LB        =  3'b000;
    localparam LH        =  3'b001;
    localparam LW        =  3'b010;
    localparam LBU       =  3'b100;
    localparam LHU       =  3'b101;

    always@(*)
    begin
        case(ls_type_M)
            LB:begin // LB
                Rdata_ext_M = {{24{Rdata_M[7]}},Rdata_M[7:0]};
            end
            LH:begin // LH
                Rdata_ext_M = {{16{Rdata_M[15]}},Rdata_M[15:0]};
            end
            LW:begin // LW
                Rdata_ext_M = Rdata_M;
            end
            LBU:begin // LBU
                Rdata_ext_M = {24'b0,Rdata_M[7:0]};
            end
            LHU:begin // LHU
                Rdata_ext_M = {16'b0,Rdata_M[15:0]};
            end
            default:begin
                Rdata_ext_M = Rdata_M;
            end
        endcase
    end

endmodule