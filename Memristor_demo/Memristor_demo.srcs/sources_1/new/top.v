`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: Wang Xishengshun
// 
// Create Date: 2024/04/17 11:58:35
// Design Name: Memristor_circuit
// Module Name: top
// Project Name: Memristor_demo
// Target Devices: Nexys 4 DDR
// Tool Versions: Vivado 2023.1
// Description: This is top module.
// 
// Dependencies: None
// 
// Revision: V1.0
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input sys_clk,                          // 时钟信号
    input mux_set_port,               // 设置数据选择器0、1输入
    //  Pmod DA2 输出配置
    output sync,                        // 输出低电平，用于控制片选信号有效
    output conver_clk,                  // 输出 series clk ，用于读取串行输出
    output gateway_0,            // 输出关口 0
    output gateway_1             // 输出关口 1

    );


wire clk;

// 例化时钟分频模块
clk_wiz_0 u1_clk_wiz_0 (
    .sys_clk(sys_clk),      // 100 MHz 系统时钟
    .mul_clk(clk),              // 输出未分频的主时钟 5 MHz
    .conver_clk(conver_clk)     // 输出用于数模转换模块的 SCLK 25 MHz
);

// 2 MHz 主时钟会出现时序问题
// 例化自定义分频模块
clock_div u1_clock_div (
    .mul_clk(conver_clk),
    .div_clk(div_clk)           // 输出分频后的主时钟 xxx MHz
);

// 数据选择器0有效位
wire mux_0_set_valid;
// 数据选择器0的第一个输出：gateway_0 的反馈
wire [31:0] mux_0_port_0;
// 数据选择器0的第二个输出：常浮点数：0.5
//parameter mux_0_port_1 = 32'b0011_1111_0000_0000_0000_0000_0000_0000;
// 初值为 1.414 
parameter mux_0_port_1 = 32'b0011_1111_0011_0101_0000_0100_1111_0011;
// 数据选择器0的输出
wire [31:0] mux_0_export;
// 数据选择器0的输出有效值
wire mux_0_valid;

// 例化 mux_0
mux u1_mux_0 (
    .clk(clk),
    .set_port(mux_set_port), 
    .set_valid(mux_0_set_valid),
    .port_0(mux_0_port_0), 
    .port_1(mux_0_port_1),
    .export(mux_0_export),
    .valid(mux_0_valid)
);

wire part0_valid;               // part_0 输出有效值
wire [31:0] part0_2_part1;      // part_0 输出结果
wire part1_valid;                // part_1 输出有效值
wire [31:0] part1_2_part0;      // part_1 输出结果


// 例化 part_0
part_0 u1_part_0 (
    .clk(clk),
    // mux 输出不含有效位，待设置...
    .mux_valid(mux_0_valid),                      // 初始有效电平
    .mux_out(mux_0_export),             // 数据选择器0的输出
    // 待调整...
    .part1_valid(part1_valid),                    // 区块2的有效电平
    .part1_2_part0(part1_2_part0),              // 区块2向区块1的输人
    // 输出电平、电压接 mux 输入
    .v_valid(mux_0_set_valid),          // 最终输出结果的有效电平
    .v_out(mux_0_port_0),               // 最终输出结果：电压
    // 待调整...
    .part0_valid(part0_valid),                    // 区块1的有效电平
    .part0_2_part1(part0_2_part1)               // 区块1向区块二的输出
);

// 数据选择器1有效位
wire mux_1_set_valid;
// 数据选择器1的第一个输出：gateway_2 的反馈
wire [31:0] mux_1_port_0;
// 数据选择器1的第二个输出：常浮点数：0.80078125
//parameter mux_1_port_1 = 32'b0011_1111_0100_1101_0000_0000_0000_0000;
// 初值为 0
parameter mux_1_port_1 = 32'b1011_1111_0011_0101_0000_0100_1111_0011;
// 数据选择器1的输出
wire [31:0] mux_1_export;
// 数据选择器1的输出有效值
wire mux_1_valid;

// 例化 mux_1
mux u1_mux_1 (
    .clk(clk),
    .set_port(mux_set_port), 
    .set_valid(mux_1_set_valid),
    .port_0(mux_1_port_0), 
    .port_1(mux_1_port_1),
    .export(mux_1_export),
    .valid(mux_1_valid)
);

// 例化 part_1
part_1 u1_part_1(
    .clk(clk),
    // mux 输出不含有效位，待设置...
    .mux_valid(mux_1_valid),                // 初始有效电平
    .mux_out(mux_1_export),           // 数据选择器0的输出
    .part0_valid(part0_valid),               // 区块1的有效电平
    .part0_2_part1(part0_2_part1),     // 区块1向区块2的输人
    .v_valid(mux_1_set_valid),                 // 最终输出结果的有效电平
    .v_out(mux_1_port_0),                   // 最终输出结果：电流
    .part1_valid(part1_valid),                      // 区块2的有效电平
    .part1_2_part0(part1_2_part0)                    // 区块2向区块1的输出

);




//always @(posedge clk) begin
//    if (mux_set_port) begin
        
//    end
    
//end

wire [15:0] v_out_fixed;
wire v_valid_fixed;

// 例化 位数转换器
floating_point_9 u1_float_2_fixed_0 (
/*
    用于将 32 位浮点数，转换为 16 位定点数。
    1 bit 符号，4 bit 整数， 11 bit 小数
*/
    .aclk(clk),
    .s_axis_a_tdata(mux_0_port_0),
    .s_axis_a_tvalid(mux_0_set_valid),
    .m_axis_result_tdata(v_out_fixed),
    .m_axis_result_tvalid(v_valid_fixed)

);

wire [15:0] conver_input_0;
// wire conver_clk;                   // 串并转换器的时钟信号
reg sync_reg = 0;                   // 将 Pmod DA2 的 sync 置0
//// 用于初始置零
//always @(posedge conver_clk) begin
//    if (gateway_0 == 1'bx) begin
//        sync_reg <= 1;
//        end
//    else begin
//        sync_reg <= 0;
//        end 
//end
// 拼接输出，以用于 Pmod DA2 输入
assign conver_input_0 = {4'b0000, v_out_fixed[15], v_out_fixed[10:0]};
// 为输出时钟信号 SYNC 赋值
assign sync = sync_reg;

// 例化并串转换模块
shunt_2_series u1_shunt_2_series_0 (
    .clk(conver_clk),
    .shunt(conver_input_0),
    .series(gateway_0)
);
// gateway_0 为输出电压


wire [15:0] i_out_fixed;
wire i_valid_fixed;

// 例化 位数转换器
floating_point_10 u1_float_2_fixed_1 (
/*
    用于将 32 位浮点数，转换为 16 位定点数。
    1 bit 符号，4 bit 整数， 11 bit 小数
*/
    .aclk(clk),
    .s_axis_a_tdata(mux_1_port_0),
    .s_axis_a_tvalid(mux_1_set_valid),
    .m_axis_result_tdata(i_out_fixed),
    .m_axis_result_tvalid(i_valid_fixed)

);

wire [15:0] conver_input_1;
// wire conver_clk;                   // 串并转换器的时钟信号
// 拼接输出，以用于 Pmod DA2 输入
assign conver_input_1 = {4'b0000, i_out_fixed[15], i_out_fixed[10:0]};

// 例化并串转换模块
shunt_2_series u1_shunt_2_series_1 (
    .clk(conver_clk),
    .shunt(conver_input_1),
    .series(gateway_1)
);
// gateway_1 为输出电流




// 为最终关口赋值
// assign gateway_0[15:0] = mux_0_port_0[15:0];
//assign gateway_0 = {4'b0000, v_out_fixed};
// assign gateway_1 = mux_1_port_0;

endmodule
