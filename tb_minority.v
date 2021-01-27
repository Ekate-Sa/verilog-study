`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2021 03:34:54
// Design Name: 
// Module Name: tb_minority
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


module tb_minority();
    reg [2:0] test_vector;
    wire y;
    
    minority uut (.a(test_vector[2]) , .b(test_vector[1]) , .c(test_vector[0]) , .y(y));
    
    integer i;
    initial begin 
    
    test_vector = 3'b000;
    #5;
    $display (test_vector, y);
    
    for (i=0; i < 7; i=i+1)
    begin
        assign test_vector = test_vector + 1;
        #5;
        $display (test_vector," ", y);
        
    end
    end 
    
endmodule
