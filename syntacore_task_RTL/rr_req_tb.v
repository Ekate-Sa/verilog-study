`timescale 1ns / 1ps

module rr_req_tb();

reg [1:0] stat0, stat1;
reg sfor0, sfor1;
reg clk;

reg cmd0; reg cmd1;
reg [31:0] addr0 ;
reg [31:0] addr1 ;
wire [31:0] addr ;
                 
reg [31:0] wdata0;
reg [31:0] wdata1;
wire [31:0] wdata;

rr_req_arbiter uut (
	.clk(clk),
	.s_no(1'b0),
	.req_stat0(stat0), .req_stat1(stat1),
	
	.sfor0(sfor0), .sfor1(sfor1),
	.cmd0(cmd0), .cmd1(cmd1),
	.addr0(addr0), .addr1(addr1),
	.wdata0(wdata0), .wdata1(wdata1),
	
	.perm0(req_sent0),
	.perm1(req_sent1),
	
	.addr_to(addr), .cmd_to(cmd), .wdata_to(wdata)
    );

integer i, j;

initial 
begin
	cmd0 = 1; cmd1 = 1;

	wdata0 = {4'b0000,28'b0000_0000_1111_0000_1111_0000_1111};
	wdata1 = {4'b0000,28'b0000_1111_0000_1111_0000_1111_0000};

	for (i = 0; i<4; i = i+1)
		for (j = 0; j<4; j = j+1)
		begin
		sfor0 = 1'b0; sfor1 = 1'b0;
		
		addr0 = {sfor0,3'b000,28'b0000_0000_0000_0000_0000_0000_1111};
		addr1 = {sfor1,3'b000,28'b0000_0000_0000_0000_0000_1111_0000};
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				$display("M0_S: %b", sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b", sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");
				#2;
		
		sfor0 = 1'b0; sfor1 = 1'b1;
		
		addr0 = {sfor0,3'b000,28'b0000_0000_0000_0000_0000_0000_1111};
		addr1 = {sfor1,3'b000,28'b0000_0000_0000_0000_0000_1111_0000};
		
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b0;
		
		addr0 = {sfor0,3'b000,28'b0000_0000_0000_0000_0000_0000_1111};
		addr1 = {sfor1,3'b000,28'b0000_0000_0000_0000_0000_1111_0000};
		
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");
				#2;
				
		sfor0 = 1'b1; sfor1 = 1'b1;
		
		addr0 = {sfor0,3'b000,28'b0000_0000_0000_0000_0000_0000_1111};
		addr1 = {sfor1,3'b000,28'b0000_0000_0000_0000_0000_1111_0000};
				
				clk = 0;
				stat0 = i; stat1 = j;
				
				#2;
				clk = 1;
				#1;
				$display("M0_S: %b",sfor0, " stat:%d", stat0," PERM0 = %b", req_sent0);
				$display("M1_S: %b",sfor1, " stat:%d", stat1," PERM1 = %b", req_sent1);
				$display("cmd: %b",cmd);
				$display("addr: %b", addr);
				$display("wdata: %b", wdata);
				$display("------------------------------------------------------");
				#2;
		end
	
end



endmodule
