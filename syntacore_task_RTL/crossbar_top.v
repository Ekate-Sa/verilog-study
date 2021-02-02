`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 18:51:24
// Design Name: 
// Module Name: crossbar_top
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


module crossbar_top(
// masters
	input master_0_req,
	input master_0_cmd,
	input [31:0] master_0_addr,
	input [31:0] master_0_wdata,
	
	output[31:0] master_0_rdata,
	output master_0_ack,
	
	input master_1_req,
	input master_1_cmd,
	input [31:0] master_1_addr,
	input [31:0] master_1_wdata,
	
	output [31:0] master_1_rdata,
	output master_1_ack,
// slaves	
	input slave_0_cmd,
	input [31:0] slave_0_addr,
	input [31:0] slave_0_wdata,
	
	output [31:0] slave_0_rdata,
	output slave_0_ack,
	
	input slave_1_cmd,
	input [31:0] slave_1_addr,
	input [31:0] slave_1_wdata,
	
	output [31:0] slave_1_rdata,
	output slave_1_ack
    );
/* master's request buffers */
m_block  mbuf0(
	/*to*/.req(master_0_req), .c(master_0_cmd), .slave_in(master_0_addr[31]),
	.ack_to_m(master_0_ack),
	/*to*/.ack_in(/**/),
	.req_stat(req_stat0), .slave_out(sfor0)
);
m_block  mbuf1(
	/*to*/.req(master_1_req), .c(master_1_cmd), .slave_in(master_1_addr[31]),
	.ack_to_m(master_1_ack),
	/*to*/.ack_in(/**/),
	.req_stat(req_stat1), .slave_out(sfor1)
); 


/* sends data from each slave */
rdata_seeker sdata0 (
	.clk(clk),
	.slave0(sfor0), .slave1(sfor1),
	.stat0(req_stat0), .stat1(req_stat1),
	.rdata0(rdata_s0_m0), .rdata1(rdata_s0_m1),
	.rdata_in(slave_0_rdata), .s_no(1)
);

rdata_seeker sdata1 (
	.clk(clk),
	.slave0(sfor0), .slave1(sfor1),
	.stat0(req_stat0), .stat1(req_stat1),
	.rdata0(rdata_s1_m0), .rdata1(rdata_s1_m1),
	.rdata_in(slave_1_rdata), .s_no(0) 
);

assign master_0_rdata = rdata_s0_m0 | rdata_s1_m0; // bitwise OR
assign master_1_rdata = rdata_s0_m1 | rdata_s1_m1;
  
    
endmodule
