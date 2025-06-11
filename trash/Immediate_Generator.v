`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 12:09:02 AM
// Design Name: 
// Module Name: Immediate_Generator
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


module Immediate_Generator(opcode,instruction,ImmExt);

input [6:0] opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;

always @(*) begin
    case(opcode)
        7'b0000011: ImmExt <= {{20{instruction[31]}},instruction[31:20]};
        7'b0100011: ImmExt <= {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
        7'b1100011: ImmExt <= {{19{instruction[31]}},instruction[31],instruction[30:25],instruction[11:8],1'b0};
    endcase
end

endmodule
