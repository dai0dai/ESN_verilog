`timescale 1ns / 1ps
module pe #(
    parameter N = 32   
)
(
    input  wire  clk, EN_y_sum_in_n, EN_input_Woutb, EN_sum2_n, EN_y_o_n,//nrst,
    input  wire  [N-1:0] x1,  //x_i
    input  wire  [N-1:0] W,   //W_i
    input  wire  [N-1:0] u, 
    input  wire  [N-1:0] Win,
    input  wire  [N-1:0] Winb,
    input  wire  [N-1:0] x2,  //x_i2: (1-a)x_i2
    input  wire  [N-1:0] Wout,   //Wout_i
    input  wire  [N-1:0] a,   //a
    input  wire  [N-1:0] a_1, //1-a
    input  wire  [N-1:0] Woutb,
    

    output wire  [N-1:0] x_o,
    output wire  [N-1:0] y_o
);
    
    wire [N-1:0] Mul_1;  //W*x  
    wire [N-1:0] Mul_2;  //Win*u
    wire [N-1:0] Mul_3;
    wire [N-1:0] Mul_4;
    wire [N-1:0] Add_1;
    wire [N-1:0] Add_2;
    wire [N-1:0] Af_o;
    wire [N-1:0] WoutXo;
    reg [N-1:0] y_sum_in;

    reg [N-1:0] buf_mul4 [5:0];


// (1-a)*x(n-1) + a*tanh[(Winb; Win)*(1;u(n)) + W*x(n-1)]

// w_i * x_i
    mul mul1(.clk(clk),  .opa(x2),    .opb(W),
            .out(Mul_1) 
            );

// Win * u
    mul mul2(.clk(clk),  .opa(u),     .opb(Win),
            .out(Mul_2)
            );

// (Winb; Win)*(1;u(n))
    add add1(.clk(clk),  .opa(Mul_2), .opb(Winb),
            .out(Add_1)
            );

// (Winb; Win)*(1;u(n)) + W*x(n-1)
    add add2(.clk(clk),  .opa(Mul_1), .opb(Add_1),
            .out(Add_2)
            );

// tanh[(Winb; Win)*(1;u(n)) + W*x(n-1)]
    af_tanh_kxb #(.N(32), .lutnum(37)) tanh1 
            (.clk(clk), .innum(Add_2),
             .tanh_innum(Af_o)  
            );

// a*tanh[(Winb; Win)*(1;u(n)) + W*x(n-1)]
    mul mul3(.clk(clk),  .opa(Af_o), .opb(a),
            .out(Mul_3)
            );

// (1-a)*x(n-1)
    mul mul4(.clk(clk),  .opa(x1),   .opb(a_1),
            .out(Mul_4)
            );


//mul4 delay5clk	
	always@(posedge clk)
	begin
		buf_mul4[0] <= Mul_4;
        buf_mul4[1] <= buf_mul4[0];
        buf_mul4[2] <= buf_mul4[1];
        buf_mul4[3] <= buf_mul4[2];
        buf_mul4[4] <= buf_mul4[3];
        buf_mul4[5] <= buf_mul4[4];
/* 		for (i = 0; i < 5; i = i + 1) 
		buf_mul4[i+1] <= buf_mul4[i]; */
	end        



// (1-a)*x(n-1) + a*tanh[(Winb; Win)*(1;u(n)) + W*x(n-1)]
    add add3(.clk(clk),  .opa(Mul_3),.opb(buf_mul4[5]),  
            .out(x_o)
            );

// Wout_i * x(n)
    mul mulout( .clk(clk), .opa(Wout), .opb(x_o),
            .out(WoutXo)
            );


	wire [N-1:0] sum_2;
	wire [N-1:0] sum;
	//reg [3:0] count;
	//reg EN;
	
	always@(posedge clk) begin
	y_sum_in <= EN_y_sum_in_n ? 'd0 : (EN_input_Woutb ? Woutb : WoutXo); 
	end
		
	assign sum_2 = EN_sum2_n ? 0 : sum;
	
	add addsum(.clk(clk),  .opa(sum_2), .opb(y_sum_in),
               .out(sum)
            );
	assign y_o = EN_y_o_n ? 0 : sum;

endmodule
