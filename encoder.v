module encoder (ck, clk, data_ready, aclr, xk, zk, K, busy);
	input ck, clk, data_ready, aclr; 
	//datra_ready from interleaver to indicate data is ready, only one cycle 
	input K; //0 is smaller block 1056, 1 is larger block 6144
	output xk, zk, busy;
	
	wire q0, q1, q2, w3, s, m0, m1, last, mux_out;
	reg [31:0] counter; 
	reg data_rdy;
	reg [31:0] K_size; 
	
	always @(posedge clk) begin
		if (aclr)
			counter = 0; 
			data_rdy = 0;
		if (data_ready) begin 
			counter = 0;
			data_rdy = 1;
			if (K) begin
				K_size = 32'd6144;
			end
			else begin
				K_size = 32'd1056;
			end
		end 
		counter = counter+1;
	end
	
	dff d0(s, clk, data_rdy, aclr, q0);
	dff d1(q0, clk, data_rdy, aclr, q1);
	dff d2(q1, clk, data_rdy, aclr, q2);
	
	xor x0(m0, q1, q2); 
	xor x1(s, ck, mux_out);
	xor x2(m1, s, q0);
	xor x3(zk, m1, q2);
	
	assign xk = ck;
	assign last = (counter == K_size);
	assign busy = (0 < counter < (K_size + 3));  
	assign mux_out = last? ck : m0;
	
	//for last cycle, inputs to x1 should be tied together (mux with counter signal)
	
endmodule 