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
    input mux_valid,                // ��ʼ��Ч��ƽ
    input [31:0] mux_out,           // ����ѡ����0�����
    input part0_valid,               // ����1����Ч��ƽ
    input [31:0] part0_2_part1,     // ����1������2������
    output v_valid,                 // ��������������Ч��ƽ
    output [31:0] v_out,            // ��������������ѹ
    output part1_valid,              // ����2����Ч��ƽ
    output [31:0] part1_2_part0     // ����2������1�����
    
    );

// ����˷����ĳ����������룺0.01953
//parameter float_num_1 = 32'b0011_1100_1001_1111_1111_1101_0110_0001;
// ��ʹ���²���΢�ַ�����ɢ��ȡ��ʱ��Ϊ 0.0001
parameter float_num_1 = 32'b0011_1000_1101_0001_1011_0111_0001_0111;
// ��ʹ���²���΢�ַ�����ɢ��ȡ��ʱ��Ϊ 0.01
//parameter float_num_1 = 32'b0011_1100_0010_0011_1101_0111_0000_1010;



floating_point_6 u1_float_multiply_6(
/*
    ����˷���������������ݸ� part_1 �Ĳ���
*/
    .aclk(clk),
    // һ������Ϊ����ѡ����1�������ƽ����ѹ
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    // ��һ�����Ϊ����
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(float_num_1),
    // ���Ϊ���ݸ� part_1 �ĵ�ƽ����ѹ
    .m_axis_result_tvalid(part1_valid),
    .m_axis_result_tdata(part1_2_part0)

);
    
wire mul_0_valid;                   // һ���˷��������Ч��ƽ
wire [31:0] mul_0_result;           // һ���˷���������
// һ���˷����ĳ���������-0.05078
//parameter float_num_0 = 32'b1011_1101_0100_1111_1111_1110_1011_0000;    
// ��ʹ���²���΢�ַ�����ɢ��ȡ��ʱ��Ϊ -0.0001
parameter float_num_0 = 32'b1011_1000_1101_0001_1011_0111_0001_0111;    
// ��ʹ���²���΢�ַ�����ɢ��ȡ��ʱ��Ϊ -0.01
//parameter float_num_0 = 32'b1011_1100_0010_0011_1101_0111_0000_1010;    




floating_point_7 u1_float_multiply_7( 
/*
    һ���˷���
*/                      
    .aclk(clk),
    // һ��Ϊ����������-0.05078
    .s_axis_a_tvalid(part0_valid),
    .s_axis_a_tdata(float_num_0),
    // ��һ������Ϊ����ѡ����0�������ƽ����ѹ
    .s_axis_b_tvalid(part0_valid),
    .s_axis_b_tdata(part0_2_part1),
    // һ���˷���������
    .m_axis_result_tvalid(mul_0_valid),
    .m_axis_result_tdata(mul_0_result)
);

//wire add_0_valid;                       //һ���ӷ��������ƽ
//wire [31:0] add_0_result;                      //һ���ӷ���������

floating_point_8 u1_float_add_8(
/*
    һ���ӷ�������ȡ�������
*/
    .aclk(clk),
    // һ������Ϊһ���˷��������
    .s_axis_a_tvalid(mul_0_valid),
    .s_axis_a_tdata(mul_0_result),
    // ��һ��Ϊ����ѡ����1�����
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    .m_axis_result_tvalid(v_valid),
    .m_axis_result_tdata(v_out)
);
    
//parameter delay_per = 8'h4;     // ʱ�ӳ���
//reg [31:0] v_out_reg;           // �����ѹ�Ĵ���
//reg v_valid_reg, flag;          // �����ƽ�Ĵ�������־λ
//reg [7:0] delay_count = 0;      // ������

//always @(posedge clk) begin
///*
//    ȡ���һ���ӷ�������������ı�־λ
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
//    ���ڽ� delay_count ���㣬ʵ��������ʱ����ʧ�ܣ�
//*/
////    if (delay_count == delay_per) begin
////        delay_count = 1'b0;
////        end
////end
    
//always @(posedge clk) begin
///*
//    ������������ʱ�ӣ���־λ���㣬Ϊ�Ĵ�����ֵ��
//    ����������㡣
//*/
//    if (flag) begin
//        // �޸�Ϊ != ��ȡ����ʱ
//        if (delay_count !== delay_per) begin
//            // delay_count = 0;
//            // ����Ϊ��ʱģ�����ȡ�������������ģת���Ƿ���Ӱ�졣
//            // delay_count = delay_count & (delay_per - 1'b1);  // �� 4 ȡ�� ��ʧ�ܣ�
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

//// Ϊ�����ֵ
//assign v_out = v_out_reg;
//assign v_valid = v_valid_reg;

endmodule
