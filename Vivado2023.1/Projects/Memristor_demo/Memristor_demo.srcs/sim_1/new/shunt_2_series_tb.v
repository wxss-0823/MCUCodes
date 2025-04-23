`timescale 100ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 17:01:56
// Design Name: 
// Module Name: shunt_2_series_tb
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


module shunt_2_series_tb();
    reg clk;
    reg [15:0] shunt; //并行输入
    wire series; //串行输出
    
shunt_2_series shun_2_series_tb (
    .clk(clk),
    .shunt(shunt),
    .series(series)
);    

always #2 clk = ~clk;

initial begin
    clk = 1'b0;
    // shunt = 16'b0101_0101_0101_0101;
    // shunt = 16'b1010_1010_1010_1010;
    shunt = 16'b1100_1001_1010_0101;
    #84 // 延迟 16 个周期
    shunt = 16'b1011_1110_1000_0001;

end


endmodule
