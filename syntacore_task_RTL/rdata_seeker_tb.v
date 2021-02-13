`timescale 1ps / 1ps
/*
module rdata_seeker ( // only 1 master may be waiting for rdata
input clk, // data comes with a clock
input [1:0] slave,
input [1:0] [3:0] stat,

output reg [1:0] [31:0] rdatas,

input [31:0] rdata_in,
input s_no // slave number, constant
);
localparam WAIT 	= 2'd 1 ; // added to the queue1 
localparam W_ACK	= 2'd 2 ; // request sent, waits for ack (added to the queue2) 
localparam W_DATA	= 2'd 3 ; // cmd = 0 (read), ack came, waits for data
localparam NO_REQ	= 2'd 0 ; // no request (all completed / not requested)

*/


module data_seeker_tb();

reg clk;
reg sfor0, sfor1;

wire [31:0] rdata0, rdata1;
wire dr0, dr1; // data read signals
reg [1:0] stat0, stat1;


reg [31:0] data_come;
wire s_no = 0;

localparam WAIT 	= 2'd 1 ; 
localparam W_ACK	= 2'd 2 ; 
localparam W_DATA	= 2'd 3 ;
localparam NO_REQ	= 2'd 0 ;

rdata_seeker uut ( 
.clk(clk), 
.slave1(sfor1), .slave0(sfor0),
.stat1(stat1), .stat0(stat0),
.rdata1(rdata1), .rdata0(rdata0),
.rdata_in(data_come),
.s_no(s_no),

.data_read0(dr0), .data_read1(dr1)
);

initial begin
	
	clk = 0;
	sfor0 = 0; stat0 = WAIT;
	sfor1 = 1; stat1 = W_DATA;
	
	data_come = {28'b0,4'b1111};
	#2; clk = 1; #2;
	$display("to 0: %b | dr0=%b ;;",rdata0, dr0, "; to 1: %b | dr1=%b ;;",rdata1,dr1);
	
	#5;
	clk = 0;
	sfor0 = 0; stat0 = W_DATA;
	sfor1 = 1; stat1 = NO_REQ;
	
	 #2; clk = 1; #2;
	$display("to 0: %b | dr0=%b ;;",rdata0, dr0, "; to 1: %b | dr1=%b ;;",rdata1,dr1);
	#5; clk = 0; 
	
	sfor0 = 0; stat0 = W_DATA;
	sfor1 = 1; stat1 = W_DATA;
	#2; clk = 1; #2;
	$display("to 0: %b | dr0=%b ;;",rdata0, dr0, "; to 1: %b | dr1=%b ;;",rdata1,dr1);
end

endmodule
