`timescale 1ns / 1ps

module m_block  // number of M/S
(
	input clk,
	input reset,
	// to master
	input req, // connected to req
	input slave_in, // connected to addr 1st bit
	input c, // cmd
	//output reg ack_to_m, // sends ack to master
	
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

always @(posedge clk or negedge reset) // ASYNC RESET, active level LOW

if (~reset) /* reset */
begin
	req_stat <= NO_REQ;
	slave_out <= 0; // mb X?
	cmd <= 0; // mb X?
end
else 
begin
	case (req_stat)
	NO_REQ : 	if (req)
				begin
				req_stat <= WAIT;
				slave_out <= 0; // mb X?
				cmd <= 0; // mb X?
				end 
	WAIT :		begin
				if (req_sent) req_stat <= W_ACK ;
				slave_out <= slave_in;
				end
	W_ACK :		if (ack_in)
				case (cmd)
				1'b0 : req_stat <= W_DATA ; // wait for data
				1'b1 : req_stat <= NO_REQ ; // data written, request done
				default: req_stat <= NO_REQ ;
				endcase
	
	W_DATA :	if (data_read) req_stat <= NO_REQ;
	//default : nothing
	endcase
	
end 



endmodule

