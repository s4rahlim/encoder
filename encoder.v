module encoder (ck, clk, data_ready, aclr, xk, zk, K, busy, dd0, dd1, dd2);
	input ck, clk, data_ready, aclr; 
	//datra_ready from interleaver to indicate data is ready, only one cycle 
	input K; //0 is smaller block 1056, 1 is larger block 6144
	output xk, zk, busy, dd0, dd1, dd2;
	
	wire q0, q1, q2, w3, s, m0, m1, last, mux_out;
	reg [31:0] counter; 
	reg data_rdy;
	reg [31:0] K_size; 
	
	always @(posedge clk) begin
		if (aclr) begin
			counter = 0;
			data_rdy = 1'b0;
		end
        
        if (data_ready) begin 
            data_rdy = 1'b1;
			if (K) begin
				K_size = 32'd6144;
			end
			else begin
				K_size = 32'd1056;
			end
            counter = 1;
		end
        
        if(data_rdy == 1) begin
            counter = counter + 1;
        end
        
        if(counter == K_size + 1 + 3) begin // after tail bits are generated
            data_rdy = 1'b0;
            counter = 0;
        end

	end
	
	dffe_ref d0(s, clk, data_rdy, aclr, q0);
	dffe_ref d1(q0, clk, data_rdy, aclr, q1);
	dffe_ref d2(q1, clk, data_rdy, aclr, q2);
	
	xor x0(m0, q1, q2); 
	//xor x1(s, ck, mux_out);
	xor x1(s, m0, mux_out);
	xor x2(m1, s, q0);
	xor x3(zk, m1, q2);
	assign xk = ck;
	assign last = (counter >= K_size + 1);
	assign busy = (0 < counter <= (K_size));  
	assign mux_out = last? m0 : ck;
	assign dd0 = q0;
	assign dd1 = q1;
	assign dd2 = q2;
	//assign mux_out = last? ck : m0;
	
	//for last cycle, inputs to x1 should be tied together (mux with counter signal)
	
endmodule 
