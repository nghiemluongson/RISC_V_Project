`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 12:49:16 AM
// Design Name: 
// Module Name: top
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


module top(clk,reset);
input clk,reset;

wire [31:0] PC_top,instruction_top,Rd1_top,Rd2_top,ImmExt_top,mux1_top,sum_out_top,nextToPC_top,PCin_top,address_top,Memdata_top,WriteBack_top;
wire RegWrite_top,ALUSrc_top,branch_top,zero_top,sel2_top,MemToReg_top,MemWrite_top,MemRead_top;
wire [1:0] ALUOp_top;
wire [3:0] control_top;

// PC
Program_Counter PC(.clk(clk),.reset(reset),.PC_in(PCin_top),.PC_out(PC_top));

// PC adder
PC_Plus_4 PC_Adder(.fromPC(PC_top),.nextToPC(nextToPC_top));

// IM
Instruction_Memory Instr_Memory(.clk(clk),.reset(reset),.read_address(PC_top),.instruction_out(instruction_top));

// RF
Register_File Reg_File(.clk(clk),.reset(reset),.RegWrite(RegWrite_top),.Rs1(instruction_top[19:15]),.Rs2(instruction_top[24:20]),.Rd(instruction_top[11:7]),.Write_data(WriteBack_top),.read_data1(Rd1_top),.read_data2(Rd2_top));

// IG
Immediate_Generator ImmGen(.opcode(instruction_top[6:0]),.instruction(instruction_top),.ImmExt(ImmExt_top));

// CU
Control_Unit Control_Unit(.instruction(instruction_top[6:0]),.Branch(branch_top),.MemRead(MemRead_top),.MemToReg(MemToReg_top),.ALUOp(ALUOp_top),.MemWrite(MemWrite_top),.ALUSrc(ALUSrc_top),.RegWrite(RegWrite_top));

// ALU Control
ALU_Control ALU_Control(.ALUOp(ALUOp_top),.fun7(instruction_top[30]),.fun3(instruction_top[14:12]),.Control_out(control_top));

// ALU
ALU ALU(.A(Rd1_top),.B(mux1_top),.Control_in(control_top),.ALU_Result(address_top),.zero(zero_top));

// ALU mux
Mux1 ALU_Mux(.sel1(ALUSrc_top),.A1(Rd2_top),.B1(ImmExt_top),.Mux1_out(mux1_top));

// Adder
Adder Adder(.in_1(PC_top),.in_2(ImmExt_top),.sum_out(sum_out_top));

// AND
AND_Logic AND(.branch(branch_top),.zero(zero_top),.and_out(sel2_top));

// mux
Mux2 Adder_Mux(.sel2(sel2_top),.A2(nextToPC_top),.B2(sum_out_top),.Mux2_out(PCin_top));

// DM
Data_Memory Data_Memory(.clk(clk),.reset(reset),.MemWrite(MemWrite_top),.MemRead(MemRead_top),.read_address(address_top),.Write_data(Rd2_top),.MemData_out(Memdata_top));

// mux
Mux3 Memory_mux(.sel3(MemToReg_top),.A3(address_top),.B3(Memdata_top),.Mux3_out(WriteBack_top));

endmodule
