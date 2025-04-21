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
    input sys_clk,                          // ʱ���ź�
    input mux_set_port,               // ��������ѡ����0��1����
    //  Pmod DA2 �������
    output sync,                        // ����͵�ƽ�����ڿ���Ƭѡ�ź���Ч
    output conver_clk,                  // ��� series clk �����ڶ�ȡ�������
    output gateway_0,            // ����ؿ� 0
    output gateway_1             // ����ؿ� 1

    );


wire clk;

// ����ʱ�ӷ�Ƶģ��
clk_wiz_0 u1_clk_wiz_0 (
    .sys_clk(sys_clk),      // 100 MHz ϵͳʱ��
    .mul_clk(clk),              // ���δ��Ƶ����ʱ�� 5 MHz
    .conver_clk(conver_clk)     // ���������ģת��ģ��� SCLK 25 MHz
);

// 2 MHz ��ʱ�ӻ����ʱ������
// �����Զ����Ƶģ��
clock_div u1_clock_div (
    .mul_clk(conver_clk),
    .div_clk(div_clk)           // �����Ƶ�����ʱ�� xxx MHz
);

// ����ѡ����0��Чλ
wire mux_0_set_valid;
// ����ѡ����0�ĵ�һ�������gateway_0 �ķ���
wire [31:0] mux_0_port_0;
// ����ѡ����0�ĵڶ������������������0.5
//parameter mux_0_port_1 = 32'b0011_1111_0000_0000_0000_0000_0000_0000;
// ��ֵΪ 1.414 
parameter mux_0_port_1 = 32'b0011_1111_0011_0101_0000_0100_1111_0011;
// ����ѡ����0�����
wire [31:0] mux_0_export;
// ����ѡ����0�������Чֵ
wire mux_0_valid;

// ���� mux_0
mux u1_mux_0 (
    .clk(clk),
    .set_port(mux_set_port), 
    .set_valid(mux_0_set_valid),
    .port_0(mux_0_port_0), 
    .port_1(mux_0_port_1),
    .export(mux_0_export),
    .valid(mux_0_valid)
);

wire part0_valid;               // part_0 �����Чֵ
wire [31:0] part0_2_part1;      // part_0 ������
wire part1_valid;                // part_1 �����Чֵ
wire [31:0] part1_2_part0;      // part_1 ������


// ���� part_0
part_0 u1_part_0 (
    .clk(clk),
    // mux ���������Чλ��������...
    .mux_valid(mux_0_valid),                      // ��ʼ��Ч��ƽ
    .mux_out(mux_0_export),             // ����ѡ����0�����
    // ������...
    .part1_valid(part1_valid),                    // ����2����Ч��ƽ
    .part1_2_part0(part1_2_part0),              // ����2������1������
    // �����ƽ����ѹ�� mux ����
    .v_valid(mux_0_set_valid),          // ��������������Ч��ƽ
    .v_out(mux_0_port_0),               // ��������������ѹ
    // ������...
    .part0_valid(part0_valid),                    // ����1����Ч��ƽ
    .part0_2_part1(part0_2_part1)               // ����1������������
);

// ����ѡ����1��Чλ
wire mux_1_set_valid;
// ����ѡ����1�ĵ�һ�������gateway_2 �ķ���
wire [31:0] mux_1_port_0;
// ����ѡ����1�ĵڶ������������������0.80078125
//parameter mux_1_port_1 = 32'b0011_1111_0100_1101_0000_0000_0000_0000;
// ��ֵΪ 0
parameter mux_1_port_1 = 32'b1011_1111_0011_0101_0000_0100_1111_0011;
// ����ѡ����1�����
wire [31:0] mux_1_export;
// ����ѡ����1�������Чֵ
wire mux_1_valid;

// ���� mux_1
mux u1_mux_1 (
    .clk(clk),
    .set_port(mux_set_port), 
    .set_valid(mux_1_set_valid),
    .port_0(mux_1_port_0), 
    .port_1(mux_1_port_1),
    .export(mux_1_export),
    .valid(mux_1_valid)
);

// ���� part_1
part_1 u1_part_1(
    .clk(clk),
    // mux ���������Чλ��������...
    .mux_valid(mux_1_valid),                // ��ʼ��Ч��ƽ
    .mux_out(mux_1_export),           // ����ѡ����0�����
    .part0_valid(part0_valid),               // ����1����Ч��ƽ
    .part0_2_part1(part0_2_part1),     // ����1������2������
    .v_valid(mux_1_set_valid),                 // ��������������Ч��ƽ
    .v_out(mux_1_port_0),                   // ����������������
    .part1_valid(part1_valid),                      // ����2����Ч��ƽ
    .part1_2_part0(part1_2_part0)                    // ����2������1�����

);




//always @(posedge clk) begin
//    if (mux_set_port) begin
        
//    end
    
//end

wire [15:0] v_out_fixed;
wire v_valid_fixed;

// ���� λ��ת����
floating_point_9 u1_float_2_fixed_0 (
/*
    ���ڽ� 32 λ��������ת��Ϊ 16 λ��������
    1 bit ���ţ�4 bit ������ 11 bit С��
*/
    .aclk(clk),
    .s_axis_a_tdata(mux_0_port_0),
    .s_axis_a_tvalid(mux_0_set_valid),
    .m_axis_result_tdata(v_out_fixed),
    .m_axis_result_tvalid(v_valid_fixed)

);

wire [15:0] conver_input_0;
// wire conver_clk;                   // ����ת������ʱ���ź�
reg sync_reg = 0;                   // �� Pmod DA2 �� sync ��0
//// ���ڳ�ʼ����
//always @(posedge conver_clk) begin
//    if (gateway_0 == 1'bx) begin
//        sync_reg <= 1;
//        end
//    else begin
//        sync_reg <= 0;
//        end 
//end
// ƴ������������� Pmod DA2 ����
assign conver_input_0 = {4'b0000, v_out_fixed[15], v_out_fixed[10:0]};
// Ϊ���ʱ���ź� SYNC ��ֵ
assign sync = sync_reg;

// ��������ת��ģ��
shunt_2_series u1_shunt_2_series_0 (
    .clk(conver_clk),
    .shunt(conver_input_0),
    .series(gateway_0)
);
// gateway_0 Ϊ�����ѹ


wire [15:0] i_out_fixed;
wire i_valid_fixed;

// ���� λ��ת����
floating_point_10 u1_float_2_fixed_1 (
/*
    ���ڽ� 32 λ��������ת��Ϊ 16 λ��������
    1 bit ���ţ�4 bit ������ 11 bit С��
*/
    .aclk(clk),
    .s_axis_a_tdata(mux_1_port_0),
    .s_axis_a_tvalid(mux_1_set_valid),
    .m_axis_result_tdata(i_out_fixed),
    .m_axis_result_tvalid(i_valid_fixed)

);

wire [15:0] conver_input_1;
// wire conver_clk;                   // ����ת������ʱ���ź�
// ƴ������������� Pmod DA2 ����
assign conver_input_1 = {4'b0000, i_out_fixed[15], i_out_fixed[10:0]};

// ��������ת��ģ��
shunt_2_series u1_shunt_2_series_1 (
    .clk(conver_clk),
    .shunt(conver_input_1),
    .series(gateway_1)
);
// gateway_1 Ϊ�������




// Ϊ���չؿڸ�ֵ
// assign gateway_0[15:0] = mux_0_port_0[15:0];
//assign gateway_0 = {4'b0000, v_out_fixed};
// assign gateway_1 = mux_1_port_0;

endmodule
