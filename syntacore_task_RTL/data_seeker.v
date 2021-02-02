module rdata_seeker ( // only 1 master may be waiting for rdata
input clk, // data comes with a clock
input slave1,
input slave0,
input [1:0] stat1,
input [1:0] stat0,

output reg [31:0] rdata1,
output reg [31:0] rdata0,

input [31:0] rdata_in,
input s_no // slave number, constant
);
localparam WAIT 	= 2'd 1 ; // added to the queue1 
localparam W_ACK	= 2'd 2 ; // request sent, waits for ack (added to the queue2) 
localparam W_DATA	= 2'd 3 ; // cmd = 0 (read), ack came, waits for data
localparam NO_REQ	= 2'd 0 ; // no request (all completed / not requested)

always @(posedge clk)
	begin
	if ((s_no == slave0) && (stat0 == W_DATA)) rdata0 = rdata_in; else rdata0 = 0; // master_i_rdata = rdatas0 | rdatas1 ; (bit-wise)
	if ((s_no == slave1) && (stat1 == W_DATA)) rdata1 = rdata_in; else rdata1 = 0;
	end


endmodule