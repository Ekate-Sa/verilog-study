`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
req - îäíîáèòíûé ñèãíàë, çàïðîñ íà âûïîëíåíèå òðàíçàêöèè
(master-> slave)

addr - 32-áèòíûé øèíà, ñîäåðæèò àäðåñ çàïðîñà (master-
>slave)
cmd - îäíîáèòíûé ñèãíàë - ïðèçíàê îïåðàöèè: 0 - read, 1 -
write (master->slave)

wdata - 32-áèòíûé øèíà, ñîäåðæèò çàïèñûâàåìûå äàííûå.
ïåðåäàþòñÿ â òîì æå òàêòå , ÷òî è àäðåñ (master-> slave)
ack - îäíîáèòíûé ñèãíàë-ïîäòâåðæäåíèå, ÷òî â äàííîì òàêòå
slave ïðèíÿë çàïðîñ ê èñïîëíåíèþ (slave->master). ïðè ýòîì, slave äîëæåí
çàôèêñèðîâàòü _addr, _cmd, è _wdata (â ñëó÷àå òðàíçàêöèè çàïèñè). ïåðåâîä
_ack â àêòèâíîå ñîñòîÿíèå ðàçðåøàåò master óñòðîéñòâó ñíÿòü çàïðîñ â
ñëåäóþùåì òàêòå

rdata - 32-áèòíàÿ øèíà, ñîäåðæèò ñ÷èòûâàåìûå äàííûå.
ïåðåäàþòñÿ íà ñëåäóþùåì òàêòå ïîñëå ïîäòâåðæäåíèÿ òðàíçàêöèè(_ack = 1)(slave-
> master)
------------------------
Âûáîð slave óñòðîéñòâà îïðåäåëÿåòñÿ ñòàðøèì áèòîì àäðåñà. Àðáèòðàæ ìåæäó
íåñêîëüêèìè master çàïðîñàìè â îäíî slave óñòðîéñòâî îñóùåñòâëÿåòñÿ ïî äèñöèïëèíå
"round-robin".
*/
//////////////////////////////////////////////////////////////////////////////////

module crossbar(
	input		clk,
	
	// masters
	input		master_0_req,	 input		master_1_req,				             
	input	[31:0]	master_0_addr,   input	[31:0]	master_1_addr,      	    
	input		master_0_cmd,    input		master_1_cmd,       	         
	input 	[31:0]	master_0_wdata,  input 	[31:0]	master_1_wdata,     	  
	output 		master_0_ack,    output 	master_1_ack,       	        
	output	[31:0]	master_0_rdata,  output	[31:0]	master_1_rdata,  
	
	input		master_2_req,	 input		master_3_req,				             
	input	[31:0]	master_2_addr,   input	[31:0]	master_3_addr,      	    
	input		master_2_cmd,    input		master_3_cmd,       	         
	input 	[31:0]	master_2_wdata,  input 	[31:0]	master_3_wdata,     	  
	output 		master_2_ack,    output 	master_3_ack,       	        
	output	[31:0]	master_2_rdata,  output	[31:0]	master_3_rdata,   	   
	
	// slaves
	output		slave_0_req,	 output		slave_1_req,					        
	output	[31:0]	slave_0_addr,    output	[31:0]	slave_1_addr,       	    
	output		slave_0_cmd,     output		slave_1_cmd,        	         
	output 	[31:0]	slave_0_wdata,   output	[31:0]	slave_1_wdata,      	   
	input 		slave_0_ack,     input 		slave_1_ack,        	        
	input	[31:0]	slave_0_rdata,   input	[31:0]	slave_1_rdata, 
	
	output		slave_2_req,	 output		slave_3_req,					        
	output	[31:0]	slave_2_addr,    output	[31:0]	slave_3_addr,       	    
	output		slave_2_cmd,     output		slave_3_cmd,        	         
	output 	[31:0]	slave_2_wdata,   output	[31:0]	slave_3_wdata,      	   
	input 		slave_2_ack,     input 		slave_3_ack,        	        
	input	[31:0]	slave_2_rdata,   input	[31:0]	slave_3_rdata      	  
	                                
    );
    
    always @(posedge clk)
    begin
    
    
    //round robin
    // S0
    if (master_3_req == 1'b1 && master_3_addr[31] == 2'b0)
    	if (master_2_req == 1'b1 && master_2_addr[31] == 2'b0)
    		if (master_1_req == 1'b1 && master_1_addr[31] == 2'b0)
    			if (master_0_req == 1'b1 && master_0_addr[31] == 2'b0)
    				/* do reqest from M0 */;
    			else
    				/* do request from M1 */;
    		else
    			/* do request from M2*/;
    	else
    		/* do request from M3*/;
    else
    	/* do request from M3*/;
    	
    // S1
    if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b1)
    	if (master_2_req == 1'b1 && master_2_addr[31:30] == 2'b1)
    		if (master_1_req == 1'b1 && master_1_addr[31:30] == 2'b1)
    			if (master_0_req == 1'b1 && master_0_addr[31:30] == 2'b1)
    				/* do reqest from M0 */;
    			else
    				/* do request from M1 */;
    		else
    			/* do request from M2*/;
    	else
    		/* do request from M3*/;
    else
    	/* do request from M3*/;
    
    // S2
    if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b10)
    	if (master_2_req == 1'b1 && master_2_addr[31:30] == 2'b10)
    		if (master_1_req == 1'b1 && master_1_addr[31:30] == 2'b10)
    			if (master_0_req == 1'b1 && master_0_addr[31:30] == 2'b10)
    				/* do reqest from M0 */;
    			else
    				/* do request from M1 */;
    		else
    			/* do request from M2*/;
    	else
    		/* do request from M3*/;
    else
    	/* do request from M3*/;
    	
    // S3
    if (master_3_req == 1'b1 && master_3_addr[31:30] == 2'b11)
    	if (master_2_req == 1'b1 && master_2_addr[31:30] == 2'b11)
    		if (master_1_req == 1'b1 && master_1_addr[31:30] == 2'b11)
    			if (master_0_req == 1'b1 && master_0_addr[31:30] == 2'b11)
    				/* do reqest from M0 */;
    			else
    				/* do request from M1 */;
    		else
    			/* do request from M2*/;
    	else
    		/* do request from M3*/;
    else
    	/* do request from M3*/;
    	
    end
                                  
endmodule
