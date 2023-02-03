
module Reg_heap 
    #(
    parameter bit_length  = 32,
	parameter a           = 'h3e99999a,   //0.3
	parameter a1          = 'h3f333333,  //0.7
	parameter Woutb       = 'hbecc6d1f  //-0.3992700297385454
		
    ) 
    (
	output wire [bit_length-1:0] out_reg_X1, out_reg_X2, out_reg_W,  out_reg_Win, out_reg_Winb, out_reg_Wout,
							     out_reg_a,  out_reg_a1, out_reg_Woutb,
								
	input  wire [bit_length-1:0] in_reg_X, in_reg_W, in_reg_Win, in_reg_Winb, in_reg_Wout, 


	input  wire                  EN_in_X2_n,   EN_in_X1_n, EN_in_W_n,  EN_in_Win_n, EN_in_Winb_n,    
								 EN_in_Wout_n, 
	input  wire                  clk, nrst
	);
    
	reg [bit_length-1:0] out_reg_X1_reg, out_reg_Xm_reg, out_reg_X2_reg, out_reg_W_reg,  out_reg_Win_reg, out_reg_Winb_reg, 
						 out_reg_Wout_reg;

	wire [bit_length-1:0] in_a, in_a1, in_Woutb;
	assign in_a     = a;
	assign in_a1    = a1;
	assign in_Woutb = Woutb;

	always @(posedge clk or negedge nrst) 
	if (!nrst)
	begin 
		out_reg_X1_reg    <= 'b0;
		out_reg_X2_reg    <= 'b0;		
		out_reg_W_reg     <= 'b0;
		out_reg_Win_reg   <= 'b0;
		out_reg_Winb_reg  <= 'b0;
		out_reg_Wout_reg  <= 'b0;
	end
	else
	begin
		out_reg_X1_reg    <= in_reg_X;
		out_reg_Xm_reg	  <= out_reg_X1_reg;
		out_reg_X2_reg    <= out_reg_Xm_reg;
		out_reg_W_reg     <= in_reg_W;
		out_reg_Win_reg   <= in_reg_Win;
		out_reg_Winb_reg  <= in_reg_Winb;
		out_reg_Wout_reg  <= in_reg_Wout;
	end
	
	
	
	assign out_reg_X1    = EN_in_X1_n      ? 'b0 : out_reg_X1_reg;
	assign out_reg_X2    = EN_in_X2_n      ? 'b0 : out_reg_X2_reg;	
    assign out_reg_W     = EN_in_W_n       ? 'b0 : out_reg_W_reg;
    assign out_reg_Win   = EN_in_Win_n     ? 'b0 : out_reg_Win_reg;
    assign out_reg_Winb  = EN_in_Winb_n    ? 'b0 : out_reg_Winb_reg;
    assign out_reg_Wout  = EN_in_Wout_n    ? 'b0 : out_reg_Wout_reg;
    assign out_reg_a	 = in_a; 
    assign out_reg_a1    = in_a1;
    assign out_reg_Woutb = in_Woutb;
	

endmodule