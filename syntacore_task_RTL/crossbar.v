`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
req - ���������� ������, ������ �� ���������� ����������
(master-> slave)

addr - 32-������ ����, �������� ����� ������� (master-
>slave)
cmd - ���������� ������ - ������� ��������: 0 - read, 1 -
write (master->slave)

wdata - 32-������ ����, �������� ������������ ������.
���������� � ��� �� ����� , ��� � ����� (master-> slave)
ack - ���������� ������-�������������, ��� � ������ �����
slave ������ ������ � ���������� (slave->master). ��� ����, slave ������
������������� _addr, _cmd, � _wdata (� ������ ���������� ������). �������
_ack � �������� ��������� ��������� master ���������� ����� ������ �
��������� �����

rdata - 32-������ ����, �������� ����������� ������.
���������� �� ��������� ����� ����� ������������� ����������(_ack = 1)(slave-
> master)
------------------------
����� slave ���������� ������������ ������� ����� ������. �������� �����
����������� master ��������� � ���� slave ���������� �������������� �� ����������
"round-robin".
*/
//////////////////////////////////////////////////////////////////////////////////

module crossbar(
	input		clk,
	
	// masters
	input			master_0_req,	 input			master_1_req,				             
	input	[31:0]	master_0_addr,   input	[31:0]	master_1_addr,      	    
	input			master_0_cmd,    input			master_1_cmd,       	         
	input 	[31:0]	master_0_wdata,  input 	[31:0]	master_1_wdata,     	  
	output 			master_0_ack,    output 		master_1_ack,       	        
	output	[31:0]	master_0_rdata,  output	[31:0]	master_1_rdata,  
	
	input			master_2_req,	 input			master_3_req,				             
	input	[31:0]	master_2_addr,   input	[31:0]	master_3_addr,      	    
	input			master_2_cmd,    input			master_3_cmd,       	         
	input 	[31:0]	master_2_wdata,  input 	[31:0]	master_3_wdata,     	  
	output 			master_2_ack,    output 		master_3_ack,       	        
	output	[31:0]	master_2_rdata,  output	[31:0]	master_3_rdata,   	   
	
	// slaves
	output			slave_0_req,	 output			slave_1_req,					        
	output	[31:0]	slave_0_addr,    output	[31:0]	slave_1_addr,       	    
	output			slave_0_cmd,     output			slave_1_cmd,        	         
	output 	[31:0]	slave_0_wdata,   output	[31:0]	slave_1_wdata,      	   
	input 			slave_0_ack,     input 			slave_1_ack,        	        
	input	[31:0]	slave_0_rdata,   input	[31:0]	slave_1_rdata, 
	
	output			slave_2_req,	 output			slave_3_req,					        
	output	[31:0]	slave_2_addr,    output	[31:0]	slave_3_addr,       	    
	output			slave_2_cmd,     output			slave_3_cmd,        	         
	output 	[31:0]	slave_2_wdata,   output	[31:0]	slave_3_wdata,      	   
	input 			slave_2_ack,     input 			slave_3_ack,        	        
	input	[31:0]	slave_2_rdata,   input	[31:0]	slave_3_rdata      	  
	                                
    );
    
    reg [1:0] mfor_s0;	reg rest0; // if rest0 = 1 then there's no req for S0
    reg [1:0] mfor_s1;	reg rest1;
    reg [1:0] mfor_s2;	reg rest2;
    reg [1:0] mfor_s3;	reg rest3;
    
    always @(posedge clk)
    begin
    
    
    //round robin ?
    // S0
    if (master_0_req != 1'b1 || master_0_addr[31:30] != 2'b00)
    	if (master_1_req != 1'b1 || master_1_addr[31:30] != 2'b00)
    		if (master_2_req != 1'b1 || master_2_addr[31:30] != 2'b00)
    			if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b00)
    				/* do reqest from M0 */
    				mfor_s0 = 2'b 11;
    			else rest0 = 1'b 1;
    		else mfor_s0 = 2'b 10;
    	else mfor_s0 = 2'b 01;
    else mfor_s0 = 2'b 00;
    	
    // S1 VARIANT 2
    if (master_0_req != 1'b1 || master_0_addr[31:30] != 2'b01)
    	if (master_1_req != 1'b1 || master_1_addr[31:30] != 2'b01)
    		if (master_2_req != 1'b1 || master_2_addr[31:30] != 2'b01)
    			if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b01)
    				/* do reqest from M0 */
    				mfor_s1 = 2'b 11;
    			else rest1 = 1'b 1;
    		else mfor_s1 = 2'b 10;
    	else mfor_s1 = 2'b 01;
    else mfor_s1 = 2'b 00;
    
    // S2
    if (master_0_req != 1'b1 || master_0_addr[31:30] != 2'b10)
    	if (master_1_req != 1'b1 || master_1_addr[31:30] != 2'b10)
    		if (master_2_req != 1'b1 || master_2_addr[31:30] != 2'b10)
    			if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b10)
    				/* do reqest from M0 */
    				mfor_s2 = 2'b 11;
    			else rest2 = 1'b 1;
    		else mfor_s2 = 2'b 10;
    	else mfor_s2 = 2'b 01;
    else mfor_s2 = 2'b 00;
    	
    // S3
    if (master_0_req != 1'b1 || master_0_addr[31:30] != 2'b11)
    	if (master_1_req != 1'b1 || master_1_addr[31:30] != 2'b11)
    		if (master_2_req != 1'b1 || master_2_addr[31:30] != 2'b11)
    			if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b11)
    				/* do reqest from M0 */
    				mfor_s2 = 2'b 11;
    			else rest2 = 1'b 1;
    		else mfor_s2 = 2'b 10;
    	else mfor_s2 = 2'b 01;
    else mfor_s2 = 2'b 00;
    	
    end
                                  
endmodule
