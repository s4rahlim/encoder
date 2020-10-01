module encoder (ck, clk, data_ready, aclr, xk, zk, K);
	input ck, clk, data_ready, aclr;
	input [31:0] K; //how many bits are getting passed in 
	output xk, zk;
	
	wire q0, q1, q2, w3, s, m0, m1, last, mux_out;
	reg [31:0] counter; 
	reg data_rdy;

	
	always @(posedge clk) begin
		if (aclr)
			counter = 0; 
			data_rdy = 0;
		if (data_rdy) begin 
			counter = counter + 1;
			data_rdy = 1;
		end 
	end
	
	dff d0(s, clk, data_rdy, aclr, q0);
	dff d1(q0, clk, data_rdy, aclr, q1);
	dff d2(q1, clk, data_rdy, aclr, q2);
	
	
	
	xor x0(m0, q1, q2); 
	xor x1(s, ck, mux_out);
	xor x2(m1, s, q0);
	xor x3(zk, m1, q2);
	
	assign xk = ck;
	
	assign last = (counter == K);
	assign mux_out = last? ck : m0;
	
	//for last cycle, inputs to x1 should be tied together (mux with counter signal)
	
endmodule 