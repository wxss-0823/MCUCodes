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
reg sys_clk;                           // ʱ���ź�
reg mux_set_port;                // ��������ѡ����0����
wire gateway_0;             // ����ؿ� 0
wire gateway_1;              // ����ؿ� 1
wire sync;                        // ����͵�ƽ�����ڿ���Ƭѡ�ź���Ч
wire conver_clk;                  // ��� series clk �����ڶ�ȡ�������

// ���� top
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
