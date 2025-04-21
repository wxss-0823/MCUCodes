`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/16 18:15:43
// Design Name:
// Module Name: test
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


module test(
input a,
input b,
output [5:0] z
);
assign z[0]=a&b;
assign z[1]=~a&b;
assign z[2]=a|b;
assign z[3]=~(a|b);
assign z[4]=a^b;
assign z[5]=a~^b;
endmodule