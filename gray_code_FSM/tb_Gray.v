`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Gray();
	wire 	[2:0]	code;
	reg				up;
	reg				down;
	reg				reset;
	
	
	Gray_counter uut (.clk_up(up) , .clk_down(down), .code(code), .reset(reset));
	
	integer i;
	
	initial
	begin
		reset = 1; #5; reset = 0; $display ("%b", code);
		
		up = 1; #5; up = 0; #5; /*1*/	$display ("%b", code);	
		up = 1; #5; up = 0; #5; /*2*/   $display ("%b", code);
		up = 1; #5; up = 0; #5; /*3*/   $display ("%b", code);
		
		down = 1; #5; down = 0; #5; /*2*/ $display ("%b", code);
		
		up = 1; #5; up = 0; #5; /*3*/	$display ("%b", code);
		up = 1; #5; up = 0; #5; /*4*/	$display ("%b", code);
		
		reset = 1; #5; reset = 0; 
		$display ("do it again");
		$display ("%b", code);
		
		for (i=0; i<10; i = i+1)
			begin
				up = 1; #5; up = 0; #5;
				$display ("%b", code);
			end
	end
	
endmodule
