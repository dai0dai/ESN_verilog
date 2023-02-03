`timescale 1ns / 1ps
module flt2fix(input [31:0] flt_in,output wire [6:0] int_part);

wire [7:0] mi;
wire [7:0] mi_min;
wire [7:0] mi_middle;
wire [7:0] mi_max;
wire[3:0] ei;

assign find_loc0 = flt_in[30:23] < 'b01111011;  // <0.0625 
assign find_loc1 = flt_in[30:23] < 'b10000000;  // <2
assign find_loc2 = flt_in[30:23] < 'b10000001;  // <4
assign find_loc3 = flt_in[30:23] < 'b10000010;  // <8

assign mi_min = {1'b1,flt_in[22:16]};
assign mi_middle = {4'b1,flt_in[22:19]};
assign mi_max = {7'b1,flt_in[22]};
assign ei = 127 + 3 - flt_in[30:23];
wire [7:0] temp;
assign mi = find_loc1 ? (find_loc0 ? 0 : mi_min ): find_loc2 ? mi_middle : find_loc3 ? mi_max : 0; 
assign temp = mi >> ei; 
assign int_part =  find_loc1 ? (find_loc0 ? 0 : temp[6:0]) : find_loc2 ? (temp[3:0] + 'd28) : find_loc3 ? (temp[0] + 'd35) : 0; 


endmodule
