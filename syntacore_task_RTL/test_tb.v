`timescale 1ns / 1ps

module test_tb();

reg [31:0] a,b;
wire [31:0] res;

test_mod uut(
	.a(a), .b(b), .c(res)
);

initial begin
	a = 43;
	b = 32;
end

endmodule
