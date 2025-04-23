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
    input [15:0] shunt, //��������
    output series //�������

);

reg [15:0] shunt_buf; //�������ݼĴ���
reg [3:0] counter; //������
reg series_reg;

always @(posedge clk) begin
    shunt_buf <= shunt;
    // counter = 4'b1110;
    if( counter < 15 ) begin //16λ��������
        // ���÷�����������ÿ�� shunt_buf ������һ�ε� shunt 
        counter <= counter + 1'b1;
        /*
            �� counter = 1 ��ʼ��ȡ���λ�����ڷ���������һ����ֵ��������ִ��
            ����ֱ�Ӷ�ȡ���λ
        */
        shunt_buf <= {shunt_buf[14:0], shunt_buf[15]}; //��λ�Ĵ���
        series_reg <= shunt_buf[15];
        
        end

    else begin
        // ��  couter = 16 ����벢����
        counter <= 0;
        // ��ʱ��Ҫ��ȡ���λ
        series_reg <= shunt_buf[15];
        end
end

assign series = series_reg;

endmodule
