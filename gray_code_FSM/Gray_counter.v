`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//���������� 3.27 � ���� ���� ���� �������� ��������: ���� �������� �����
//���������� ���� �� ����� ������ � ����� �������. � ����. 3.23 �����������
//3-��������� ��� ����, �������������� �������� ������������������ �� 0 �� 7.
//������������� 3-��������� ������� �������� � ���� ���� �� ������ 8. �
//�������� ��� ������, �� ���� 3 ������. (������� �� ������ N ������� �� 0 ��
//N-1, ����� ���� �����������. ��������, � ����� ������������ ������� ��
//������ 60 ��� ���� ����� ������� ������ � ������� �� 0 �� 59.) ����� ������ 
//�� �������� ������ ���� 000. �� ������� ������ ��������� ������� �������
//������ ���������� � ���������� ���� ����. �� ���������� ���� 100 �������
//������ ����� ������� � ���� 000.

//���������� 3.28 ���������������� ���� ������� �������� � ���� ����
//�� ���������� 3.27 ���, ����� �� ��� ������� ��� �����, ��� � ����. � ��������
//�������� ���� �����. ���� �����=1, �� ������� ����� ���������� �
//���������� ����, � ���� �����=0 - �� � �����������.

//////////////////////////////////////////////////////////////////////////////////
/*
This is a 3-bit Gray-code _generator_ with two clocks: up and down.

Number 	Gray code
0 		0 0 0
1 		0 0 1
2 		0 1 1
3 		0 1 0
4 		1 1 0
5 		1 1 1
6 		1 0 1
7 		1 0 0
*/


module Gray_counter(
	input	wire	clk_up,
	input	wire	clk_down,
	input	wire	reset,
	output reg [2:0] code
    );
    
    // change bit
    localparam	ch_01	= 2'b 00,
    			ch_1	= 2'b 01,
    			ch_02	= 2'b 10,
    			ch_2	= 2'b 11;
    
    reg [1:0] present_state;
    reg [1:0] next_state;
    
    always @(posedge clk_up)
    begin
    	case(present_state)
    	ch_01	:	begin	next_state = ch_1;	code[0] = ~code[0];	end
    	ch_1	:	begin	next_state = ch_02;	code[1] = ~code[1];	end
    	ch_02	:   begin	next_state = ch_2;	code[0] = ~code[0];	end
    	ch_2	:   begin	next_state = ch_01;	code[2] = ~code[2]; end
    	endcase
    	
    	present_state = next_state;
    end
    
    always @(posedge clk_down)
    begin
    	case(present_state)
    	ch_01	:	begin	next_state = ch_2;	code[0] = ~code[0];	end  
    	ch_1	:	begin	next_state = ch_01;	code[1] = ~code[1];	end  
    	ch_02	:   begin	next_state = ch_1;	code[0] = ~code[0];	end
    	ch_2	:   begin	next_state = ch_02;	code[2] = ~code[2]; end
    	endcase
    	present_state = next_state;
    end
    
    always @(posedge reset)
    	begin
    		code = 3'b 000;
    		present_state = ch_01;
    	end
endmodule
