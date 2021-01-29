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
	input			master_0_req,	 input			master_1_req,				             
	input	[31:0]	master_0_addr,   input	[31:0]	master_1_addr,      	    
	input			master_0_cmd,    input			master_1_cmd,       	         
	input 	[31:0]	master_0_wdata,  input 	[31:0]	master_1_wdata,     	  
	output 			master_0_ack,    output 		master_1_ack,       	        
	output	[31:0]	master_0_rdata,  output	[31:0]	master_1_rdata,  
	  	   
	// slaves
	output			slave_0_req,	 output			slave_1_req,					        
	output	[31:0]	slave_0_addr,    output	[31:0]	slave_1_addr,       	    
	output			slave_0_cmd,     output			slave_1_cmd,        	         
	output 	[31:0]	slave_0_wdata,   output	[31:0]	slave_1_wdata,      	   
	input 			slave_0_ack,     input 			slave_1_ack,        	        
	input	[31:0]	slave_0_rdata,   input	[31:0]	slave_1_rdata 
	                                
    );
    
    reg	mem0; reg e0; // master left for the next clock
    reg	mem1; reg e1; // emp = 1 if mem is empty 
	
	reg mfor0; reg mfor1;
	
	reg m0_s0; reg m0_s1;
	reg m1_s0; reg m1_s1;
	
	
    always @(posedge clk)
    begin
    
    if (~e0)
    	/* do request mem0 */
    if (~e1)
    	/* do request mem1 */
    
    m0_s0 = master_0_req & (~master_0_addr[31]);
    m0_s1 = master_0_req & (master_0_addr[31]);
    
    m1_s0 = master_1_req & (~master_1_addr[31]);
    m1_s1 = master_1_req & (master_0_addr[31]);
    
    e0 = m0_s0 ;
    /* do mem0 request if emp0 = 0; mem1 request if emp1 = 0 */
    
    
    /* who goes to mem and who sends request */
    //check S0
    if (m1_s0)
    	if (~m0_s0) 
    		mfor0 = 1'b 1;
    	else 
    		begin
    		mfor0 = 1'b 0;
    		mem0 = 1'b 1; 
    		e0 = 0;
    		end
    else
    	if (m0_s0) 
    		mfor0 = 1'b 1;
    	else
    		//check S1
    		if (m1_s1)
    			if (~m0_s1) 
    				mfor1 = 1'b 1;
    			else 
    				begin
    				mfor1 = 1'b 0;
    				mem1 = 1'b 1; 
    				e1 = 0;
    				end
    		
    //check S1
    if (m1_s1)
    	if (~m0_s1) 
    		mfor1 = 1'b 1;
    	else 
    		begin
    		mfor1 = 1'b 0;
    		mem1 = 1'b 1; 
    		e1 = 0;
    		end
    else
    	if (m0_s1) 
    		mfor1 = 1'b 1;
    	else
    		//check S0
    		if (m1_s1)
    			if (~m1_s1) 
    				mfor1 = 1'b 1;
    			else 
    				begin
    				mfor1 = 1'b 0;
    				mem1 = 1'b 1; 
    				e1 = 0;
    				end
    
    
    /* do request mfor0 */;
    
    /* do request mfor1 */;
    
    end
                                  
endmodule
