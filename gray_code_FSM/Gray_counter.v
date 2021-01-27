`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Упражнение 3.27 У кода Грея есть полезное свойство: коды соседних чисел
//отличаются друг от друга только в одном разряде. В Табл. 3.23 представлен
//3-разрядный код Грея, представляющий числовую последовательность от 0 до 7.
//Спроектируйте 3-разрядный автомат счетчика в коде Грея по модулю 8. У
//автомата нет входов, но есть 3 выхода. (Счётчик по модулю N считает от 0 до
//N-1, затем цикл повторяется. Например, в часах используется счётчик по
//модулю 60 для того чтобы считать минуты и секунды от 0 до 59.) После сброса 
//на счетчике должно быть 000. По каждому фронту тактового сигнала счетчик
//должен переходить к следующему коду Грея. По достижении кода 100 счётчик
//должен опять перейти к коду 000.

//Упражнение 3.28 Усовершенствуйте свой автомат счетчика в коде Грея
//из упражнения 3.27 так, чтобы от мог считать как вверх, так и вниз. У счётчика
//появится вход ВВЕРХ. Если ВВЕРХ=1, то счётчик будет переходить к
//следующему коду, а если ВВЕРХ=0 - то к предыдущему.

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
