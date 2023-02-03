
module SRAM_heap
	#(
	parameter addr_length = 10,
	parameter bit_length = 32,
	parameter node_num = 1000
	)(
	output [bit_length-1:0]  Dataout_X_A, Dataout_X_B, Dataout_W, Dataout_Win, Dataout_Winb, Dataout_Wout,
	input  [1:0]             SRAM_State,   
	input  [2:0]             SEL_inSRAM_offchip,  
	input  [addr_length-1:0] addr_inSRAM_offchip,
	input  [bit_length-1:0]  Data_offchip, 
						     Data_onchip, 
	input                    EN_X_inSRAM_n,
	                         EN_update_addr_X_n,  
		                     EN_update_addr_W_n, 		
		                     EN_update_addr_Win_n,
		                     EN_update_addr_Winb_n,
		                     EN_update_addr_Wout_n,
	input                    clk, nrst
	);


/////////////////////////
// 1. CEB and WEB    ////
///////////////////////// 
	reg   CEB_X_A, CEB_X_B, CEB_W, CEB_Win, CEB_Winb, CEB_Wout,
		  WEB_X_A, WEB_X_B, WEB_W, WEB_Win, WEB_Winb, WEB_Wout;
	reg	 [bit_length-1:0] Data_offchip_delay;
	wire [bit_length-1:0] Data_in_X_A;

	always @(posedge clk ) begin
		Data_offchip_delay <= Data_offchip;
	end

	assign Data_in_X_A = SRAM_State[1] ? Data_onchip : Data_offchip_delay;
	
	always@(posedge clk or negedge nrst)
	if (!nrst)
	begin
		CEB_X_A  <= 'b1;
		CEB_X_B  <= 'b1;
		CEB_W    <= 'b1;
		CEB_Win  <= 'b1;
		CEB_Winb <= 'b1;
		CEB_Wout <= 'b1;
		WEB_X_A  <= 'b1;
		WEB_X_B  <= 'b1;
		WEB_W    <= 'b1;
		WEB_Win  <= 'b1;
		WEB_Winb <= 'b1;
		WEB_Wout <= 'b1;
	end
	else
	begin
		case (SRAM_State)
			'b00: begin  //S0: static
					CEB_X_A  <= 'b1;
					CEB_X_B  <= 'b1;
					CEB_W    <= 'b1;
					CEB_Win  <= 'b1;
					CEB_Winb <= 'b1;
					CEB_Wout <= 'b1;
					WEB_X_A  <= 'b1;
					WEB_X_B  <= 'b1;
					WEB_W    <= 'b1;
					WEB_Win  <= 'b1;
					WEB_Winb <= 'b1;
					WEB_Wout <= 'b1;
				  end
			'b01: case(SEL_inSRAM_offchip) //s1: write to SRAM heap from offchip
					'b000: begin 
							CEB_X_A  <= 'b0;  // SRAM_X: dual port: port A: write; port B: read
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b1;
							CEB_Win  <= 'b1;
							CEB_Winb <= 'b1;
							CEB_Wout <= 'b1;
							WEB_X_A  <= 'b0;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b1;
							WEB_Win  <= 'b1;
							WEB_Winb <= 'b1;
							WEB_Wout <= 'b1;
						   end
					'b001: begin  
							CEB_X_A  <= 'b1;  
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b0;
							CEB_Win  <= 'b1;
							CEB_Winb <= 'b1;
							CEB_Wout <= 'b1;
							WEB_X_A  <= 'b1;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b0;
							WEB_Win  <= 'b1;
							WEB_Winb <= 'b1;
							WEB_Wout <= 'b1;	
						   end
					'b010: begin  
							CEB_X_A  <= 'b1;  
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b1;
							CEB_Win  <= 'b0;
							CEB_Winb <= 'b1;
							CEB_Wout <= 'b1;
							WEB_X_A  <= 'b1;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b1;
							WEB_Win  <= 'b0;
							WEB_Winb <= 'b1;
							WEB_Wout <= 'b1;	
						   end
					'b011: begin  
							CEB_X_A  <= 'b1;  
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b1;
							CEB_Win  <= 'b1;
							CEB_Winb <= 'b0;
							CEB_Wout <= 'b1;
							WEB_X_A  <= 'b1;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b1;
							WEB_Win  <= 'b1;
							WEB_Winb <= 'b0;
							WEB_Wout <= 'b1;	
						   end
					'b100: begin 
							CEB_X_A  <= 'b1;  
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b1;
							CEB_Win  <= 'b1;
							CEB_Winb <= 'b1;
							CEB_Wout <= 'b0;
							WEB_X_A  <= 'b1;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b1;
							WEB_Win  <= 'b1;
							WEB_Winb <= 'b1;
							WEB_Wout <= 'b0;	
						   end
					default: begin
							CEB_X_A  <= 'b1;  
							CEB_X_B  <= 'b1;
							CEB_W    <= 'b1;
							CEB_Win  <= 'b1;
							CEB_Winb <= 'b1;
							CEB_Wout <= 'b1;
							WEB_X_A  <= 'b1;
							WEB_X_B  <= 'b1;
							WEB_W    <= 'b1;
							WEB_Win  <= 'b1;
							WEB_Winb <= 'b1;
							WEB_Wout <= 'b1;
						     end
				endcase
			'b10: begin  //s2: write to reg from SRAM heap & write to SRAM_X from pe
					CEB_X_A  <= EN_X_inSRAM_n 		  ? 'b1 : 'b0;  
					CEB_X_B  <= EN_update_addr_X_n    ? 'b1 : 'b0;
					CEB_W    <= EN_update_addr_W_n    ? 'b1 : 'b0;
					CEB_Win  <= EN_update_addr_Win_n  ? 'b1 : 'b0;
					CEB_Winb <= EN_update_addr_Winb_n ? 'b1 : 'b0;
					CEB_Wout <= EN_update_addr_Wout_n ? 'b1 : 'b0;
					WEB_X_A  <= EN_X_inSRAM_n 		  ? 'b1 : 'b0;
					WEB_X_B  <= 'b1;
					WEB_W    <= 'b1;
					WEB_Win  <= 'b1;
					WEB_Winb <= 'b1;
					WEB_Wout <= 'b1;
				  end
			default: begin
						CEB_X_A  <= 'b1;
						CEB_X_B  <= 'b1;
						CEB_W    <= 'b1;
						CEB_Win  <= 'b1;
						CEB_Winb <= 'b1;
						CEB_Wout <= 'b1;
						WEB_X_A  <= 'b1;
						WEB_X_B  <= 'b1;
						WEB_W    <= 'b1;
						WEB_Win  <= 'b1;
						WEB_Winb <= 'b1;
						WEB_Wout <= 'b1;
					 end
		endcase
	end
