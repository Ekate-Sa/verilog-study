`timescale 1ns / 1ps
/* addr, wdata and rdata are always the same individually for every unit 
	only req and cmd change for masters
	and only ack for slaves */

module crossbar_top_tb();
reg clk; reg reset;

reg req0;			reg req1;
reg cmd0;			reg cmd1;
wire [31:0] addr0;	wire [31:0] addr1; // use the same address and wdata

wire [31:0] wdata0;		wire [31:0] wdata1;
wire [31:0] rdata_m0;	wire [31:0] rdata_m1;
wire ack_m0;			wire ack_m1;

reg sfor0; reg sfor1; 
assign addr0 = {sfor0, 3'b000, 28'h000add0};
assign addr1 = {sfor1, 3'b000, 28'h000add1};

assign wdata0 = {32'h000feed0};
assign wdata1 = {32'h000feed1};

wire cmd_s0;			wire cmd_s1;
wire [31:0] addr_s0;	wire [31:0] addr_s1;
wire [31:0] wdata_s0;	wire [31:0] wdata_s1;

wire[31:0] rdata_s0;	wire [31:0] rdata_s1;
reg ack_s0;				reg ack_s1;

assign rdata_s0 = {32'hfeed00c0};
assign rdata_s1 = {32'hfeed00c1};

// test
/*
wire rsent0, rsent1;
wire [1:0] stat0, stat1;
*/
crossbar_top uut(
	.clk(clk), .reset(reset),
	/* test */ .last_mas0(last_mas0), .last_mas1(last_mas1),

// masters
	.master_0_req	(req0),
	.master_0_cmd	(cmd0),
	.master_0_addr	(addr0),
	.master_0_wdata	(wdata0),
	                
	.master_0_rdata	(rdata_m0),
	.master_0_ack	(ack_m0),
	                
	.master_1_req	(req1),
	.master_1_cmd	(cmd1),
	.master_1_addr	(addr1),
	.master_1_wdata	(wdata1),
	                
	.master_1_rdata	(rdata_m1),
	.master_1_ack	(ack_m1),
// s                
	.slave_0_cmd	(cmd_s0),
	.slave_0_addr	(addr_s0),
	.slave_0_wdata	(wdata_s0),
	                
	.slave_0_rdata	(rdata_s0),
	.slave_0_ack	(ack_s0),
	                
	.slave_1_cmd	(cmd_s1),
	.slave_1_addr	(addr_s1),
	.slave_1_wdata	(wdata_s1),
	                
	.slave_1_rdata	(rdata_s1),
	.slave_1_ack	(ack_s1)
	
	//test 
	/*
	.rsent0(rsent0), .rsent1(rsent1),
	.req_stat0(stat0), .req_stat1(stat1)
	*/
);
always
begin
	#1; clk = 0;
	#1; clk = 1;
end

always @(posedge clk)
begin
	if (ack_m0 == 1)
		begin
		req0 = 0;
		case (sfor0)
		0: ack_s0 = 0;
		1: ack_s1 = 0;
		endcase
		end
	if (ack_m1 == 1)
		begin
		req1 = 0;
		case (sfor1)
		0: ack_s0 = 0;
		1: ack_s1 = 0;
		endcase
		end
		
end

initial
begin
	reset = 0; // RESET ADDED 
	#2; reset = 0; #2; reset = 1;
	
	clk = 0;
	ack_s0 = 0; ack_s1 = 0;
	// Sends two reqs to S0 -----------
	
	// 2 reqs to S0
	sfor0 = 0;	sfor1 = 0;
	cmd0 = 0;	cmd1 = 1;
	
	req0 = 1; req1 = 1;
	
	#5;

	ack_s0 = 1; /*#3; ack_s0 = 0; */// M0 waits for data /clk/ req0 to S0 is done
	#5;
	req0 = 1; // new req0 to S1
	sfor0 = 1;
	cmd0 = 1;
	
	#5;
	ack_s0 = 1;/*  #3; ack_s0 = 0; */// req1 to S0 is done
	
	
	#4;
	req1 = 1; // new req1 to S0
	sfor1 = 0;
	cmd1 = 1;
	
	#1;
	ack_s0 = 1;/* #3; ack_s0 = 0;*/// req1 to S0 is done
	#1;
	ack_s1 = 1;/* #3; ack_s1 = 0;*/// req0 to S1 is done
	
	
	

end

endmodule
