`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 11:50:47 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(clk,reset,PC_in,PC_out);

input clk,reset;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @(posedge clk or posedge reset) begin 
    if (reset) 
        PC_out<=32'b00;
    else
        PC_out<=PC_in;
end

endmodule
