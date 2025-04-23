`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: Wang Xishengshun
// 
// Create Date: 2024/04/17 21:23:00
// Design Name: Memristor_circuit
// Module Name: mux
// Project Name: Memristor_demo
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2023.1
// Description: This is mux module.
// 
// Dependencies: None
// 
// Revision: V1.0
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module mux(
    input clk,
    input set_port, set_valid,
    input [31:0] port_0, port_1,
    output valid,
    output [31:0] export
    );
    
// 输出寄存器
reg [31:0] export_reg;
// 输出有效位寄存器
reg valid_reg = 1'b1;

always @(posedge clk) begin
    if (set_port & set_valid == 1'b1) begin
        export_reg <= port_0;
        end
    else if (set_port == 1'b1 && set_valid == 1'bx) begin
        export_reg <= port_1;
        end
    else if (set_port == 1'b0) begin
        export_reg <= port_1;
        end
    else begin
        export_reg <= port_1;
        end
end

// 为输出赋值
assign export = export_reg;
// 为输出有效位赋值
assign valid = valid_reg;

endmodule
