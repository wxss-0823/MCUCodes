`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 11:04:51
// Design Name: 
// Module Name: shunt_2_series
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

module shunt_2_series(

    input clk,
    input [15:0] shunt, //并行输入
    output series //串行输出

);

reg [15:0] shunt_buf; //串行数据寄存器
reg [3:0] counter; //计数器
reg series_reg;

always @(posedge clk) begin
    shunt_buf <= shunt;
    // counter = 4'b1110;
    if( counter < 15 ) begin //16位串行数据
        // 采用非阻塞，导致每次 shunt_buf 里存放上一次的 shunt 
        counter <= counter + 1'b1;
        /*
            从 counter = 1 开始读取最高位，由于非阻塞，下一条赋值不会立即执行
            所以直接读取最高位
        */
        shunt_buf <= {shunt_buf[14:0], shunt_buf[15]}; //移位寄存器
        series_reg <= shunt_buf[15];
        
        end

    else begin
        // 当  couter = 16 会进入并置零
        counter <= 0;
        // 此时需要读取最低位
        series_reg <= shunt_buf[15];
        end
end

assign series = series_reg;

endmodule
