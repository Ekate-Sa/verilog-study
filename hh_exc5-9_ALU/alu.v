`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Упражнение 5.9 Спроектируйте 32-разрядное АЛУ, показанное на Рис. 5.15,
//с использованием вашего любимого языка описания аппаратуры. Модуль
//верхнего уровня может быть или структурным или поведенческим.
//
/*
FUNCTIONS:
F2:0 Function
000 A AND B
001 A OR B
010 A + B
011 not used
100 A AND B?
101 A OR B?
110 A - B
111 SLT - "set if less then" A<B ? y=1 : y = 0
*/
//////////////////////////////////////////////////////////////////////////////////


module alu(
	input		[31:0]	a ,
	input 	 	[31:0]	b,
	
	input		[3:0]	f, 
	
	output 	reg [31:0]	y 
    );
    
    reg	[31:0]	bb;
    reg	[30:0]	s; //N-1
    
    wire [1:0]	f1 = f[1:0];
    wire		f2 = f[2];
    
    reg	[31:0]	in0;
    reg	[31:0]	in1;
    reg	[31:0]	in2;
    reg	[31:0]	in3;
    
    always @(*)
    
    begin
    case (f2)
    	0:	
    		begin
    		bb = b ;
    		end
    	1:	bb =  ~b; 
    	default: bb = b ;
    endcase
    
    in0 = a & bb ;
    in1 = a | bb ;
    
	s = a + bb + f2;
    in2 = s;
    
    in3 = {1'b0, s};
    
    case (f1)
    	2'b00:	y = in0;
    	2'b01:	y = in1;
    	2'b10:	y = in2;
    	2'b11:	y = in3;
    	default: y = 32'b 0;
    endcase
    
    end
    
    
    
    
    
endmodule
