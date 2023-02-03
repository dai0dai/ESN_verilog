
module ESN_top #(
    parameter bit_length 	= 32	,
	parameter node_num 		= 1000	,
	parameter time_point 	= 10	,
	parameter time_s2 		= 1000+14,
    parameter addr_length_heap = 10,
    parameter addr_length_Y = 11,
	parameter a           	= 'h3e99999a,   //0.3
	parameter a1          	= 'h3f333333,  //0.7
	parameter Woutb       	= 'hbecc6d1f   //-0.3992700297385454
) 
(
    output [bit_length - 1 : 0]       Data_Y_out,

    input  [bit_length - 1 : 0]       Data_in,
    input  [addr_length_heap - 1 : 0] addr_inSRAM_offchip,
    input  [2:0]                      SEL_SRAM_input,

    input                             EN_system_n, clk, nrst
);

    wire [bit_length - 1 : 0] out_RAM_X, out_RAM_W, out_RAM_Win, out_RAM_Winb, out_RAM_Wout;
    wire [bit_length - 1 : 0] X_next;  
    wire [1 : 0]              SRAM_State;  
    wire                      EN_X_inSRAM_n,         EN_update_addr_X_n,  
                              EN_update_addr_W_n,    EN_update_addr_Win_n, 
                              EN_update_addr_Winb_n, EN_update_addr_Wout_n; 
    
    wire [bit_length - 1 : 0] out_reg_X1, out_reg_X2, out_reg_W, out_reg_Win, out_reg_Winb, out_reg_Wout, 
                              out_reg_a, out_reg_u, out_reg_a1,  out_reg_Woutb, out_reg_y; 
    wire                      EN_in_X2_n,  EN_in_X1_n,  EN_in_W_n,  EN_in_Win_n, EN_in_Winb_n,
                              EN_in_Wout_n, EN_reg_y_n; 

    wire [bit_length - 1 : 0] y_o; 
    wire EN_y_sum_in_n, EN_input_Woutb, EN_sum2_n, EN_y_o_n; 
    

    SRAM_heap #( .addr_length(addr_length_heap), .bit_length(bit_length), .node_num(node_num) )
            SRAM_heap1( .Dataout_X_A(),             .Dataout_X_B(out_RAM_X),     .Dataout_W(out_RAM_W), 
                        .Dataout_Win(out_RAM_Win),  .Dataout_Winb(out_RAM_Winb), .Dataout_Wout(out_RAM_Wout),  

                        .SRAM_State(SRAM_State),

                        .SEL_inSRAM_offchip(SEL_SRAM_input), 
                        .addr_inSRAM_offchip(addr_inSRAM_offchip), 
                        .Data_offchip(Data_in),                         .Data_onchip(X_next), 
                        .EN_X_inSRAM_n(EN_X_inSRAM_n),                 .EN_update_addr_X_n(EN_update_addr_X_n), 
                        .EN_update_addr_W_n(EN_update_addr_W_n),        .EN_update_addr_Win_n(EN_update_addr_Win_n), 
                        .EN_update_addr_Winb_n(EN_update_addr_Winb_n),  .EN_update_addr_Wout_n(EN_update_addr_Wout_n), 

                        .clk(clk), .nrst(nrst)
            );

    Reg_heap #( .bit_length(bit_length), .a(a), .a1(a1), .Woutb(Woutb))
            Reg_heap1(  .out_reg_X1(out_reg_X1),        .out_reg_X2(out_reg_X2),        .out_reg_W(out_reg_W),      .out_reg_Win(out_reg_Win), 
                        .out_reg_Winb(out_reg_Winb),    .out_reg_Wout(out_reg_Wout),    
                        .out_reg_a(out_reg_a),          .out_reg_a1(out_reg_a1),    .out_reg_Woutb(out_reg_Woutb),
        
                        .in_reg_X(out_RAM_X),        .in_reg_W(out_RAM_W),        .in_reg_Win(out_RAM_Win), .in_reg_Winb(out_RAM_Winb),
                        .in_reg_Wout(out_RAM_Wout),  

                        .EN_in_X2_n(EN_in_X2_n),      .EN_in_X1_n(EN_in_X1_n),  .EN_in_W_n(EN_in_W_n),  .EN_in_Win_n(EN_in_Win_n), 
                        .EN_in_Winb_n(EN_in_Winb_n),  .EN_in_Wout_n(EN_in_Wout_n),  
                       
                        .clk(clk), .nrst(nrst)
            );

    pe #( .N(bit_length) )
            pe1 ( .x_o(X_next),    .y_o(y_o),

                 .clk(clk),        .EN_y_sum_in_n(EN_y_sum_in_n),        .EN_input_Woutb(EN_input_Woutb), 
				 .EN_sum2_n(EN_sum2_n), .EN_y_o_n(EN_y_o_n),
                 .x1(out_reg_X1),  .W(out_reg_W),        .u(out_reg_y),  .Win(out_reg_Win),  .Winb(out_reg_Winb),
                 .x2(out_reg_X2),  .Wout(out_reg_Wout),  .a(out_reg_a),  .a_1(out_reg_a1),   .Woutb(out_reg_Woutb)
            );

    assign Data_Y_out = out_reg_y;

	Reg_Y #(.bit_length(bit_length))
			Reg_Y1(
					.out_reg_y(out_reg_y),
					.y_o(y_o),
					.EN_reg_y_n(EN_reg_y_n),
	                .clk(clk), .nrst(nrst)
					);
	
    Control #(.node_num(node_num), .time_s1(node_num*5), .time_s2(time_s2), .time_point_s2(time_point))
			Control1(   
				.SRAM_State(SRAM_State),
				.EN_X_inSRAM_n(EN_X_inSRAM_n),      	.EN_update_addr_X_n(EN_update_addr_X_n),  
				.EN_update_addr_W_n(EN_update_addr_W_n),    	.EN_update_addr_Win_n(EN_update_addr_Win_n),
				.EN_update_addr_Winb_n(EN_update_addr_Winb_n), 	.EN_update_addr_Wout_n(EN_update_addr_Wout_n),
				.EN_in_X2_n(EN_in_X2_n),  .EN_in_X1_n(EN_in_X1_n),  .EN_in_W_n(EN_in_W_n),  
				.EN_in_Win_n(EN_in_Win_n), .EN_in_Winb_n(EN_in_Winb_n),
				.EN_in_Wout_n(EN_in_Wout_n), .EN_reg_y_n(EN_reg_y_n),
				
				.EN_y_sum_in_n(EN_y_sum_in_n), .EN_input_Woutb(EN_input_Woutb), .EN_sum2_n(EN_sum2_n), .EN_y_o_n(EN_y_o_n),

				.clk(clk), .nrst(nrst), .EN_system_n(EN_system_n)
			);




endmodule
