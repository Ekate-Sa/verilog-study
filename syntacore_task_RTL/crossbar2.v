`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
req - однобитный сигнал, запрос на выполнение транзакции
(master-> slave)

addr - 32-битный шина, содержит адрес запроса (master-
>slave)
cmd - однобитный сигнал - признак операции: 0 - read, 1 -
write (master->slave)

wdata - 32-битный шина, содержит записываемые данные.
передаются в том же такте , что и адрес (master-> slave)
ack - однобитный сигнал-подтверждение, что в данном такте
slave принял запрос к исполнению (slave->master). при этом, slave должен
зафиксировать _addr, _cmd, и _wdata (в случае транзакции записи). перевод
_ack в активное состояние разрешает master устройству снять запрос в
следующем такте

rdata - 32-битная шина, содержит считываемые данные.
передаются на следующем такте после подтверждения транзакции(_ack = 1)(slave-
> master)
------------------------
Выбор slave устройства определяется старшим битом адреса. Арбитраж между
несколькими master запросами в одно slave устройство осуществляется по дисциплине
"round-robin".
*/
//////////////////////////////////////////////////////////////////////////////////



module crossbar(
	input		clk,
	
	// masters
	input			    master_0_req,	 input		    	master_1_req,				             
	input	   [31:0]	master_0_addr,   input	    [31:0]	master_1_addr,      	    
	input		    	master_0_cmd,    input	    		master_1_cmd,       	         
	input 	   [31:0]	master_0_wdata,  input 	    [31:0]	master_1_wdata,     	  
	output reg			master_0_ack,    output reg		    master_1_ack,       	        
	output reg [31:0]	master_0_rdata,  output	reg [31:0]	master_1_rdata,  
	  	   
	// slaves
	output reg			slave_0_req,	 output	reg 		slave_1_req,					        
	output reg	[31:0]	slave_0_addr,    output	reg [31:0]	slave_1_addr,       	    
	output reg			slave_0_cmd,     output	reg 		slave_1_cmd,        	         
	output reg 	[31:0]	slave_0_wdata,   output	reg [31:0]	slave_1_wdata,      	   
	input 			    slave_0_ack,     input 	    		slave_1_ack,        	        
	input	    [31:0]	slave_0_rdata,   input	    [31:0]	slave_1_rdata 
	                                
    );
    		
	wire m0_s0 = master_0_req & (~master_0_addr[31]);
    wire m0_s1 = master_0_req & (master_0_addr[31]);
    
    wire m1_s0 = master_1_req & (~master_1_addr[31]);
    wire m1_s1 = master_1_req & (master_0_addr[31]);
	
	reg nomas_0, nomas_1; // ready for new request
	reg mfor_0, mfor_1; // master for s1|2
	reg cmd_0, cmd_1; 
	
	reg ready_data0, ready_data1;
	
	wire s0_ack = slave_0_ack;
	wire s1_ack = slave_1_ack;
	
    always @(posedge clk)
    begin
    
    /* выполнение оставшихся запросов на чтение*/
    if (~cmd_0 && ready_data0 )	// rdata comes from S0
    	case (mfor_0)
    	0 : begin master_0_rdata = slave_0_rdata ; nomas_0 = 1; end 
    	1 : begin master_1_rdata = slave_0_rdata ; nomas_0 = 1; end
    	endcase
    if (~cmd_1 && ready_data1 )	// rdata comes from S1
    	case (mfor_1)
    	0 : begin master_0_rdata = slave_1_rdata ; nomas_1 = 1; end 
    	1 : begin master_1_rdata = slave_1_rdata ; nomas_1 = 1; end
    	endcase
    
    /* выбор mfor_1 и mfor_2 */
    // S0 
    if (nomas_0)
    	case (mfor_0) // previous master
    	0 : if(m1_s0) mfor_0 = 1'b1; else if(m0_s0) mfor_0 = 1'b0;
    	1 : if(m0_s0) mfor_0 = 1'b0; else if(m1_s0) mfor_0 = 1'b1;
    	endcase 
    // S1
    if (nomas_1)
    	case (mfor_1) // previous master
    	0 : if(m1_s1) mfor_1 = 1'b1; else if(m0_s1) mfor_1 = 1'b0;
    	1 : if(m0_s1) mfor_1 = 1'b0; else if(m1_s1) mfor_1 = 1'b1;
    	endcase 
    
    /* отправка запросов на запись + на чтение */
    // S0
    if (~nomas_0) // there's master 
    	case (mfor_0)
    	0 : begin 
    		slave_0_addr = master_0_addr; 
    		slave_0_cmd = master_0_cmd;
    		if (cmd_0) 
    			slave_0_wdata = master_0_wdata; // if W
    		else;
    		end
    	1 : begin 
    		slave_0_addr = master_1_addr; 
    		slave_0_cmd = master_1_cmd;
    		if (cmd_0) 
    			slave_0_wdata = master_1_wdata;
    		end
    	endcase
    // S1
    if (~nomas_1) // there's master to W
    	case (mfor_1)
    	0 : begin 
    		slave_1_addr = master_0_addr; 
    		slave_1_cmd = master_0_cmd;
    		if (cmd_1) 
    			slave_1_wdata = master_0_wdata;
    		end
    	1 : begin 
    		slave_1_addr = master_1_addr; 
    		slave_1_cmd = master_1_cmd;
    		if (cmd_1) 
    			slave_1_wdata = master_1_wdata;
    		end
    	endcase
    
    
    /* transaction of _ack */
    // W_ACK - nomas = 1 ; R_ACK - ready_data = 1 ;
    // S0
    if (s0_ack && ~nomas_0) // 2nd statement should not be possible, but what if
    	case (cmd_0)
    	0 : begin // R_ACK 
    		ready_data0 = 1; // data will come next clk
    		end
    	1 : begin // W_ACK 
    		nomas_0 = 1; // data written request done
    		end
    	endcase
    // S1
    if (s1_ack && ~nomas_1) 
    	case (cmd_1)
    	0 : begin // R_ACK 
    		ready_data1 = 1; 
    		end
    	1 : begin // W_ACK 
    		nomas_1 = 1; 
    		end
    	endcase
 
    end
                                  
endmodule
