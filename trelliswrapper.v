module trelliswrapper(K, clk, ck1, ck2, aclr, data_ready, d0, d1, d2, read_request);
	
    input K; // from interleaver
	input clk, ck1, ck2, aclr, data_ready; //ck1 = input to 1st encoder (direct ck), ck2 = input to 2nd encoder (output from FIFO at interleaver interface), data_ready = signal from interleaver saying bit serial data is ready to interpret
	output d0, d1, d2, read_request; // read_request = interleaver's fifo: telling it we're ready
	wire xk1, xk2, zk1, zk2;
	
	wire ck_encoder, busy1, busy2;
	
    wire [8:0] used_dw;
    FIFO f1(.aclr(aclr), .clock(clk), .data(ck1), .rdreq(busy2), .wrreq(data_ready == 0), .q(ck_encoder), .usedw(used_dw)); // fifo interfacing direct input (ck1) and 1st encoder (e1)

	 wire e1_d0, e1_d1, e1_d2, e2_d0, e2_d1, e2_d2;
	 wire [31:0] e1_debug2, e2_debug2;
	 wire tailbits1, tailbits2;
	 
	trellisencoder e1(ck_encoder, clk, data_ready, aclr, xk1, zk1, K, busy1, e1_d0, e1_d1, e1_d2, tailbits1);
	trellisencoder e2(ck2, clk, data_ready, aclr, xk2, zk2, K, busy2, e2_d0, e2_d1, e2_d2, taibits2);
	tailprocessor t(aclr, clk, e1_d0, e1_d1, xk1, zk1, xk2, zk2, tailbits2, d0, d1, d2);
    
    assign read_request = busy2; // busy2 and busy1 should be identical
	
endmodule 