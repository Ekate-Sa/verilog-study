`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2021 20:16:14
// Design Name: 
// Module Name: tb_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "alu_defs.vh"
module tb_alu();
	reg		[31:0]	a, b;
	reg		[2:0]	control;
	wire	[31:0]	y;
	
	alu uut (.a(a), .b(b), .f(control), .y(y));
	
	integer i;
	initial begin
	a = 32'd 25 ;
	b = 32'd 7 ;
	$display ("a = %d ",a,"; b = %d",b);
	
	control = 3'b 0;
	#5;
	$display ("%b", control,"%d",y);
	
	
	for (i=1 ; i < 8 ; i = i+1)
	begin
	control = i;
	if (control != `NOT_USED )
		begin
			#5;
			$display ("%b", control,"%d",y);
		end
	end
	
	//change a b
	a = 32'd 7 ;
	b = 32'd 25 ;
	$display ("a = %d ",a,"; b = %d",b);
	
	control = 3'b 0;
	#5;
	$display ("%b", control,"%d",y);
	#5;
	
	for (i=1 ; i < 8 ; i = i+1)
	begin
	control = i;
	if (control != `NOT_USED )
		begin
			#5;
			$display ("%b", control,"%d",y);
		end
	end
	
	
	end 

endmodule
