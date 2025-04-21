`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 16:05:25
// Design Name: 
// Module Name: part_1_tb
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


module part_1_tb();
    reg clk;
    reg mux_valid = 1;                // 初始有效电平
    reg [31:0] mux_out;           // 数据选择器0的输出
    reg part0_valid = 1;               // 区块1的有效电平
    reg [31:0] part0_2_part1;     // 区块1向区块2的输人
    wire v_valid;                 // 最终输出结果的有效电平
    wire [31:0] v_out;            // 最终输出结果：电压
    wire part1_valid;              // 区块2的有效电平
    wire [31:0] part1_2_part0;    // 区块2向区块1的输出

part_1 u1_part_1(
    .clk(clk),
    .mux_valid(mux_valid),
    .mux_out(mux_out),
    .part0_valid(part_valid),
    .part0_2_part1(part0_2_part1),
    .v_valid(v_valid),
    .v_out(v_out),
    .part1_valid(part_valid),
    .part1_2_part0(part1_2_part0)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    mux_out = 32'b0011_1111_0100_1101_0000_0000_0000_0000;          //-6.6
    part0_2_part1 = 32'b0011_1111_0000_0000_0000_0000_0000_0000;    //8.8
    
end

endmodule
