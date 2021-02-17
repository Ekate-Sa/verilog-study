`timescale 1ns / 1ps

module crossbar_top(
	
	input clk,
	input reset,
// masters
	input master_0_req,
	input master_0_cmd,
	input [31:0] master_0_addr,
	input [31:0] master_0_wdata,
	
	output[31:0] master_0_rdata,
	output wire master_0_ack,
	
	input master_1_req,
	input master_1_cmd,
	input [31:0] master_1_addr,
	input [31:0] master_1_wdata,
	
	output [31:0] master_1_rdata,
	output wire master_1_ack,
// slaves	
	output slave_0_cmd,
	output [31:0] slave_0_addr,
	output [31:0] slave_0_wdata,
	
	input [31:0] slave_0_rdata,
	input slave_0_ack,
	
	output slave_1_cmd,
	output [31:0] slave_1_addr,
	output [31:0] slave_1_wdata,
	
	input [31:0] slave_1_rdata,
	input slave_1_ack
	
	//test 
	/*
	output rsent0, 
	output rsent1,
	output req_stat0, output req_stat1
	*/
    );

wire sfor0, sfor1;
assign sfor0 = master_0_addr[31];
assign sfor1 = master_1_addr[31];

wire dr0, dr1; // data_read signal to master
wire rsent0, rsent1; // req_sent signal to master
wire [1:0] req_stat0; wire [1:0] req_stat1;

/* master's request buffers */
m_block  mbuf0(
	.clk(clk), .reset(reset),
	
	.req(master_0_req), .c(master_0_cmd), .slave_in(master_0_addr[31]),
	
	.ack_in(master_0_ack), .req_sent(rsent0), .data_read(dr0),
	.req_stat(req_stat0), .slave_out(sfor0)
);
m_block  mbuf1(
	.clk(clk), .reset(reset),
	
	.req(master_1_req), .c(master_1_cmd), .slave_in(master_1_addr[31]),
	
	.ack_in(master_1_ack), .req_sent(rsent1), .data_read(dr1),
	.req_stat(req_stat1), .slave_out(sfor1)
); 

// DATA SEEKERS
wire [31:0] rdata_s0_m0, rdata_s0_m1, rdata_s1_m0, rdata_s1_m1;
wire data_read0_s0, data_read0_s1, data_read1_s0, data_read1_s1;

/* sends data from each slave */
data_seeker sdata0 (
	.clk(clk), .reset(reset),
	
	.slave0(sfor0), .slave1(sfor1),
	.stat0(req_stat0), .stat1(req_stat1),
	.rdata0(rdata_s0_m0), .rdata1(rdata_s0_m1),
	
	.rdata_in(slave_0_rdata), .s_no(1'b0),
	
	.data_read0(data_read0_s0), .data_read1(data_read1_s0)
);

data_seeker sdata1 (
	.clk(clk), .reset(reset),
	
	.slave0(sfor0), .slave1(sfor1),
	.stat0(req_stat0), .stat1(req_stat1),
	.rdata0(rdata_s1_m0), .rdata1(rdata_s1_m1),
	
	.rdata_in(slave_1_rdata), .s_no(1'b1),
	
	.data_read0(data_read0_s1), .data_read1(data_read1_s1)
);

assign master_0_rdata = rdata_s0_m0 | rdata_s1_m0; // bitwise OR
assign master_1_rdata = rdata_s0_m1 | rdata_s1_m1;

assign dr0 = data_read0_s0 | data_read0_s1 ; // goes to mbuf0|1
assign dr1 = data_read1_s0 | data_read1_s1 ;


// ACK-ARBITERS
wire ack_s0_m0, ack_s0_m1, ack_s1_m0, ack_s1_m1;
//S0
rr_ack_arbiter ack_from0 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b0),
	.ack_in(slave_0_ack),
	.sfor0(sfor0), .sfor1(sfor1),
	.req_stat0(req_stat0), .req_stat1(req_stat1),
	
	.ack0(ack_s0_m0), .ack1(ack_s0_m1)
);
//S1
rr_ack_arbiter ack_from1 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b1),
	.ack_in(slave_1_ack),
	.sfor0(sfor0), .sfor1(sfor1),
	.req_stat0(req_stat0), .req_stat1(req_stat1),
	
	.ack0(ack_s1_m0), .ack1(ack_s1_m1)
);

assign master_0_ack = ack_s0_m0 | ack_s1_m0; // goes to master and mbuf (change req status)
assign master_1_ack = ack_s0_m1 | ack_s1_m1;

// REQ ARBITERS
wire req_sent0_m0, req_sent0_m1, req_sent1_m0, req_sent1_m1;
//S0
rr_req_arbiter req_arb0 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b0),
	.req_stat0(req_stat0), 		.req_stat1(req_stat1), 
	
	.sfor0(sfor0), 				.sfor1(sfor1), 
	.cmd0(master_0_cmd), 		.cmd1(master_1_cmd), 
	.addr0(master_0_addr), 		.addr1(master_1_addr),
	.wdata0(master_0_wdata), 	.wdata1(master_1_wdata),
	
	.perm0(req_sent0_m0), // signal is used in block and also goes to mbuf to change the req status
	.perm1(req_sent0_m1),
	
	.addr_to(slave_0_addr), .cmd_to(slave_0_cmd), .wdata_to(slave_0_wdata) 
    );
//S1
rr_req_arbiter req_arb1 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b1),
	.req_stat0(req_stat0), 		.req_stat1(req_stat1), 
	
	.sfor0(sfor0), 				.sfor1(sfor1), 
	.cmd0(master_0_cmd), 		.cmd1(master_1_cmd), 
	.addr0(master_0_addr), 		.addr1(master_1_addr),
	.wdata0(master_0_wdata), 	.wdata1(master_1_wdata),
	
	.perm0(req_sent1_m0),
	.perm1(req_sent1_m1),
	
	.addr_to(slave_1_addr), .cmd_to(slave_1_cmd), .wdata_to(slave_1_wdata)
    );

assign rsent0 = req_sent0_m0 | req_sent1_m0 ;
assign rsent1 = req_sent0_m1 | req_sent1_m1 ;

endmodule
