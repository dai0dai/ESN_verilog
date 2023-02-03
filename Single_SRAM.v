
// dual port
module SRAM_dual
	#(parameter bit_length = 64,
				addr_length = 10  // depth: 2^(ADDR_LENGTH)
				)
	(
	output [bit_length-1:0] QA, 
	output [bit_length-1:0] QB,
	
	input [addr_length-1:0] add_A,
	input [bit_length-1:0] data_A,
	input CEBA,
	input WEBA,
	
	input [addr_length-1:0] add_B,
	input [bit_length-1:0] data_B,
	input CEBB,
	input WEBB,
	
	input clk
		);

	reg [bit_length-1:0] QA_reg, QB_reg;
	(*ram_style="block"*) reg [bit_length-1:0] mem [(1<<addr_length)-1:0];
	assign QA = QA_reg;
	assign QB = QB_reg;
	
	
	always @(posedge clk)
	begin
		if (~CEBA & ~WEBA)
		begin
			mem[add_A] <= data_A;
			if (~CEBB & WEBB)
			begin
				QB_reg <= mem[add_B];
				if (add_A == add_B)
				begin
					$display("SRAM128*500 DP dual port SRAM addr conflict");
                       $display("at simulation time :%d",$time);
				end
			end
		end
		
		else if (~CEBB & ~WEBB)
		begin
			mem[add_B] <= data_B;
			if (~CEBA & WEBA)
			begin
				QA_reg <= mem[add_A];
				if (add_A == add_B)
				begin
					$display("SRAM128*500 DP dual port SRAM addr conflict");
                       $display("at simulation time :%d",$time);
				end
			end
		end
		
		else if (~CEBA & WEBA)
		begin
			QA_reg <= mem[add_A];			
		end
		
		else if (~CEBB & WEBB)
		begin
			QB_reg <= mem[add_B];
		end
	
	end	
endmodule




// single port
module SRAM_SP
	#(
		parameter bit_length  = 128,
				  addr_length = 8 // depth: 2^(ADDR_LENGTH)
		) 
	( 
	output [bit_length-1:0] Q,
	
	input [bit_length-1:0]  data, 
	input [addr_length-1:0] addr,
	input clk, CEB, WEB
		);

    (*ram_style="block"*) reg [bit_length-1:0] mem [(1<<addr_length)-1:0];
	
	reg [bit_length-1:0] Q_reg;

	
	
	always @(posedge clk)
	begin
		if (~CEB & ~WEB)
			mem [addr] <= data;
		else if (~CEB & WEB)
			Q_reg <= mem [addr];
	end
	
	assign Q = Q_reg;

endmodule