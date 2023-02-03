`timescale 1ns / 100ps


module mul(clk, opa, opb, out);
	input clk;
	input [31:0] opa, opb;
	output [31:0] out;
	

	wire inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero;
	
	fpu u_mul(
		.clk(clk),
		.rmode(2'd0), 
		.fpu_op(3'd2), 
		.opa(opa), 
		.opb(opb), 
		.out(out), 
		.inf(inf), 
		.snan(snan), 
		.qnan(qnan), 
		.ine(ine), 
		.overflow(overflow), 
		.underflow(underflow), 
		.zero(zero), 
		.div_by_zero(div_by_zero)
		); 
	

endmodule