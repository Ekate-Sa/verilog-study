`timescale 1ps / 1ps
/*
produces:
- ask to add request to the MtoS_que ;

gets:
- 
*/

/* keeps a request info: slave number, cmd, request status */
// master's request status    



module m_block  // number of M/S
(
	// to master
	input req, // connected to req
	input slave_in, // connected to addr 1st bit
	input c, // cmd
	output reg ack_to_m, // sends ack to master
	
	// to other 
	input ack_in, // gets ack from slave
	input req_sent,  // WAIT to W_ACK
	input data_read, // W_DATA to NO_REQ
	output reg [1:0] req_stat, // ONLY FOR TESTS
	output reg slave_out
    );

localparam WAIT 	= 2'd 1 ; // added to the queue1 
localparam W_ACK	= 2'd 2 ; // request sent, waits for ack (added to the queue2) 
localparam W_DATA	= 2'd 3 ; // cmd = 0 (read), ack came, waits for data
localparam NO_REQ	= 2'd 0 ; // no request (all completed / not requested)


reg cmd;


always @(posedge req) // new request
begin
	req_stat = WAIT ; // status wait
	slave_out = slave_in;// note slave, cmd
	cmd = c ;	
end

always @(negedge req) 
begin
	req_stat = NO_REQ ; 
end

always @(posedge ack_in)
begin
	case (cmd)
	1'b0 : req_stat = W_DATA ; // wait for data
	1'b1 : req_stat = NO_REQ ; // data written, request done
	default: req_stat = NO_REQ ;
	endcase
	ack_to_m = 1 ;
end

always @(posedge req_sent)
begin
	req_stat = W_ACK;
end

always @(posedge data_read)
begin
	if (req_stat == W_DATA) req_stat = NO_REQ ;
end

endmodule

/*
// mb not needed
module ack_seeker (
	input [1:0] slave,
	input [1:0][3:0] stat ,
	
	output reg [1:0] acks,
	
	input ack_in,
	input s_no // slave number
);

always @(posedge ack_in)
	begin
	if (s_no == slave[0] && stat[0] == W_ACK) acks[0] = ack_in; else acks[0] = 0;
	if (s_no == slave[1] && stat[1] == W_ACK) acks[1] = ack_in; else acks[1] = 0;
	end
	
endmodule
*/

