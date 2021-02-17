`timescale 1ns / 1ps

module rr_ack_arbiter (
	input clk,
	input reset,
	
	input s_no,
	input ack_in,
	input sfor0, input sfor1,
	input [1:0] req_stat0, input [1:0] req_stat1,
	
	//output reg last_mas,
	
	output reg ack0, output reg ack1
);

localparam W_ACK	= 2'd 2 ; // request sent, waits for ack (added to the queue2) 

reg last_mas;

always @(posedge clk or negedge reset) // ASYNC RESET, active level LOW
if (~reset) // reset 
begin
	ack0 <= 0;
	ack1 <= 0;
	last_mas <= 1; // after reset last_mas is the (N-1)'th Master
end
else
begin
	case (last_mas)
	1: if (sfor1 == s_no && req_stat1 == W_ACK) 
		begin 
		ack0 <= 0; ack1 <= ack_in; 
		last_mas <= 1;
		end
		else if (sfor0 == s_no && req_stat0 == W_ACK) 
			begin
			ack0 <= ack_in; ack1 <= 0; 
			last_mas <= 0;
			end 
			else begin ack0 <= 0; ack1 <= 0; end
	0: if (sfor0 == s_no && req_stat0 == W_ACK) 
		begin 
		ack0 <= ack_in; ack1 <= 0; 
		last_mas <= 0;
		end
		else if (sfor1 == s_no && req_stat1 == W_ACK) 
			begin
			ack0 <= 0; ack1 <= ack_in; 
			last_mas <= 1;
			end
			else begin ack0 <= 0; ack1 <= 0; end
	default if (sfor0 == s_no && req_stat0 == W_ACK) 
			begin 
			ack0 <= ack_in; ack1 <= 0; 
			last_mas <= 0;
			end
			else if (sfor1 == s_no && req_stat1 == W_ACK) 
				begin
				ack0 <= 0; ack1 <= ack_in; 
				last_mas <= 1;
				end
				else begin ack0 <= 0; ack1 <= 0; end
	endcase
end

endmodule