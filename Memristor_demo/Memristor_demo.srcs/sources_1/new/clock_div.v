`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/21 02:01:44
// Design Name: 
// Module Name: clock_div
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


module clock_div(
    input mul_clk,
    output div_clk
    );

reg [2:0] counter = 0;      // 计时器
reg div_clk_reg = 0;

always @(posedge mul_clk) begin
    if (counter == 4'b111) begin
    // 每 N 个周期，转换一次，降低时钟频率
        div_clk_reg <= ~div_clk_reg;
        counter <= 0;
        end
    else begin
        counter <= counter + 1'b1; 
    end
end

assign div_clk = div_clk_reg;

endmodule
