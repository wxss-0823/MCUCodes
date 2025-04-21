`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 22:54:47
// Design Name: 
// Module Name: mux_tb
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


module mux_tb();

reg clk;
reg set_port, set_valid;
reg [31:0] port_0, port_1;
wire [31:0] export;
wire valid;

// ภýปฏ mux
mux u1_mux_tb (
    .clk(clk),
    .set_port(set_port),
    .set_valid(set_valid),
    .port_0(port_0),
    .port_1(port_1),
    .export(export),
    .valid(valid)
);



always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    port_0 = 32'b0100_0001_0011_0001_1100_0010_1000_1111;
    port_1 = 32'b0100_0001_1011_0001_1100_0010_1000_1111;
    #15
    set_port = 1; set_valid = 1'bx;
    #100
    set_port = 1; set_valid = 0;
    #100
    set_port = 0; set_valid = 1;
    #100
    set_port = 0; set_valid = 0;
end

endmodule
