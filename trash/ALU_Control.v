`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 12:32:58 AM
// Design Name: 
// Module Name: ALU_Control
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


module ALU_Control(ALUOp,fun7,fun3,Control_out);
input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] Control_out;

always @(*) begin
    case ({ALUOp,fun7,fun3})
    6'b00_0_000: Control_out<=4'b0010;
    6'b01_0_000: Control_out<=4'b0110;
    6'b10_0_000: Control_out<=4'b0010;
    6'b10_1_000: Control_out<=4'b0110;
    6'b10_0_111: Control_out<=4'b0000;
    6'b10_0_110: Control_out<=4'b0001;
    endcase
end
endmodule
