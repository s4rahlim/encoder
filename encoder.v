module encoder (ck, clk, data_ready, aclr, xk, zk, K, busy, dd0, dd1, dd2);
	input ck, clk, data_ready, aclr; 
	//datra_ready from interleaver to indicate data is ready, only one cycle 
	input K; //0 is smaller block 1056, 1 is larger block 6144
	output xk, zk, busy, dd0, dd1, dd2;
	//When count == K signal is sent to trellis termination to do tail-bit generation.
//	output [31:0] debug2;
//	output debug3;
	
	wire q0, q1, q2, w3, s, m0, m1, last, mux_out;
	reg [12:0] counter; 
	reg data_rdy;
	reg [31:0] K_size; 
	
	reg [31:0] inp_total;
//	reg debug3_r;
	
//	assign debug = last;
//	assign debug2 = inp_total; //counter;
//	assign debug3 = debug3_r;
	
//	always @(negedge clk) begin
//		if (data_rdy != 0 && (counter == (K_size +1)) && (inp_total != 32'd7)) begin
//			debug3_r = 1;
//		end
//		else begin
//			if(aclr) begin
//				debug3_r = 0;
//			end
//		end
//	end
	
	always @(posedge clk) begin
        if (aclr) begin
            counter = 0;
            data_rdy = 1'b0;
				K_size = 0;
        end
        if (data_ready) begin 
            data_rdy = 1'b1;
            if (K) begin
                K_size = 32'd16;
            end
            else begin
                K_size = 32'd1056;
            end
            counter = 1;
        end
		  else begin
				if(data_rdy == 1) begin
					counter = counter + 1;
					if(zk == 1) begin
						inp_total = inp_total + 1;
					end
			  end
			  
			  if(counter > K_size + 1 + 3) begin // after tail bits are generated
					data_rdy = 1'b0;
					counter = 0;
					inp_total = 0;
			  end
		  end        

	end
	
	
	dffe_ref d0(s, clk, counter != 0, aclr, q0); // en = busy | last
	dffe_ref d1(q0, clk, counter != 0, aclr, q1);
	dffe_ref d2(q1, clk, counter != 0, aclr, q2);
	
	xor x0(m0, q1, q2); 
	xor x1(s, m0, mux_out);
	xor x2(m1, s, q0);
	xor x3(zk, m1, q2);
	assign xk = ck;
	assign last = (counter > K_size+1);
	assign tailbits = (counter == K_size);
	assign busy = (0 < counter && counter <= (K_size)+1);  
	assign mux_out = last? m0 : ck;
	assign dd0 = q0;
	assign dd1 = q1;
	assign dd2 = q2;
	
	//for last cycle, inputs to x1 should be tied together (mux with counter signal)
	
endmodule 
