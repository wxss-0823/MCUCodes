`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: Wang Xishengshun
// 
// Create Date: 2024/04/17 10:32:19
// Design Name: Memristor_circuit
// Module Name: part_0
// Project Name: Memristor_demo
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2023.1
// Description: This is part_0 module.
// 
// Dependencies: None
// 
// Revision: V1.0
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

 
module part_0(
    input clk,
    input mux_valid,                // 初始有效电平
    input [31:0] mux_out,           // 数据选择器0的输出
    input part1_valid,               // 区块2的有效电平
    input [31:0] part1_2_part0,     // 区块2向区块1的输人
    output v_valid,                 // 最终输出结果的有效电平
    output [31:0] v_out,            // 最终输出结果：电压
    output part0_valid,              // 区块1的有效电平
    output [31:0] part0_2_part1     // 区块1向区块二的输出
    
    );
    
// 用于定义传递给 part_1 的参数
assign part0_valid = mux_valid;
assign part0_2_part1 = mux_out;
    
wire mul_0_valid;                   // 一级乘法器输出有效电平
wire [31:0] mul_0_result;           // 一级乘法器输出结果

floating_point_0 u1_float_multiply_0( 
/*
    一级乘法器
*/                      
    .aclk(clk),
    // 双输入均为数据选择器输出
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    // 一级乘法器输出结果
    .m_axis_result_tvalid(mul_0_valid),
    .m_axis_result_tdata(mul_0_result)
);

wire mul_1_valid;               // 二级乘法器输出有效电平
wire [31:0] mul_1_result;       // 二级乘法器输出结果

floating_point_1 u1_float_mutiply_1(
/*
    二级乘法器
*/    
    .aclk(clk),
    // 一个输入为一级乘法器输出
    .s_axis_a_tvalid(mul_0_valid),
    .s_axis_a_tdata(mul_0_result),
    // 另一个为数据选择器输出结果
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    .m_axis_result_tvalid(mul_1_valid),
    .m_axis_result_tdata(mul_1_result)
);

wire mul_2_valid;               // 三级乘法器输出有效电平
wire [31:0] mul_2_result;       // 三级乘法器输出结果
/*
    我认为，范德波尔振荡波形，
    在 ebsilon != 0时，无法稳态振荡，
    只能阻尼或负阻尼振荡。
    // 常浮点数 -0.1328
    parameter float_num_0 = 32'b1011_1110_0000_0111_1111_1100_1011_1001;

*/
// 调整系数为 0.000003 增加范德波尔方程中的 ebsilon = 0.1
//parameter float_num_0 = 32'b0011_0110_0101_1111_1011_0010_0011_1011;


// 假使范德波尔方程 ebsilon = 0
parameter float_num_0 = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

floating_point_2 u1_float_mutiply_2(
/*
    三级乘法器
*/    
    .aclk(clk),
    // 一个输入为二级乘法器输出
    .s_axis_a_tvalid(mul_1_valid),
    .s_axis_a_tdata(mul_1_result),
    // 另一个为常浮点数
    .s_axis_b_tvalid(mul_1_valid),
    .s_axis_b_tdata(float_num_0),
    .m_axis_result_tvalid(mul_2_valid),
    .m_axis_result_tdata(mul_2_result)
);

wire mul_3_valid;               // 另一个三级乘法器输出有效电平
wire [31:0] mul_3_result;       // 另一个三级乘法器输出结果


// 常浮点数 1.004
//parameter float_num_1 = 32'b0011_1111_1000_0000_1000_0011_0001_0010;
// 调整系数为 1.00001 增加范德波尔方程中的 ebsilon = 0.1
//parameter float_num_1 = 32'b0011_1111_1000_0000_0000_0000_0101_0100;


// 系数为 1 振荡为正弦波
parameter float_num_1 = 32'b0011_1111_1000_0000_0000_0000_0000_0000;


floating_point_3 u1_float_mutiply_3(
/*
    另一个三级乘法器
*/    
    .aclk(clk),
    // 一个输入为数据选择器输出
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    // 另一个为常浮点数
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(float_num_1),
    .m_axis_result_tvalid(mul_3_valid),
    .m_axis_result_tdata(mul_3_result)
);

wire add_0_valid;               // 一级加法器输出有效电平
wire [31:0] add_0_result;       // 一级加法器输出结果

floating_point_4 u1_float_add_0(
/*
    一级加法器
*/    
    .aclk(clk),
    // 一个输入为三级乘法器的输出
    .s_axis_a_tvalid(mul_2_valid),
    .s_axis_a_tdata(mul_2_result),
    // 另一个为另一个三级乘法器的输出
    .s_axis_b_tvalid(mul_3_valid),
    .s_axis_b_tdata(mul_3_result),
    .m_axis_result_tvalid(add_0_valid),
    .m_axis_result_tdata(add_0_result)
);

//wire add_1_valid;               // 二级加法器输出有效电平
//wire [31:0] add_1_result;       // 二级加法器输出结果

floating_point_5 u1_float_add_1(
/*
    二级加法器
*/    
    .aclk(clk),
    // 一个输入为一级加法器的输出
    .s_axis_a_tvalid(add_0_valid),
    .s_axis_a_tdata(add_0_result),
    // 另一个为区块2的输入
    .s_axis_b_tvalid(part1_valid),
    .s_axis_b_tdata(part1_2_part0),
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
//    if (add_1_valid) begin
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
//            v_valid_reg = add_1_valid;
//            v_out_reg = add_1_result;
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


