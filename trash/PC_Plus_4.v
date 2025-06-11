`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 11:53:58 PM
// Design Name: 
// Module Name: PC_Plus_4
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


module PC_Plus_4(fromPC,nextToPC);
input [31:0] fromPC;
output [31:0] nextToPC;

assign nextToPC=fromPC+4;
endmodule
