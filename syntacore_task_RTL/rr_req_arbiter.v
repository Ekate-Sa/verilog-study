`timescale 1ns / 1ps

module rr_req_arbiter(
	input clk,
	input reset,
	
	input s_no,
	input [1:0] req_stat0, input [1:0] req_stat1,
	
	input sfor0, 			input sfor1,
	input cmd0, 			input cmd1,
	input [31:0] addr0, 	input [31:0] addr1,
	input [31:0] wdata0, 	input [31:0] wdata1,
	
	output reg perm0, // = req_sent0
	output reg perm1,
	
	output reg [31:0] addr_to,
	output reg cmd_to,
	output reg [31:0] wdata_to
    );

localparam WAIT 	= 2'd 1 ; // added to the queue1 

reg last_mas;
	
/* perm0, perm1 also are used as signals to change req_stat WAIT -> W_ACK */
always @(posedge clk or negedge reset) // ASYNC RESET, active level LOW
if (~reset) /* reset */
begin
	last_mas <= 1; // after reset last_mas is the (N-1)'th Master
	perm0 <= 0; perm1 <= 0;
	addr_to <= 0;
	cmd_to <= 0;
	wdata_to <= 0;
end
else
begin
	case (last_mas)
	0: if ((sfor1 == s_no) && (req_stat1 == WAIT)) 
		begin 
		perm0 <= 0; perm1 <= 1; 
		last_mas <= 1;
		
		// when M1        
		addr_to <= addr1;  
		cmd_to <= cmd1;    
		wdata_to <= wdata1;
		
		end
		else if ((sfor0 == s_no) && (req_stat0 == WAIT)) 
			begin
			perm0 <= 1; perm1 <= 0; 
			last_mas <= 0;
			
			// when M0
			addr_to <= addr0;
			cmd_to <= cmd0;
			wdata_to <= wdata0;
			
			end 
			else begin perm0 <= 0; perm1 <= 0; last_mas <= last_mas; end
			
	1: if ((sfor0 == s_no) && (req_stat0 == WAIT)) 
		begin 
		perm0 <= 1; perm1 <= 0; 
		last_mas <= 0;
		
		// when M0
		addr_to <= addr0;
		cmd_to <= cmd0;
		wdata_to <= wdata0;
		
		end
		else if ((sfor1 == s_no) && (req_stat1 == WAIT)) 
			begin
			perm0 <= 0; perm1 <= 1; 
			last_mas <= 1;
			
			// when M1        
			addr_to <= addr1;  
			cmd_to <= cmd1;    
			wdata_to <= wdata1;
			
			end
			else begin perm0 <= 0; perm1 <= 0; last_mas <= last_mas; end
			
	default : if ((sfor0 == s_no) && (req_stat0 == WAIT)) 
			begin 
			perm0 <= 1; perm1 <= 0; 
			last_mas <= 0;
			
			// when M0
			addr_to <= addr0;
			cmd_to <= cmd0;
			wdata_to <= wdata0;
			
			end
			else if ((sfor1 == s_no) && (req_stat1 == WAIT)) 
				begin
				perm0 <= 0; perm1 <= 1; 
				last_mas <= 1;
				
				// when M1
				addr_to <= addr1;
				cmd_to <= cmd1;
				wdata_to <= wdata1;
				
				end
				else begin perm0 <= 0; perm1 <= 0; last_mas <= last_mas; end
	endcase
	
end

endmodule
