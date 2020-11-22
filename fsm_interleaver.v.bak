module fsm_interleaver(clk, reset, data_ready, K, u, data_valid, current_state, counter_out, length, init, K_out);
	input clk;
	input reset;
	input data_ready;
	input K;
	input u;
	output reg data_valid;

	output wire [12:0] counter_out;
	output reg [12:0] length;
	output reg init;
	output reg K_out;

	output reg [2:0]current_state;
	reg [2:0]next_state;

	reg clear_cnt;
	reg count_en;
	wire cmp_out;
	reg K_reg;

	counter cnt(clear_cnt, clk, count_en, counter_out);
	cmp cm(counter_out, length-13'd1, cmp_out);

	parameter A = 3'd0;   //init
	parameter B = 3'd1;   //wait data
	parameter C = 3'd2;   //acquire data length
	parameter D = 3'd3;   //receive bit-serial input bits
	parameter D2 = 3'd6;  //push bit_shuffled data into queue
	parameter E = 3'd4;   //set data_valid
	parameter F = 3'd5;   //reset state

	parameter K1 = 13'd1056;
	parameter K2 = 13'd6144;

	//parameter K1 = 13'd8;
	//parameter K2 = 13'd16;

	always @(posedge clk)
	  begin
		 if(reset)
		  current_state <= F;
		else
		  current_state <= next_state;	  
	  end
	  
	always @(posedge clk)
	  begin
		 if(reset)
		begin
		  clear_cnt <= 1'd1;
		  count_en <= 1'd0;
		end
		else if (current_state == D || current_state == D2)
		begin
			if(current_state == D && next_state == D2)	
				clear_cnt <= 1'd1;
			else
				clear_cnt <= 1'd0;
			count_en <= 1'd1;
		end
		else
		begin
			clear_cnt <= 1'd0;
			count_en <= 1'd0;
	  end
	 end
	  
	always @(current_state or reset or data_ready or counter_out)
	  begin
		 if(reset)
		  next_state = F;
		else
		  case(current_state)
			 A: next_state = B;
			B: next_state = (data_ready==1'b1)?C:B;
			C: next_state = D;
			D: next_state = (cmp_out)?D:D2;
			D2: next_state = (cmp_out)?D2:E;
			E: next_state = A;
			F: next_state = A;
		  endcase
	  end
		
	always @(current_state or reset or K)
	  begin
		 if(reset)
		begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = 13'd0;
		end
		else
		  case(current_state)
			 A: 
			begin
			 data_valid = 1'b0;
			init = 1'b1;
			length = 13'd0;
			K_reg = 1'b0;
			K_out = 1'b0;
			end
			 B: 
			begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = 13'd0;
			K_reg = K_reg;
			K_out = K_out;
			end
			C:
			begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = (K==1'b0)?K1:K2;
			K_reg = K;
			K_out = K_out;
			end
			D:
			begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = length;
			K_reg = K_reg;
			K_out = K_out;
			end
			D2:
			begin
				data_valid = 1'b1;
				init = 1'b0;
				length = length;
				K_reg = K_reg;
				K_out = K_reg;
			end
			E:
			begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = 13'd0;
			K_reg = K_reg;
			K_out = K_out;
			end
			F:
			begin
			 data_valid = 1'b0;
			init = 1'b0;
			length = 13'd0;
			K_reg = K_reg;
			K_out = K_out;
			end
		  endcase  	  
	  end

endmodule 