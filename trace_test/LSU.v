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
    input       [31:0]   write_data_M,
    input       [3:0]    ls_type_M,
    output  reg [31:0]   Rdata_ext_M,
    output  reg [31:0]   write_data_Masked,
    output  reg [1:0]    we

);


    localparam LB        =  4'b0000;
    localparam LH        =  4'b0010;
    localparam LW        =  4'b0100;
    localparam LBU       =  4'b1000;
    localparam LHU       =  4'b1010;
    localparam SB        =  4'b0001;
    localparam SH        =  4'b0011;
    localparam SW        =  4'b0101;

    always@(*)
    begin
        case(ls_type_M)
            LB:begin // LB
                Rdata_ext_M = {{24{Rdata_M[7]}},Rdata_M[7:0]};
                write_data_Masked= 0;
                we=2'b00;
            end
            LH:begin // LH
                Rdata_ext_M = {{16{Rdata_M[15]}},Rdata_M[15:0]};
                write_data_Masked= 0;
                we=2'b01;
            end
            LW:begin // LW
                Rdata_ext_M = Rdata_M;
                write_data_Masked= 0;
                we=2'b10;
            end
            LBU:begin // LBU
                Rdata_ext_M = {24'b0,Rdata_M[7:0]};
                write_data_Masked= 0;
                we=2'b00;
            end
            LHU:begin // LHU
                Rdata_ext_M = {16'b0,Rdata_M[15:0]};
                write_data_Masked= 0;
                we=2'b01;
            end
            SB:begin // SB
                Rdata_ext_M = 0;
                write_data_Masked= {24'b0,write_data_M[7:0]};
                we=2'b00;
            end
            SH:begin // SH
                Rdata_ext_M = 0;
                write_data_Masked= {16'b0,write_data_M[15:0]};
                we=2'b01;
            end
            SW:begin // SW
                Rdata_ext_M = 0;
                write_data_Masked= write_data_M;
                we=2'b10;
            end
            default:begin
                Rdata_ext_M = 0;
                write_data_Masked= 0;
                we=2'b11;
            end
        endcase
        
    end

endmodule