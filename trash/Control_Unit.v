`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 12:18:21 AM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(instruction,Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite);
input [6:0] instruction;
output reg Branch,MemRead,MemToReg,MemWrite,ALUSrc,RegWrite;
output reg [1:0] ALUOp;

always @(*) begin
    case (instruction)
        7'b0110011: {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} <= 8'b001000_10;
        7'b0000011: {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} <= 8'b111100_00;
        7'b0100011: {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} <= 8'b100010_00;
        7'b1100011: {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} <= 8'b000001_01;
    endcase
end
endmodule
