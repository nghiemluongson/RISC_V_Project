`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 11:56:03 PM
// Design Name: 
// Module Name: Instruction_Memory
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


module Instruction_Memory(clk,reset,read_address,instruction_out);

input clk,reset;
input [31:0] read_address;
output [31:0] instruction_out;

reg [31:0] I_Mem[63:0];
integer k;
assign instruction_out = I_Mem[read_address];

always @(posedge clk or posedge reset) begin
    if (reset) 
        begin
            for(k=0;k<64;k=k+1) begin
                I_Mem[k]<=32'b00;
                end
            end
     else
           //instruction_out<=I_Mem[read_address];
           // R-type
           I_Mem[0]  = 32'b00000000000000000000000000000000;  // no operation
           I_Mem[4]  = 32'b00000000011001010000011001011001;  // add x13, x16, x25
           I_Mem[8]  = 32'b00100000000110000000001000011001;  // sub x5, x8, x3
           I_Mem[12] = 32'b00000000001100010111000010110011;  // and x1, x2, x3
           I_Mem[16] = 32'b0000000001010001110000101001011;   // or x4, x3, x5
           
           // I-type
           I_Mem[20] = 32'b00000000001110101000101110010011;  // addi x22, x21, 3
           I_Mem[24] = 32'b0000000000010100011000010010011;   // ori x9, x8, 1
           
           // L-type
           I_Mem[28] = 32'b00000000111100101001010100000011;  // lw x8, 15(x5)
           I_Mem[32] = 32'b00000000110000110100001000000011;  // lw x9, 3(x3)
           
           // S-type
           I_Mem[36] = 32'b00000000111100101001011000001011;  // sw x15, 12(x5)
           I_Mem[40] = 32'b00000000111000100101010000001011;  // sw x14, 10(x6)
           
           // SB-type
           I_Mem[44] = 32'h00948663;                         // beq x9, x9, 12

end
endmodule
