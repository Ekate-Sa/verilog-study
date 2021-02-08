`timescale 1ps / 1ps

/* keeps a request info: slave number, cmd, request status 
req_status changes */

module m_block_tb();

reg m_req, cmd; 
reg slave_in; // from request
reg ack_s;
reg req_sent, data_read;

wire [1:0] req_stat;
wire slave, ack_m; // slave number to other

m_block uut 
(
	.req(m_req), 
	.slave_in(slave_in), 
	.c(cmd), // cmd            
 	
                     
    .req_sent(req_sent), .data_read(data_read),           
	.ack_in(ack_s), // gets ack f
 	.req_stat(req_stat), 
 	.slave_out(slave)            // ONLY FOR TESTS
);
/*
always @(posedge ack_m) 
begin
	#1;
	m_req = 0;
end
*/
initial begin
	// do reqest to S0 cmd = 1 (WRITE)
	ack_s = 0;
	cmd = 1;
	slave_in = 0;
	m_req = 0; #5; m_req = 1; #5;
	
	$display("S%b",slave," cmd = %b",cmd, " status: %d",req_stat);
	req_sent = 1; #2;
	ack_s = 1; #2; 
	$display("new status: %d", req_stat/*," ack=%b", ack_m*/);
	
	// do request to S1 cmd = 0 (READ)
	ack_s = 0;
	cmd = 0;
	slave_in = 1;
	m_req = 1; #5;
	
	$display("S%b",slave," cmd = %b",cmd, " status: %d",req_stat);
	req_sent = 1; #2;
	ack_s = 1; #2; ack_s = 0;
	$display("new status: %d", req_stat/*," ack=%b", ack_m*/);
	#5; data_read = 1;
	#1; 
	$display("new status: %d", req_stat);
end


endmodule
