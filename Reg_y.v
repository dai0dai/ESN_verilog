module Reg_Y
	#(
	parameter bit_length = 32
	)(
	output wire [bit_length-1:0]  out_reg_y,
	input  wire [bit_length-1:0]  y_o,
	input  wire                   EN_reg_y_n,
	input  wire                   clk, nrst
	);
	
	reg [bit_length-1:0] reg_y;
	always @(posedge clk or negedge nrst)
	if(!nrst)
	begin
		reg_y <= 'hbebc24da;
	end
	else if(!EN_reg_y_n)
	begin
		reg_y <= y_o;
	end
	
	assign out_reg_y = reg_y;
	
endmodule






























/*module Reg_U
	#(
	parameter bit_length = 32,
	parameter addr_length = 11,  //2000 < 2^11-1
	parameter time_point = 2000
	)(
	output wire [bit_length-1:0]  out_reg_u,
	input  wire [bit_length-1:0]  y_o,
	input  wire                   clk, nrst
	);
	
	reg addr;
	reg [bit_length-1:0] reg_u[1:0];
	initial 
	begin
		reg_u[0] <= 'hbebc24da;
	end
	always @(posedge clk or negedge nrst)
	if(!nrst)
	begin
		addr     <= 'd1;
		reg_u[0] <= 'hbebc24da;
		reg_u[1] <= 'd0;
	end
	else
	begin
		addr        <= EN_u_n ? addr : (addr + 1);
		reg_u[addr] <= y_o;*/
		
	