`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: Wang Xishengshun
// 
// Create Date: 2024/04/18 15:32:28
// Design Name: Memristor_circuit
// Module Name: top
// Project Name: Memristor_demo
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2023.1
// Description: This is part_1 module.
// 
// Dependencies: None
// 
// Revision: V1.0
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module part_1(
    input clk,
    input mux_valid,                // 初始有效电平
    input [31:0] mux_out,           // 数据选择器0的输出
    input part0_valid,               // 区块1的有效电平
    input [31:0] part0_2_part1,     // 区块1向区块2的输人
    output v_valid,                 // 最终输出结果的有效电平
    output [31:0] v_out,            // 最终输出结果：电压
    output part1_valid,              // 区块2的有效电平
    output [31:0] part1_2_part0     // 区块2向区块1的输出
    
    );

// 输出乘法器的常浮点数输入：0.01953
//parameter float_num_1 = 32'b0011_1100_1001_1111_1111_1101_0110_0001;
// 假使范德波尔微分方程离散化取样时间为 0.0001
parameter float_num_1 = 32'b0011_1000_1101_0001_1011_0111_0001_0111;
// 假使范德波尔微分方程离散化取样时间为 0.01
//parameter float_num_1 = 32'b0011_1100_0010_0011_1101_0111_0000_1010;



floating_point_6 u1_float_multiply_6(
/*
    输出乘法器，用于输出传递给 part_1 的参数
*/
    .aclk(clk),
    // 一个输入为数据选择器1的输出电平及电压
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    // 另一个输出为常数
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(float_num_1),
    // 输出为传递给 part_1 的电平及电压
    .m_axis_result_tvalid(part1_valid),
    .m_axis_result_tdata(part1_2_part0)

);
    
wire mul_0_valid;                   // 一级乘法器输出有效电平
wire [31:0] mul_0_result;           // 一级乘法器输出结果
// 一级乘法器的常浮点数：-0.05078
//parameter float_num_0 = 32'b1011_1101_0100_1111_1111_1110_1011_0000;    
// 假使范德波尔微分方程离散化取样时间为 -0.0001
parameter float_num_0 = 32'b1011_1000_1101_0001_1011_0111_0001_0111;    
// 假使范德波尔微分方程离散化取样时间为 -0.01
//parameter float_num_0 = 32'b1011_1100_0010_0011_1101_0111_0000_1010;    




floating_point_7 u1_float_multiply_7( 
/*
    一级乘法器
*/                      
    .aclk(clk),
    // 一个为常浮点数：-0.05078
    .s_axis_a_tvalid(part0_valid),
    .s_axis_a_tdata(float_num_0),
    // 另一个输入为数据选择器0的输出电平及电压
    .s_axis_b_tvalid(part0_valid),
    .s_axis_b_tdata(part0_2_part1),
    // 一级乘法器输出结果
    .m_axis_result_tvalid(mul_0_valid),
    .m_axis_result_tdata(mul_0_result)
);

//wire add_0_valid;                       //一级加法器输出电平
//wire [31:0] add_0_result;                      //一级加法器输出结果

floating_point_8 u1_float_add_8(
/*
    一级加法器，获取最终输出
*/
    .aclk(clk),
    // 一个输入为一级乘法器的输出
    .s_axis_a_tvalid(mul_0_valid),
    .s_axis_a_tdata(mul_0_result),
    // 另一个为数据选择器1的输出
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    .m_axis_result_tvalid(v_valid),
    .m_axis_result_tdata(v_out)
);
    
//parameter delay_per = 8'h4;     // 时延长度
//reg [31:0] v_out_reg;           // 输出电压寄存器
//reg v_valid_reg, flag;          // 输出电平寄存器、标志位
//reg [7:0] delay_count = 0;      // 计数器

//always @(posedge clk) begin
///*
//    取最后一级加法器的输出，更改标志位
//*/
//    if (add_0_valid) begin
//        flag = 1;
//        end
//    else begin
//        flag = 0;
//        end
//end

////always @(~flag) begin
///*
//    用于将 delay_count 置零，实现周期延时。（失败）
//*/
////    if (delay_count == delay_per) begin
////        delay_count = 1'b0;
////        end
////end
    
//always @(posedge clk) begin
///*
//    当计数器等于时延，标志位置零，为寄存器赋值，
//    否则输出置零。
//*/
//    if (flag) begin
//        // 修改为 != 可取消延时
//        if (delay_count !== delay_per) begin
//            // delay_count = 0;
//            // 我认为延时模块可以取消，不清楚对数模转换是否有影响。
//            // delay_count = delay_count & (delay_per - 1'b1);  // 对 4 取余 （失败）
//            v_valid_reg = add_0_valid;
//            v_out_reg = add_0_result;
//            flag = 0;
//            end
//        else begin
//            delay_count = delay_count + 1'b1;
//            v_out_reg = 32'b0;
//            v_valid_reg = 1'b0;
//            end
//    end
//end

//// 为输出赋值
//assign v_out = v_out_reg;
//assign v_valid = v_valid_reg;

endmodule
