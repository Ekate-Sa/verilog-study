`timescale 1ns / 1ps

module rr_req_tb();

reg [1:0] stat0, stat1;
reg sfor0, sfor1;
reg clk;
reg reset;

reg cmd0; reg cmd1;
wire [31:0] addr0 ;
wire [31:0] addr1 ;
wire [31:0] addr_to0 ; wire [31:0] addr_to1 ;
                 
wire [31:0] wdata0;
wire [31:0] wdata1;
wire [31:0] wdata_to0; wire [31:0] wdata_to1;

rr_req_arbiter uut0 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b0),
	.req_stat0(stat0), .req_stat1(stat1),
	
	.sfor0(sfor0), .sfor1(sfor1),
	.cmd0(cmd0), .cmd1(cmd1),
	.addr0(addr0), .addr1(addr1),
	.wdata0(wdata0), .wdata1(wdata1),
	
	.perm0(req_sent0_s0),
	.perm1(req_sent1_s0),
	
	.addr_to(addr_to0), .cmd_to(cmd_to0), .wdata_to(wdata_to0)
    );

rr_req_arbiter uut1 (
	.clk(clk), .reset(reset),
	
	.s_no(1'b1),
	.req_stat0(stat0), .req_stat1(stat1),
	
	.sfor0(sfor0), .sfor1(sfor1),
	.cmd0(cmd0), .cmd1(cmd1),
	.addr0(addr0), .addr1(addr1),
	.wdata0(wdata0), .wdata1(wdata1),
	
	.perm0(req_sent0_s1),
	.perm1(req_sent1_s1),
	
	.addr_to(addr_to1), .cmd_to(cmd_to1), .wdata_to(wdata_to1)
    );

integer i, j;

assign addr0 = {sfor0, 3'b000, 28'h000add0};
assign addr1 = {sfor1, 3'b000, 28'h000add1};

assign wdata0 = {32'h000feed0};
assign wdata1 = {32'h000feed1};



initial 
begin
	reset = 0; #1; reset = 1;
	cmd0 = 1; cmd1 = 1;

	

	for (i = 0; i<4; i = i+1)
		for (j = 0; j<4; j = j+1)
		begin
		sfor0 = 1'b0; sfor1 = 1'b0;
		
		
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				/*$display("M0_S: %b", sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b", sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");*/
				#2;
		
		sfor0 = 1'b0; sfor1 = 1'b1;
		/*
		addr0 = {sfor0, 3'b000, 28'h000add0};
		addr1 = {sfor1, 3'b000, 28'h000add1};*/
		
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				/*$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");*/
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b0;
		/*
		addr0 = {sfor0, 3'b000, 28'h000add0};
		addr1 = {sfor1, 3'b000, 28'h000add1};*/
		
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				/*$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");*/
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b1;
		/*
		addr0 = {sfor0, 3'b000, 28'h000add0};
		addr1 = {sfor1, 3'b000, 28'h000add1};*/
				
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				/*$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");*/
				#2;
		end
	
end



endmodule
