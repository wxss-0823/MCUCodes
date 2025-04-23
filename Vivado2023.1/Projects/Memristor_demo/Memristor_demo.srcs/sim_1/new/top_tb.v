`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 23:19:18
// Design Name: 
// Module Name: top_tb
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


module top_tb();
reg sys_clk;                           // 时钟信号
reg mux_set_port;                // 设置数据选择器0输入
wire gateway_0;             // 输出关口 0
wire gateway_1;              // 输出关口 1
wire sync;                        // 输出低电平，用于控制片选信号有效
wire conver_clk;                  // 输出 series clk ，用于读取串行输出

// 例化 top
top u1_top_tb(
    .sys_clk(sys_clk),
    .mux_set_port(mux_set_port),
    .sync(sync),
    .conver_clk(conver_clk),
    .gateway_0(gateway_0),
    .gateway_1(gateway_1)
);

 always #5 sys_clk = ~sys_clk;

initial begin
    sys_clk = 1'b0;
    mux_set_port = 1;
//    # 1000000
//    mux_set_port = 0;
end

endmodule
