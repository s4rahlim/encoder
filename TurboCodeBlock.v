module TurboCodeBlock(clk, reset, c, K, pi, data_valid_FSM, c_prime, address_RAM, count);
	
	input clk, reset; // clk and reset inputs
	input c, K, data_valid_FSM; // various signals from CRC
	input [12:0] pi; // Index from ROM
	
	output c_prime; // Outputs to FIFO
	wire wrreq;
	//output reg buffered_wrreq;
	reg buffer1;
	
	//output[13:0] address_ROM; 
	input [12:0] count; // Address of ROM to access
	
	output[12:0] address_RAM; // Address of internal RAM buffer
	//wire data_valid_FSM; // Lets the buffer and FIFO know that we're ready to read into FIFO
	
	assign address_RAM = wrreq ? count : pi; // Address by pi when writing, count when reading
	
	buffer turbo_buffer(reset, address_RAM, clk, c /*in*/, wrreq /*rden*/, data_valid_FSM /*wren*/, c_prime /*out*/); // The shuffling/reorder buffer
	
	//wire[12:0] count_passer;
	wire[2:0] current_state, next_state;
	wire[12:0] length;
	wire init;
	
	//assign count = count_passer;
	assign wrreq = data_valid_FSM;

	//assign address_ROM = {K, count};
	//fsm_interleaver fsm(clk, reset, K, c, data_valid_FSM, current_state, count_passer, length, init);

	//ROM rom(reset, address_ROM, clk, pi);
	//always @ (posedge clk)
	//begin
	//	buffer1 <= data_valid_FSM;
	//	buffered_wrreq <= buffer1;
	//end
	
endmodule