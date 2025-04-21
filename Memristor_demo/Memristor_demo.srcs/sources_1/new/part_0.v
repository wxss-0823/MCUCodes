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
    input mux_valid,                // ��ʼ��Ч��ƽ
    input [31:0] mux_out,           // ����ѡ����0�����
    input part1_valid,               // ����2����Ч��ƽ
    input [31:0] part1_2_part0,     // ����2������1������
    output v_valid,                 // ��������������Ч��ƽ
    output [31:0] v_out,            // ��������������ѹ
    output part0_valid,              // ����1����Ч��ƽ
    output [31:0] part0_2_part1     // ����1������������
    
    );
    
// ���ڶ��崫�ݸ� part_1 �Ĳ���
assign part0_valid = mux_valid;
assign part0_2_part1 = mux_out;
    
wire mul_0_valid;                   // һ���˷��������Ч��ƽ
wire [31:0] mul_0_result;           // һ���˷���������

floating_point_0 u1_float_multiply_0( 
/*
    һ���˷���
*/                      
    .aclk(clk),
    // ˫�����Ϊ����ѡ�������
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    // һ���˷���������
    .m_axis_result_tvalid(mul_0_valid),
    .m_axis_result_tdata(mul_0_result)
);

wire mul_1_valid;               // �����˷��������Ч��ƽ
wire [31:0] mul_1_result;       // �����˷���������

floating_point_1 u1_float_mutiply_1(
/*
    �����˷���
*/    
    .aclk(clk),
    // һ������Ϊһ���˷������
    .s_axis_a_tvalid(mul_0_valid),
    .s_axis_a_tdata(mul_0_result),
    // ��һ��Ϊ����ѡ����������
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(mux_out),
    .m_axis_result_tvalid(mul_1_valid),
    .m_axis_result_tdata(mul_1_result)
);

wire mul_2_valid;               // �����˷��������Ч��ƽ
wire [31:0] mul_2_result;       // �����˷���������
/*
    ����Ϊ�����²����񵴲��Σ�
    �� ebsilon != 0ʱ���޷���̬�񵴣�
    ֻ������������񵴡�
    // �������� -0.1328
    parameter float_num_0 = 32'b1011_1110_0000_0111_1111_1100_1011_1001;

*/
// ����ϵ��Ϊ 0.000003 ���ӷ��²��������е� ebsilon = 0.1
//parameter float_num_0 = 32'b0011_0110_0101_1111_1011_0010_0011_1011;


// ��ʹ���²������� ebsilon = 0
parameter float_num_0 = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

floating_point_2 u1_float_mutiply_2(
/*
    �����˷���
*/    
    .aclk(clk),
    // һ������Ϊ�����˷������
    .s_axis_a_tvalid(mul_1_valid),
    .s_axis_a_tdata(mul_1_result),
    // ��һ��Ϊ��������
    .s_axis_b_tvalid(mul_1_valid),
    .s_axis_b_tdata(float_num_0),
    .m_axis_result_tvalid(mul_2_valid),
    .m_axis_result_tdata(mul_2_result)
);

wire mul_3_valid;               // ��һ�������˷��������Ч��ƽ
wire [31:0] mul_3_result;       // ��һ�������˷���������


// �������� 1.004
//parameter float_num_1 = 32'b0011_1111_1000_0000_1000_0011_0001_0010;
// ����ϵ��Ϊ 1.00001 ���ӷ��²��������е� ebsilon = 0.1
//parameter float_num_1 = 32'b0011_1111_1000_0000_0000_0000_0101_0100;


// ϵ��Ϊ 1 ��Ϊ���Ҳ�
parameter float_num_1 = 32'b0011_1111_1000_0000_0000_0000_0000_0000;


floating_point_3 u1_float_mutiply_3(
/*
    ��һ�������˷���
*/    
    .aclk(clk),
    // һ������Ϊ����ѡ�������
    .s_axis_a_tvalid(mux_valid),
    .s_axis_a_tdata(mux_out),
    // ��һ��Ϊ��������
    .s_axis_b_tvalid(mux_valid),
    .s_axis_b_tdata(float_num_1),
    .m_axis_result_tvalid(mul_3_valid),
    .m_axis_result_tdata(mul_3_result)
);

wire add_0_valid;               // һ���ӷ��������Ч��ƽ
wire [31:0] add_0_result;       // һ���ӷ���������

floating_point_4 u1_float_add_0(
/*
    һ���ӷ���
*/    
    .aclk(clk),
    // һ������Ϊ�����˷��������
    .s_axis_a_tvalid(mul_2_valid),
    .s_axis_a_tdata(mul_2_result),
    // ��һ��Ϊ��һ�������˷��������
    .s_axis_b_tvalid(mul_3_valid),
    .s_axis_b_tdata(mul_3_result),
    .m_axis_result_tvalid(add_0_valid),
    .m_axis_result_tdata(add_0_result)
);

//wire add_1_valid;               // �����ӷ��������Ч��ƽ
//wire [31:0] add_1_result;       // �����ӷ���������

floating_point_5 u1_float_add_1(
/*
    �����ӷ���
*/    
    .aclk(clk),
    // һ������Ϊһ���ӷ��������
    .s_axis_a_tvalid(add_0_valid),
    .s_axis_a_tdata(add_0_result),
    // ��һ��Ϊ����2������
    .s_axis_b_tvalid(part1_valid),
    .s_axis_b_tdata(part1_2_part0),
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
//    if (add_1_valid) begin
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

//// Ϊ�����ֵ
//assign v_out = v_out_reg;
//assign v_valid = v_valid_reg;

endmodule


