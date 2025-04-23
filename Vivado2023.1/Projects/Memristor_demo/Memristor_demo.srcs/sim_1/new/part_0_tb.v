`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 10:37:13
// Design Name: 
// Module Name: float_mult_tb
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



module part_0_tb();
     reg clk;
     reg mux_valid = 1;
     reg [31:0] mux_out;
     reg part1_valid = 1;
     reg [31:0] part1_2_part0;
     wire v_valid;
     wire [31:0] v_out;
     wire part0_valid;             
     wire [31:0] part0_2_part1;    

     
part_0 u1_part_0(
      .clk(clk),
      .mux_valid(mux_valid),
      .mux_out(mux_out),
      .part1_valid(part1_valid),
      .part1_2_part0(part1_2_part0),
      .v_valid(v_valid),
      .v_out(v_out),
      .part0_valid(part0_valid),
      .part0_2_part1(part0_2_part1)
);
always #5 clk = ~clk;
 
initial begin
    clk = 1'b0;   
    mux_out = 32'b0011_1111_0000_0000_0000_0000_0000_0000;          //-6.6
    part1_2_part0 = 32'b0011_1100_1000_0000_0001_1111_0111_0101;         // 0.01564
end
endmodule

