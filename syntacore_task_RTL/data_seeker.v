`timescale 1ns / 1ps

module data_seeker ( // only 1 master may be waiting for rdata
input clk, // data comes with a clock
input reset,

input slave1,
input slave0,
input [1:0] stat1,
input [1:0] stat0,

output reg [31:0] rdata1,
output reg [31:0] rdata0,

output reg data_read0, output reg data_read1,

input [31:0] rdata_in,
input s_no // slave number, constant
);

localparam W_DATA	= 2'd 3 ; // cmd = 0 (read), ack came, waits for data

always @(posedge clk or negedge reset) // ASYNC RESET, active level LOW
if (~reset) /* reset */
	begin
	data_read0 <= 0; data_read1 <= 0;
	rdata0 <= 0 ;
	rdata1 <= 0 ;
	end
else
	begin
	
	if ((s_no == slave0) && (stat0 == W_DATA)) 
		begin 
		rdata0 <= rdata_in; data_read0 <= 1; 
		rdata1 <= 0; 
		end 
	else  if ((s_no == slave1) && (stat1 == W_DATA)) 
		begin 
		rdata1 <= rdata_in; data_read1 <= 1;
		rdata0 <= 0; data_read0 <= 0; 
		end 
	else begin rdata0 <= 0; rdata1 <= 0; data_read0 <= 0; data_read1 <= 0; end
	
	end
	
endmodule