module encoder_parallel1(ck, clk, data_ready, aclr, xk, zk, tail, K, busy, counter);
	input [7:0] ck;
	input clk, data_ready, aclr, K; //0 is smaller block 1056, 1 is larger block 6144
	output [7:0] xk, zk;
	output [2:0] tail; 
//	output [2:0] x;
	output [9:0] counter;
	output busy;

	reg [3:0] x;
	reg [9:0] counter; 
	reg data_rdy;
	reg [9:0] K_size; 
	
	
	wire d00, d10, d20, d01, d11, d21, d02, d12, d22, d03, d13, d23, d04, d14, d24, d05, d15, d25, d06, d16, d26, d07, d17, d27;
	
	always @(posedge clk) begin
      if (aclr) begin
			counter = 0;
			data_rdy = 1'b0;
			K_size = 0;
			x = 0;
		end
		else begin
			x[0] = d17;
			x[1] = d27;
			x[2] = (d17^d07)^ck[1];
		end
		
	  if (data_ready) begin 
			data_rdy = 1'b1;
			if (K) begin
				 K_size = 32'd2; //16/8
			end
			else begin
				 K_size = 32'd132; //1056/8
			end
			counter = 1;
	  end
	  else begin
			if(data_rdy == 1) begin
				counter = counter + 1;
			end
		  
			if(counter > K_size) begin // after tail bits are generated
					data_rdy = 1'b0;
					counter = 0;
			end

	  end 
		  
	end 
	



	
	assign last = (counter == K_size);
	assign tail[0] = d27^d07;
	assign tail[1] = d17;
	assign tail[2] = d27;
	
	
	assign d00 = x[0]; 
	assign d10 = x[1]; 
	assign d20 = x[2]; 
	
	assign d01 = x[1];
	assign d11 = x[2]; 
	assign d21 = (x[0]^x[1])^ck[0]; 
	
	assign d02 = x[2];  
	assign d12 = (x[0]^x[1])^ck[0]; 
	assign d22 = (x[1]^x[2])^ck[1]; 
	
	assign d03 = (x[0]^x[1])^ck[0]; 
	assign d13 = (x[1]^x[2])^ck[1]; 
	assign d23 = (x[2]^((x[0]^x[1])^ck[0]))^ck[2]; 

	assign d04 = (x[1]^x[2])^ck[1];  
	assign d14 = (x[2]^((x[0]^x[1])^ck[0]))^ck[2]; 
	assign d24 = (((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3]; 
	
	assign d05 = (x[2]^((x[0]^x[1])^ck[0]))^ck[2];
	assign d15 = (((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3]; 
	assign d25 = (((x[1]^x[2])^ck[1])^((x[2]^((x[0]^x[1])^ck[0]))^ck[2]))^ck[4];
	
	assign d06 = (((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3]; 
	assign d16 = (((x[1]^x[2])^ck[1])^((x[2]^((x[0]^x[1])^ck[0]))^ck[2]))^ck[4];
	assign d26 = (((x[2]^((x[0]^x[1])^ck[0]))^ck[2])^((((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3]))^ck[5];
	
	assign d07 = (((x[1]^x[2])^ck[1])^((x[2]^((x[0]^x[1])^ck[0]))^ck[2]))^ck[4];
	assign d17 = (((x[2]^((x[0]^x[1])^ck[0]))^ck[2])^((((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3]))^ck[5];
	assign d27 = (((((x[0]^x[1])^ck[0])^((x[1]^x[2])^ck[1]))^ck[3])^((((x[1]^x[2])^ck[1])^((x[2]^((x[0]^x[1])^ck[0]))^ck[2]))^ck[4]))^ck[6];
	
	
	assign zk[0] = busy? (((d00^d10)^ck[0])^d20)^d00 : 1'b0;
	assign zk[1] = busy? (((d01^d11)^ck[1])^d21)^d01 : 1'b0;
	assign zk[2] = busy? (((d02^d12)^ck[2])^d22)^d02 : 1'b0;
	assign zk[3] = busy? (((d03^d13)^ck[3])^d23)^d03 : 1'b0;
	assign zk[4] = busy? (((d04^d14)^ck[4])^d24)^d04 : 1'b0;
	assign zk[5] = busy? (((d05^d15)^ck[5])^d25)^d05 : 1'b0;
	assign zk[6] = busy? (((d06^d16)^ck[6])^d26)^d06 : 1'b0;
	assign zk[7] = busy? (((d07^d17)^ck[7])^d27)^d07 : 1'b0;
	
	assign xk = ck; 
	assign dd0 = d06;
	assign dd1 = d16;
	assign dd2 = d26;
	assign busy = (0 < counter && counter <= K_size);  
	
endmodule 