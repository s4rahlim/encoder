module wrapper(K, clk, ck, xk, zk, aclr);
	input [31:0] K;
	input clk, ck, aclr; 
	output xk, zk;
	
	
	wire ck1, xk1, zk1, aclr, data_ready, K_bit; //output of fifo
	FIFO f1(ck1); //first fifo we make to hold the ck input until other fifo is ready (from interleaver) 
	FIFO f2(ck2); 
	
	encoder e1(ck1, clk, data_ready, aclr, xk1, zk1, K_bit, busy);
	encoder e2(ck2, clk, data_ready, aclr, xk2, zk2, K_bit, busy);

	FIFO out1(xk1);
	FIFO out2(zk1);
	FIFO out3(xk2);
	FIFO out4(zk2);
	
endmodule 