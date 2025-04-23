`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/21 02:21:51
// Design Name: 
// Module Name: clock_div_tb
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


module clock_div_tb();
reg mul_clk;
wire div_clk;

// ภýปฏ clock_div
clock_div clock_div_tb (
    .mul_clk(mul_clk),
    .div_clk(div_clk)
);

always #100 mul_clk = ~mul_clk;

initial begin
    mul_clk = 1'b0;
end

endmodule
