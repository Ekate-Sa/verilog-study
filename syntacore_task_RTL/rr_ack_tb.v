`timescale 1ns / 1ps

module rr_ack_tb();

reg [1:0] stat0, stat1;
reg sfor0, sfor1;
reg ack_s0, ack_s1;

rr_ack_arbiter uut0 (
	.s_no(1'b0),
	.ack_in(ack_s0),
	.sfor0(sfor0), .sfor1(sfor1),
	.req_stat0(stat0), .req_stat1(stat1),
	
	.ack0(ack_m0_0), .ack1(ack_m1_0)
);
/*rr_ack_arbiter uut1 (
	.s_no(1'b1),
	.ack_in(ack_s1),
	.sfor0(sfor0), .sfor1(sfor1),
	.req_stat0(stat0), .req_stat1(stat1),
	
	.ack0(ack_m0_1), .ack1(ack_m1_1)
);*/

localparam WAIT 	= 2'd 1 ; // added to the queue1 
localparam W_ACK	= 2'd 2 ; // request sent, waits for ack (added to the queue2) 
localparam W_DATA	= 2'd 3 ; // cmd = 0 (read), ack came, waits for data
localparam NO_REQ	= 2'd 0 ; // no request (all completed / not requested)



wire ack_m0 = ack_m0_0/* | ack_m0_1 */;
wire ack_m1 = ack_m1_0 /*| ack_m1_1 */;

integer i, j;

initial begin
	for (i = 0; i<4; i = i+1)
		for (j = 0; j<4; j = j+1)
		begin
		sfor0 = 1'b0; sfor1 = 1'b0;
		
				ack_s0 = 0; ack_s1 = 0;
				stat0 = i; stat1 = j;
				
				#2;
				ack_s0 = 1; ack_s1 = 1;
				#1;/*
				$display("M0_S: %b", sfor0, " stat:%d", stat0," ACK0 = %b", ack_m0);
				$display("M1_S: %b", sfor1, " stat:%d", stat1," ACK1 = %b", ack_m1);
				$display("------------------------------------------------------");*/
				#2;
		
		sfor0 = 1'b0; sfor1 = 1'b1;
		
				ack_s0 = 0; ack_s1 = 0;
				stat0 = i; stat1 = j;
				
				#2;
				ack_s0 = 1; ack_s1 = 1;
				#1;/*
				$display("M0_S: %b",sfor0, " stat:%d", stat0," ACK0 = %b", ack_m0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," ACK1 = %b", ack_m1);
				$display("------------------------------------------------------");*/
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b0;
		
				ack_s0 = 0; ack_s1 = 0;
				stat0 = i; stat1 = j;
				
				#2;
				ack_s0 = 1; ack_s1 = 1;
				#1;
				$display("M0_S: %b",sfor0, " stat:%d", stat0," ACK0 = %b", ack_m0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," ACK1 = %b", ack_m1);
				$display("------------------------------------------------------");
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b1;
				
				ack_s0 = 0; ack_s1 = 0;
				stat0 = i; stat1 = j;
				
				#2;
				ack_s0 = 1; ack_s1 = 1;
				#1;
				$display("M0_S: %b",sfor0, " stat:%d", stat0," ACK0 = %b", ack_m0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," ACK1 = %b", ack_m1);
				$display("------------------------------------------------------");
				#2;
		end
end

endmodule
