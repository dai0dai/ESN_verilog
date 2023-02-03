/////////////////////////////////////////////////////////////////////
////                                                             ////
////  EXCEPT                                                     ////
////  Floating Point Exception/Special Numbers Unit              ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////


`timescale 1ns / 100ps


module except(	clk, opa, opb, inf, ind, qnan, snan, opa_nan, opb_nan,
		opa_00, opb_00, opa_inf, opb_inf, opa_dn, opb_dn);
input		clk;
input	[31:0]	opa, opb;
output		inf, ind, qnan, snan, opa_nan, opb_nan;
output		opa_00, opb_00;
output		opa_inf, opb_inf;
output		opa_dn;
output		opb_dn;

////////////////////////////////////////////////////////////////////////
//
// Local Wires and registers
//

wire	[7:0]	expa, expb;		// alias to opX exponent
wire	[22:0]	fracta, fractb;		// alias to opX fraction
reg		expa_ff, infa_f_r, qnan_r_a, snan_r_a;
reg		expb_ff, infb_f_r, qnan_r_b, snan_r_b;
reg		inf, ind, qnan, snan;	// Output registers
reg		opa_nan, opb_nan;
reg		expa_00, expb_00, fracta_00, fractb_00;
reg		opa_00, opb_00;
reg		opa_inf, opb_inf;
reg		opa_dn, opb_dn;

////////////////////////////////////////////////////////////////////////
//
// Aliases

assign   expa = opa[30:23];
assign   expb = opb[30:23];
assign fracta = opa[22:0];
assign fractb = opb[22:0];

////////////////////////////////////////////////////////////////////////
//
// Determine if any of the input operators is a INF or NAN or any other special number
// 1clk
always @(*) 
	expa_ff =   &expa;

always @(*) 
	expb_ff =   &expb;
	
always @(*) 
	infa_f_r =   !(|fracta);

always @(*) 
	infb_f_r =   !(|fractb);

always @(*) 
	qnan_r_a =    fracta[22];

always @(*)
	snan_r_a =   !fracta[22] & |fracta[21:0];
	
always @(*) 
	qnan_r_b =    fractb[22];

always @(*) 
	snan_r_b =   !fractb[22] & |fractb[21:0];


// 2clk
always @(*) 
	ind  =   (expa_ff & infa_f_r) & (expb_ff & infb_f_r);

always @(*) 
	inf  =   (expa_ff & infa_f_r) | (expb_ff & infb_f_r);

always @(*) 
	qnan =   (expa_ff & qnan_r_a) | (expb_ff & qnan_r_b);

always @(*)
	snan =   (expa_ff & snan_r_a) | (expb_ff & snan_r_b);


always @(*) 
	opa_nan =   &expa & (|fracta[22:0]);

always @(*) 
	opb_nan =   &expb & (|fractb[22:0]);

always @(*) 
	opa_inf =   (expa_ff & infa_f_r);

always @(*) 
	opb_inf =   (expb_ff & infb_f_r);

always @(*) 
	expa_00 =   !(|expa);

always @(*) 
	expb_00 =   !(|expb);

always @(*) 
	fracta_00 =   !(|fracta);

always @(*) 
	fractb_00 =   !(|fractb);

always @(*) 
	opa_00 =   expa_00 & fracta_00;

always @(*) 
	opb_00 =   expb_00 & fractb_00;

always @(*) 
	opa_dn =   expa_00;

always @(*) 
	opb_dn =   expb_00;

endmodule

