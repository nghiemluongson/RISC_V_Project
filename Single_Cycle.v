
// PC_Adder
module PCplus4(fromPC,NexttoPC);
input [31:0] fromPC;
output [31:0] NexttoPC;

assign NexttoPC=fromPC+32'h00000004;
endmodule

// Adder
module Adder(in_1,in_2,sum);
input [31:0] in_1,in_2;
output [31:0] sum;

assign sum=in_1+in_2;
endmodule

// PC
module Program_Counter(clk,reset,PC_in,PC_out);

input clk,reset;
input [31:0] PC_in;
output [31:0] PC_out;
reg [31:0] PC_out;

always @(posedge clk or posedge reset) begin 
    if (reset==1'b1) 
        PC_out<=0;
    else
        PC_out<=PC_in;
end

endmodule

// IM
module Instruction_Memory(clk,reset,read_address,instruction_out);

input clk,reset;
input [31:0] read_address;
output [31:0] instruction_out;

reg [31:0] IMemory[63:0];
integer k;
assign instruction_out = IMemory[read_address];

always @(posedge clk) begin
    if (reset==1'b1) 
        begin
            for(k=0;k<64;k=k+1) begin
                IMemory[k]<=32'b0;
                end
            end
     else if (reset==1'b0)
            IMemory[0] = 32'b00000000011001010000001010011011; // add x10, x10, x25
            IMemory[4] = 32'b00000000011001010000001010011011; // add x10, x10, x25
            IMemory[8] = 32'b00000000000001010011010101000011; // lw x9, (x10)
            IMemory[12] = 32'b00000000011000010011000011100111; // bne x9, x24, Exit
            IMemory[16] = 32'b00000000000011010000010100011011; // add x22, x22, 1
            IMemory[20] = 32'b11111111100000000000001101100111; // beq x0, x0, Loop

end
endmodule

// RF
module Register_File(clk,reset,RegWrite,Rs1,Rs2,Rd,Write_data,read_data1,read_data2);

input clk,reset,RegWrite;
input [4:0] Rs1,Rs2,Rd;
input [31:0] Write_data;
output [31:0] read_data1,read_data2;

reg [31:0] Registers[31:0];

initial begin 
    Registers[0] = 0;
Registers[1] = 4;
Registers[2] = 2;
Registers[3] = 24;
Registers[4] = 4;
Registers[5] = 1;
Registers[6] = 44;
Registers[7] = 4;
Registers[8] = 2;
Registers[9] = 1;
Registers[10] = 23;
Registers[11] = 4;
Registers[12] = 90;
Registers[13] = 10;
Registers[14] = 20;
Registers[15] = 30;
Registers[16] = 40;
Registers[17] = 50;
Registers[18] = 60;
Registers[19] = 70;
Registers[20] = 80;
Registers[21] = 80;
Registers[22] = 90;
Registers[23] = 70;
Registers[24] = 60;
Registers[25] = 65;
Registers[26] = 4;
Registers[27] = 32;
Registers[28] = 12;
Registers[29] = 15;
Registers[30] = 5;
Registers[31] = 10;
end

integer k;

always @(posedge clk) begin
    if (reset==1'b1) begin
            for(k=0;k<32;k=k+1) begin
                Registers[k]<=32'h0;
                end
            end
     else if (RegWrite==1'b1) begin
        Registers[Rd]<=Write_data;
        end
end

assign read_data1=Registers[Rs1];
assign read_data2=Registers[Rs2];

endmodule

// IG
module Immediate_Generator(
    input signed [31:0] instruction,
    output reg signed [31:0] I,S,SB
);

always @(*) begin
    I={{20{instruction[31]}},instruction[31:20]};
    S={{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    SB={{19{instruction[31]}},instruction[31],instruction[30:25],instruction[11:8],1'b0};
end

endmodule

// CU
module Control_Unit(reset,Opcode,Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite);

input reset;
input [6:0] Opcode;
output reg Branch,MemRead,MemToReg,MemWrite,ALUSrc,RegWrite;
output reg [1:0] ALUOp;

always @(*) begin
if(reset)
begin
{ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}<=7'b0000000;
end
else begin
case (Opcode)
7'b0110011:
begin
ALUSrc<=0;MemToReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2'b10;
end

7'b0000011:
begin
ALUSrc<=1;MemToReg<=1;RegWrite<=1;MemRead<=1;MemWrite<=0;Branch<=0;ALUOp<=2'b00;
end

7'b0100011:
begin
ALUSrc<=1;MemToReg<=0;RegWrite<=0;MemRead<=0;MemWrite<=1;Branch<=0;ALUOp<=2'b00;
end

7'b1100011:
begin
ALUSrc<=0;MemToReg<=0;RegWrite<=0;MemRead<=0;MemWrite<=0;Branch<=1;ALUOp<=2'b01;
end

default:
begin
ALUSrc<=0;MemToReg<=0;RegWrite<=1;MemRead<=0;MemWrite<=0;Branch<=0;ALUOp<=2'b10;
end
endcase
end
end
endmodule

// ALU
module ALU(A,B,ALUControl_in,ALU_Result,zero);

input [31:0] A,B;
input [3:0] ALUControl_in;
output reg zero; 
output reg [31:0] ALU_Result;

always @(ALUControl_in or A or B) begin
    case (ALUControl_in)
    4'b0000: begin zero<=0;ALU_Result<=A&B;end
    4'b0001: begin zero<=0;ALU_Result<=A|B;end
    4'b0010: begin zero<=0;ALU_Result<=A+B;end
    4'b0000: begin if(A==B) zero<=1; else zero<=0;ALU_Result<=A-B;end
    endcase
end
endmodule

// ALU_Control
module ALU_Control(ALUOp,func7,func3,ALUControl_out);
input [31:25] func7;
input [14:12] func3;
input [1:0] ALUOp;
output reg [3:0] ALUControl_out;

always @(*) begin
    case ({ALUOp, func7, func3})
        12'b00_000000_000 : ALUControl_out = 4'b0010;  // Example operation
        12'b00_000000_001 : ALUControl_out = 4'b0110;  // Another operation
        12'b01_000000_000 : ALUControl_out = 4'b0100;  // Yet another operation
        12'b01_000001_000 : ALUControl_out = 4'b0001;  // A different operation
        default           : ALUControl_out = 4'bxxxx;  // Invalid or undefined inputs
    endcase
end
endmodule

// DM
module Data_Memory(clk,reset,MemWrite,MemRead,address,Write_data,MemData_out);

input clk,reset,MemWrite,MemRead;
input [31:0] address,Write_data;
output [31:0] MemData_out;

reg [31:0] D_Memory[63:0];
integer k;
assign MemData_out=(MemRead)?D_Memory[address]:32'b0;

always @(posedge clk or posedge reset) begin
    if (reset==1'b1) begin
            for(k=0;k<64;k=k+1) begin
                D_Memory[k]<=32'b0;
                end
            end
     else 
        if (MemWrite) begin
            D_Memory[address]=Write_data;
        end
end
endmodule

// mux
module Mux1(Sel,A1,B1,Mux1_out);
input Sel;
input [31:0] A1,B1;
output [31:0] Mux1_out;

assign Mux1_out=(Sel==1'b0) ? A1 : B1;
endmodule

module Mux2(Sel,A2,B2,Mux2_out);
input Sel;
input [31:0] A2,B2;
output [31:0] Mux2_out;

assign Mux2_out=(Sel==1'b0) ? A2 : B2;
endmodule

// All Modules
module Top (
    input clk,reset
);

wire [31:0] PCtop,NexttoPCTop,InstructionOutTop,Read_data1Top,Read_data2Top,toALU,ALUControlOutTop;
wire [31:0] ALUResultTop,DataOutTop,WriteBackTop;
wire RegWriteTop,ALUSrcTop,MemWriteTop,MemReadTop,MemToRegTop;
wire [1:0] ALUOpTop;

// PC+4
PCplus4 pc4
(
.fromPC(PCtop),
.NexttoPC(NexttoPCTop)
);

// PC
Program_Counter PC
(
.clk(clk),
.reset(reset),
.PC_in(NexttoPCTop),
.PC_out(PCtop)
);

// IM
Instruction_Memory IM
(
.clk(clk),
.reset(reset),
.read_address(PCtop),
.instruction_out(InstructionOutTop)
);

// RF
Register_File RF
(
.clk(clk),
.reset(reset),
.RegWrite(RegWriteTop),
.Rs1(InstructionOutTop[19:15]),
.Rs2(InstructionOutTop[24:20]),
.Rd(InstructionOutTop[11:7]),
.Write_data(WriteBackTop),
.read_data1(Read_data1Top),
.read_data2(toALU)
);

// ALU
ALU ALU
(
.A(Read_data1Top),
.B(Read_data2Top),
.ALUControl_in(ALUControlOutTop),
.ALU_Result(ALUResultTop),
.zero()
);

// mux-1
Mux1 Mux1
(
.Sel(ALUSrcTop),
.A1(Read_data2Top),
.B1(),
.Mux1_out(toALU)
);

// ALU-Control
ALU_Control ALU_Control
(
.ALUOp(ALUOpTop),
.func7(InstructionOutTop[30]),
.func3(InstructionOutTop[14:12]),
.ALUControl_out(ALUControlOutTop)
);

// DM
Data_Memory Data_Memory
(
.clk(clk),
.reset(reset),
.MemWrite(MemWriteTop),
.MemRead(MemReadTop),
.address(ALUResultTop),
.Write_data(),
.MemData_out(DataOutTop)
);

// mux-2
Mux2 Mux2
(
.Sel(MemToRegTop),
.A2(ALUResultTop),
.B2(DataOutTop),
.Mux2_out(WriteBackTop)
);

// CU
Control_Unit Control_Unit
(
.reset(),
.Opcode(InstructionOutTop[6:0]),
.Branch(),
.MemRead(MemReadTop),
.MemToReg(MemToRegTop),
.ALUOp(ALUOpTop),
.MemWrite(MemWriteTop),
.ALUSrc(ALUSrcTop),
.RegWrite(RegWriteTop)
);

endmodule

// testbench
module Top_tb;
reg clk,reset;
Top DUT (
    .clk(clk),
    .reset(reset)
);
initial begin
clk=0;
end
always #50 clk=~clk;

initial begin
reset=1'b1;
#50;
reset=1'b0;
#400;
end
endmodule
