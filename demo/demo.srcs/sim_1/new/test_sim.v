`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/16 18:36:05
// Design Name: 
// Module Name: test_sim
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


module test_sim(
    );
 reg a;
 reg b;
 wire [5:0] z;
 test uut(
 .a(a),
 .b(b),
 .z(z)
 );
  initial
  begin
     while(1)
    begin
    a=0;
    b=0;
    #100;
    a=0;
    b=1;
    #100;
    a=1;
    b=0;
    #100;
    a=1;
    b=1;
    #100;
    end
  end
endmodule
