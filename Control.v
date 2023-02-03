
module Control #(
	parameter node_num = 1000,
	parameter time_s1 = 5000,  
	parameter time_s2 = 1050,  		
	parameter time_point_s2 = 2000 
)
(	output [1:0] SRAM_State,
	output       EN_X_inSRAM_n,        EN_update_addr_X_n,    EN_update_addr_W_n,     //SRAM
				 EN_update_addr_Win_n, EN_update_addr_Winb_n, EN_update_addr_Wout_n,
				 
				 EN_in_X2_n,   EN_in_X1_n, EN_in_W_n,  EN_in_Win_n, EN_in_Winb_n,     //reg
	             EN_in_Wout_n, EN_reg_y_n, 
				 EN_y_sum_in_n, EN_input_Woutb, EN_sum2_n, EN_y_o_n,//pe
	 
	input clk, nrst, EN_system_n
);       

	parameter s0 = 2'b00;
	parameter s1 = 2'b01;
	parameter s2 = 2'b10;
	
	reg [12:0] count_s1;  
	reg [10:0] count_s2;
	reg [10:0] count_point_s2;
	
	reg [1:0] state, next_state;
	
	reg EN_X_inSRAM_n_reg,        
		EN_update_addr_X_n_reg,    
		EN_update_addr_W_n_reg,     
		EN_update_addr_Win_n_reg, 
		EN_update_addr_Winb_n_reg, 
		EN_update_addr_Wout_n_reg,
		SEL_inSRAM_offchip_reg, 
		addr_inSRAM_offchip_reg,
		
		EN_in_X2_n_reg,   
		EN_in_X1_n_reg, 
		EN_in_W_n_reg,  
		EN_in_Win_n_reg, 
		EN_in_Winb_n_reg,    
	    EN_in_Wout_n_reg, 
		EN_reg_y_n_reg,
		
		EN_y_sum_in_n_reg,
		EN_input_Woutb_reg,
		EN_sum2_n_reg,
		EN_y_o_n_reg;
	
	assign EN_X_inSRAM_n         = EN_X_inSRAM_n_reg;        
    assign EN_update_addr_X_n    = EN_update_addr_X_n_reg;   
    assign EN_update_addr_W_n    = EN_update_addr_W_n_reg;    
    assign EN_update_addr_Win_n  = EN_update_addr_Win_n_reg;
    assign EN_update_addr_Winb_n = EN_update_addr_Winb_n_reg; 
    assign EN_update_addr_Wout_n = EN_update_addr_Wout_n_reg;
	assign SEL_inSRAM_offchip    = SEL_inSRAM_offchip_reg; 
    assign addr_inSRAM_offchip   = addr_inSRAM_offchip_reg;
	
    assign EN_in_X2_n            = EN_in_X2_n_reg;   
    assign EN_in_X1_n            = EN_in_X1_n_reg;   
    assign EN_in_W_n             = EN_in_W_n_reg;    
    assign EN_in_Win_n           = EN_in_Win_n_reg; 
    assign EN_in_Winb_n 		 = EN_in_Winb_n_reg;    
    assign EN_in_Wout_n 		 = EN_in_Wout_n_reg; 
	assign EN_reg_y_n            = EN_reg_y_n_reg;
	
	assign EN_y_sum_in_n         = EN_y_sum_in_n_reg;
	assign EN_input_Woutb        = EN_input_Woutb_reg;
	assign EN_sum2_n             = EN_sum2_n_reg;
	assign EN_y_o_n              = EN_y_o_n_reg;
	
	always@(posedge clk or negedge nrst)
	if(!nrst)
	begin
		state <= s0;
	end
	else if(EN_system_n)
		state <= s0;
	else state <= next_state;
	
	assign SRAM_State = state;
	
	always@(*)
	begin
		case(state)
			s0: if (!EN_system_n)  
					next_state <= s1;
				else
					next_state <= s0;
			s1: if (count_s1 == time_s1 - 1) 
					next_state <= s2;
				else 
					next_state <= s1;
			s2: if (count_point_s2 == time_point_s2 - 1) 
					next_state <= s0;
				else 
					next_state <= s2;
		endcase
	end
	
	always@(posedge clk or negedge nrst)
		if (~nrst) begin
			count_s1 <= 'b0;
			count_s2 <= 'b0;
			count_point_s2 <= 'b0;
		end
		else begin
			case(state)
				s0: begin
					count_s1 <= 'b0;
					count_s2 <= 'b0;
					count_point_s2 <= 'b0;
				    end
				s1: begin
					count_s1 <= count_s1 + 1;
					end
				s2: begin														
					count_s2 <= (count_s2 <= time_s2 ? count_s2 + 1 : 'b0);		
					count_point_s2 <= (count_s2 == 0) ? (count_point_s2 <= time_point_s2 ? count_point_s2 + 1 : 0) : count_point_s2;
					end
				default: begin
					count_s1 <= 'b0;
					count_s2 <= 'b0;
					count_point_s2 <= 'b0;
				end
			endcase
		end


	always@(posedge clk or negedge nrst)
		if (~nrst) begin
			EN_X_inSRAM_n_reg         <= 'b1;
    	    EN_update_addr_X_n_reg    <= 'b1;
    	    EN_update_addr_W_n_reg    <= 'b1;
    	    EN_update_addr_Win_n_reg  <= 'b1;
    	    EN_update_addr_Winb_n_reg <= 'b1;
    	    EN_update_addr_Wout_n_reg <= 'b1;
    	    SEL_inSRAM_offchip_reg    <= 'b100;
			addr_inSRAM_offchip_reg   <= 'b0;

    	    EN_in_X2_n_reg        <= 'b1;
    	    EN_in_X1_n_reg        <= 'b1;
    	    EN_in_W_n_reg         <= 'b1;
    	    EN_in_Win_n_reg       <= 'b1;
    	    EN_in_Winb_n_reg      <= 'b1;
    	    EN_in_Wout_n_reg      <= 'b1;
			EN_reg_y_n_reg        <= 'b1;

			EN_y_sum_in_n_reg   	 <= 'b1;
			EN_input_Woutb_reg  	 <= 'b1;
			EN_sum2_n_reg       	 <= 'b1;
			EN_y_o_n_reg        	 <= 'b1;
		end
		else begin
			case(state)
				s0: begin				
					EN_X_inSRAM_n_reg         <= 'b1;
    	            EN_update_addr_X_n_reg    <= 'b1;
    	            EN_update_addr_W_n_reg    <= 'b1;
    	            EN_update_addr_Win_n_reg  <= 'b1;
    	            EN_update_addr_Winb_n_reg <= 'b1;
    	            EN_update_addr_Wout_n_reg <= 'b1;
    	            SEL_inSRAM_offchip_reg    <= 'b100;
					addr_inSRAM_offchip_reg   <= 'b0;			
	
    	            EN_in_X2_n_reg        <= 'b1;
    	            EN_in_X1_n_reg        <= 'b1;
    	            EN_in_W_n_reg         <= 'b1;
    	            EN_in_Win_n_reg       <= 'b1;
    	            EN_in_Winb_n_reg      <= 'b1;
    	            EN_in_Wout_n_reg      <= 'b1;
					EN_reg_y_n_reg        <= 'b1;

					EN_input_Woutb_reg   <= 'b1;
					EN_sum2_n_reg        <= 'b1;
					EN_y_o_n_reg         <= 'b1;
					end
				s1: begin 
					EN_X_inSRAM_n_reg         <= 'b1;  
    	            EN_update_addr_X_n_reg    <= 'b1;
    	            EN_update_addr_W_n_reg    <= 'b1;
    	            EN_update_addr_Win_n_reg  <= 'b1;
    	            EN_update_addr_Winb_n_reg <= 'b1;
    	            EN_update_addr_Wout_n_reg <= 'b1;
    	            SEL_inSRAM_offchip_reg    <= 'b100;
					addr_inSRAM_offchip_reg   <= 'b0;

    	            EN_in_X2_n_reg        <= 'b1;
    	            EN_in_X1_n_reg        <= 'b1;
    	            EN_in_W_n_reg         <= 'b1;
    	            EN_in_Win_n_reg       <= 'b1;
    	            EN_in_Winb_n_reg      <= 'b1;
    	            EN_in_Wout_n_reg      <= 'b1;
					EN_reg_y_n_reg        <= 'b1;


					EN_y_sum_in_n_reg        <= 'b1;
					EN_input_Woutb_reg       <= 'b1;
					EN_sum2_n_reg            <= 'b1;
					EN_y_o_n_reg             <= 'b1;

					end
				s2: begin
					EN_X_inSRAM_n_reg         <= (count_s2 >= 11 && count_s2 <= node_num + 10) ? 'b0 : 'b1;
    	            EN_update_addr_X_n_reg    <= (count_s2 >=  0 && count_s2 <= node_num	 ) ? 'b0 : 'b1;
    	            EN_update_addr_W_n_reg    <= (count_s2 >   1 && count_s2 <= node_num + 1 ) ? 'b0 : 'b1;
    	            EN_update_addr_Win_n_reg  <= (count_s2 >   0 && count_s2 <= node_num	 ) ? 'b0 : 'b1;
    	            EN_update_addr_Winb_n_reg <= (count_s2 >   1 && count_s2 <= node_num + 1 ) ? 'b0 : 'b1;
    	            EN_update_addr_Wout_n_reg <= (count_s2 >   8 && count_s2 <= node_num + 8 ) ? 'b0 : 'b1;
    	            SEL_inSRAM_offchip_reg    <= 'b100;
					addr_inSRAM_offchip_reg   <= 'b0;

					EN_in_X2_n_reg        <= (count_s2 >= 5 && count_s2 <= 5 + node_num - 1) ? 'b0 : 'b1;
					EN_in_X1_n_reg        <= (count_s2 >= 4 && count_s2 <= 4 + node_num - 1) ? 'b0 : 'b1;
					EN_in_W_n_reg         <= (count_s2 >= 5 && count_s2 <= 5 + node_num - 1) ? 'b0 : 'b1;
					EN_in_Win_n_reg       <= (count_s2 >= 4 && count_s2 <= 4 + node_num - 1) ? 'b0 : 'b1;
					EN_in_Winb_n_reg      <= (count_s2 >= 5 && count_s2 <= 5 + node_num - 1) ? 'b0 : 'b1;
					EN_in_Wout_n_reg      <= (count_s2 >= 12 && count_s2 <= 12 + node_num - 1) ? 'b0 : 'b1;
					EN_reg_y_n_reg        <= (count_s2 == 13 + node_num + 2) ? 'b0 : 'b1;

					EN_y_sum_in_n_reg  		 <= (count_s2 >= 13 && count_s2 <= 13 + node_num) ? 'b0 : 'b1;
					EN_input_Woutb_reg 		 <= (count_s2 >= 13 && count_s2 <= 13 + node_num - 1) ? 'b0 : 'b1;			
					EN_sum2_n_reg      		 <= (count_s2 >= 14) ? 'b0 : 'b1;
					EN_y_o_n_reg       		 <= (count_s2 >= 13 + node_num + 2) ? 'b0 : 'b1;

					end
				default: begin
					EN_X_inSRAM_n_reg         <= 'b1;
    	            EN_update_addr_X_n_reg    <= 'b1;
    	            EN_update_addr_W_n_reg    <= 'b1;
    	            EN_update_addr_Win_n_reg  <= 'b1;
    	            EN_update_addr_Winb_n_reg <= 'b1;
    	            EN_update_addr_Wout_n_reg <= 'b1;
    	            SEL_inSRAM_offchip_reg    <= 'b100;
					addr_inSRAM_offchip_reg   <= 'b0;

    	            EN_in_X2_n_reg        <= 'b1;
    	            EN_in_X1_n_reg        <= 'b1;
    	            EN_in_W_n_reg         <= 'b1;
    	            EN_in_Win_n_reg       <= 'b1;
    	            EN_in_Winb_n_reg      <= 'b1;
    	            EN_in_Wout_n_reg      <= 'b1;
					EN_reg_y_n_reg        <= 'b1;

					EN_y_sum_in_n_reg   	 <= 'b1;
					EN_input_Woutb_reg  	 <= 'b1;
					EN_sum2_n_reg       	 <= 'b1;
					EN_y_o_n_reg        	 <= 'b1;
					end
			endcase
		end		
endmodule
		
			