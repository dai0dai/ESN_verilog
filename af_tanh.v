 `timescale 1ns / 1ps

module af_tanh_kxb #(
	parameter N = 32,
	parameter lutnum = 37
)(
	input clk,
	input [N-1:0] innum,
	output reg [N-1:0] tanh_innum
	);
	
	wire [N-1:0] innum0;
	wire [N-1:0] kmem[lutnum-1:0];
	wire [N-1:0] bmem[lutnum-1:0];  


	assign kmem[ 0] = 32'h3f7faacd;
	assign kmem[ 1] = 32'h3f7daec6;
	assign kmem[ 2] = 32'h3f79c65f;
	assign kmem[ 3] = 32'h3f740fe3;
	assign kmem[ 4] = 32'h3f6cb653;
	assign kmem[ 5] = 32'h3f63eecf;
	assign kmem[ 6] = 32'h3f59f584;
	assign kmem[ 7] = 32'h3f4f0a7a;
	assign kmem[ 8] = 32'h3f436e84;
	assign kmem[ 9] = 32'h3f37607c;
	assign kmem[10] = 32'h3f2b1b0a;
	assign kmem[11] = 32'h3f1ed2f3;
	assign kmem[12] = 32'h3f12b606;
	assign kmem[13] = 32'h3f06ea8d;
	assign kmem[14] = 32'h3ef71e83;
	assign kmem[15] = 32'h3ee17727;
	assign kmem[16] = 32'h3ecd0082;
	assign kmem[17] = 32'h3eb9d025;
	assign kmem[18] = 32'h3ea7f161;
	assign kmem[19] = 32'h3e9766ff;
	assign kmem[20] = 32'h3e882ce9;
	assign kmem[21] = 32'h3e74735c;
	assign kmem[22] = 32'h3e5affc1;
	assign kmem[23] = 32'h3e43de8a;
	assign kmem[24] = 32'h3e2eeb9c;
	assign kmem[25] = 32'h3e1c00d3;
	assign kmem[26] = 32'h3e0af753;
	assign kmem[27] = 32'h3df750fb;
	assign kmem[28] = 32'h3ddbdd70;
	assign kmem[29] = 32'h3dc34be4;
	assign kmem[30] = 32'h3dad5804;
	assign kmem[31] = 32'h3d99c1c1;
	assign kmem[32] = 32'h3d3907c8;
	assign kmem[33] = 32'h3c8a49d6;
	assign kmem[34] = 32'h3bccada9;
	assign kmem[35] = 32'h3b16eaa5;
	assign kmem[36] = 32'h392fc2d4;


	assign bmem[ 0] = 32'h00000000;
	assign bmem[ 1] = 32'h39fe0361;
	assign bmem[ 2] = 32'h3b1ccd42;
	assign bmem[ 3] = 32'h3bd7824d;
	assign bmem[ 4] = 32'h3c615a1d;
	assign bmem[ 5] = 32'h3cc87836;
	assign bmem[ 6] = 32'h3d2013e0;
	assign bmem[ 7] = 32'h3d6c8124;
	assign bmem[ 8] = 32'h3da4b06c;
	assign bmem[ 9] = 32'h3ddaef8f;
	assign bmem[10] = 32'h3e0c2564;
	assign bmem[11] = 32'h3e2deba3;
	assign bmem[12] = 32'h3e52426b;
	assign bmem[13] = 32'h3e7897b3;
	assign bmem[14] = 32'h3e902b9e;
	assign bmem[15] = 32'h3ea47884;
	assign bmem[16] = 32'h3eb8ef29;
	assign bmem[17] = 32'h3ecd528d;
	assign bmem[18] = 32'h3ee16d29;
	assign bmem[19] = 32'h3ef5117d;
	assign bmem[20] = 32'h3f040d0c;
	assign bmem[21] = 32'h3f0d34ab;
	assign bmem[22] = 32'h3f15f468;
	assign bmem[23] = 32'h3f1e4458;
	assign bmem[24] = 32'h3f261f71;
	assign bmem[25] = 32'h3f2d8328;
	assign bmem[26] = 32'h3f346f04;
	assign bmem[27] = 32'h3f3ae446;
	assign bmem[28] = 32'h3f40e58c;
	assign bmem[29] = 32'h3f467686;
	assign bmem[30] = 32'h3f4b9baf;
	assign bmem[31] = 32'h3f505a13;
	assign bmem[32] = 32'h3f5fa98a;
	assign bmem[33] = 32'h3f71c4fc;
	assign bmem[34] = 32'h3f79efd7;
	assign bmem[35] = 32'h3f7d7861;
	assign bmem[36] = 32'h3f7fa81b;
	
assign innum0 = (innum[N-1] == 0)? innum : {1'b0, innum[N-2:0]};

wire [6:0] loc;
wire [N-1:0] kx;
wire [N-1:0] y;

flt2fix ffkxb
(
	.flt_in(innum0),
	.int_part(loc)
);

	mul mul1
	(
		.clk(clk),
		.opa(kmem[loc]),
		.opb(innum0),
		.out(kx)
	);
	
	reg [N-1:0] buf_loc_0;
	
	reg [N-1:0] buf_innum_0;
	reg [N-1:0] buf_innum_1;
	
	add add1
	(
		.clk(clk),
		.opa(kx),
		.opb(bmem[buf_loc_0]),
		.out(y)
	);
	
	always@(posedge clk)
	begin
		buf_loc_0 <= loc;
		
		buf_innum_0 <= innum;
		buf_innum_1 <= buf_innum_0;
		
		
		
	end
	
	
	always@(posedge clk)
	begin
	if (buf_innum_1[N-2:N-9] >= 'b10000010)  
	begin
		if (buf_innum_1[N-1] == 0)  tanh_innum <= 'h3F800000;  
		else   tanh_innum <= 'hBF800000;  
	end
	else tanh_innum <= {buf_innum_1[N-1], y[N-2:0]};
	end

	
endmodule