/////////////////////////////////////////
// 2. address                       /////
/////////////////////////////////////////
	reg [addr_length-1:0] addr_X_B, addr_W, addr_Win, addr_Winb, addr_Wout;
	reg [addr_length-1:0] addr_X_A;
	reg [addr_length-1:0] addr_delay_X_A, addr_delay_X_B, addr_delay_W, addr_delay_Win, addr_delay_Winb, addr_delay_Wout;

	always@(posedge clk or negedge nrst)
	if (!nrst)
	begin
		addr_delay_X_A  <= 'b0;
		addr_delay_X_B  <= 'b0;
		addr_delay_W    <= 'b0;
		addr_delay_Win  <= 'b0;
		addr_delay_Winb <= 'b0; 
		addr_delay_Wout <= 'b0;
	end
	else
	begin
		case(SRAM_State)
			'b00: begin
					addr_delay_X_A  <= 'b0;
					addr_delay_X_B  <= 'b0;
					addr_delay_W    <= 'b0;
					addr_delay_Win  <= 'b0;
					addr_delay_Winb <= 'b0; 
					addr_delay_Wout <= 'b0;
				  end
			'b01: begin
				case (SEL_inSRAM_offchip)
					'b000: begin
							addr_delay_X_A  <= addr_inSRAM_offchip;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= 'b0;
							addr_delay_Win  <= 'b0;
							addr_delay_Winb <= 'b0; 
							addr_delay_Wout <= 'b0;
						   end
					'b001: begin
							addr_delay_X_A  <= 'b0;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= addr_inSRAM_offchip;
							addr_delay_Win  <= 'b0;
							addr_delay_Winb <= 'b0; 
							addr_delay_Wout <= 'b0;
						   end
					'b010: begin
							addr_delay_X_A  <= 'b0;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= 'b0;
							addr_delay_Win  <= addr_inSRAM_offchip;
							addr_delay_Winb <= 'b0; 
							addr_delay_Wout <= 'b0;
						   end
					'b011: begin
							addr_delay_X_A  <= 'b0;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= 'b0;
							addr_delay_Win  <= 'b0;
							addr_delay_Winb <= addr_inSRAM_offchip; 
							addr_delay_Wout <= 'b0;
						   end
					'b100: begin
							addr_delay_X_A  <= 'b0;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= 'b0;
							addr_delay_Win  <= 'b0;
							addr_delay_Winb <= 'b0; 
							addr_delay_Wout <= addr_inSRAM_offchip;
						   end
					default: begin
							addr_delay_X_A  <= 'b0;
							addr_delay_X_B  <= 'b0;
							addr_delay_W    <= 'b0;
							addr_delay_Win  <= 'b0;
							addr_delay_Winb <= 'b0; 
							addr_delay_Wout <= 'b0;
						   end
				endcase
			      end
			'b10: begin
					addr_X_A  		<= EN_X_inSRAM_n 		? 'd0 : (addr_X_A < node_num - 1)  ? (addr_X_A + 'b1)  : 'd0;  //??
					addr_X_B  		<= EN_update_addr_X_n    ? (node_num - 1) : (addr_X_B < node_num - 1) ? (addr_X_B + 'b1) : 0;
					addr_W    		<= EN_update_addr_W_n    ? (node_num - 1) : (addr_W < node_num - 1)   ? (addr_W + 'b1) : 0;
					addr_Win  		<= EN_update_addr_Win_n  ? 'd0 : (addr_Win < node_num - 1)  ? (addr_Win + 'b1)  : 'd0;
					addr_Winb 		<= EN_update_addr_Winb_n ? 'd0 : (addr_Winb < node_num - 1) ? (addr_Winb + 'b1) : 'd0;
					addr_Wout 		<= EN_update_addr_Wout_n ? 'd0 : (addr_Wout < node_num - 1) ? (addr_Wout + 'b1) : 'd0;
					addr_delay_X_A  <= addr_X_A; 
					addr_delay_X_B  <= addr_X_B; 
					addr_delay_W    <= addr_W;   
					addr_delay_Win  <= addr_Win; 
					addr_delay_Winb <= addr_Winb;
					addr_delay_Wout <= addr_Wout;
					
				  end
		endcase
	end

	SRAM_dual #(.bit_length(bit_length), .addr_length(addr_length)) 
		SRAM_X (.QA(Dataout_X_A), .QB(Dataout_X_B),		        
			    .add_A(addr_delay_X_A), .data_A(Data_in_X_A),
				.CEBA(CEB_X_A), .WEBA(WEB_X_A),	 
						        
			    .add_B(addr_delay_X_B), .data_B(),
				.CEBB(CEB_X_B), .WEBB(WEB_X_B),	 
				.clk(clk));
				
	SRAM_SP #(.bit_length(bit_length), .addr_length(addr_length))
		SRAM_W (.Q(Dataout_W),	        
			    .data(Data_offchip_delay), .addr(addr_delay_W), 
				.CEB(CEB_W), .WEB(WEB_W),
				.clk(clk));
				
	SRAM_SP #(.bit_length(bit_length), .addr_length(addr_length))
		SRAM_Win (.Q(Dataout_Win),	        
			      .data(Data_offchip_delay), .addr(addr_delay_Win), 
				  .CEB(CEB_Win), .WEB(WEB_Win),
				  .clk(clk));
    
	SRAM_SP #(.bit_length(bit_length), .addr_length(addr_length))
		SRAM_Winb (.Q(Dataout_Winb),	        
			       .data(Data_offchip_delay), .addr(addr_delay_Winb), 
				   .CEB(CEB_Winb), .WEB(WEB_Winb),
				   .clk(clk));
	
	SRAM_SP #(.bit_length(bit_length), .addr_length(addr_length))
		SRAM_Wout (.Q(Dataout_Wout),	        
			       .data(Data_offchip_delay), .addr(addr_delay_Wout), 
				   .CEB(CEB_Wout), .WEB(WEB_Wout),
				   .clk(clk));	
	
	
endmodule