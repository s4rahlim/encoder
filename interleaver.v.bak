// File:    interleaver.v

module interleaver(clk, reset, data_ready, k_bit_in, FIFO_rdreq, cin, cout, data_valid, k_bit_out, TEMP_usedw, address_RAM, address_ROM, pi);

input clk, reset, data_ready, k_bit_in, FIFO_rdreq, cin;
output wire cout, k_bit_out;
output reg data_valid;

wire [12:0] count;
output wire [12:0] pi; /////// TEMP - move to wire [12:0]
wire c_prime, data_valid_FSM;
reg buffer1, FIFO_wrreq;

// optional signals
output wire [13:0] address_ROM;
output wire [12:0] address_RAM;
wire [12:0] length;
output wire [8:0] TEMP_usedw;
wire[2:0] current_state;
wire init;

assign address_ROM = {k_bit_in, count};

fsm_interleaver fsm(clk, reset, data_ready, k_bit_in, cin, data_valid_FSM, current_state, count, length, init, k_bit_out);
ROM rom(reset, address_ROM, 1'b1, clk, pi);

TurboCodeBlock tcb(
	.clk(clk), 
	.reset(reset), 
	.c(cin), 
	.K(k_bit_in), 
	.pi(pi), 
	.data_valid_FSM(data_valid_FSM), 
	.c_prime(c_prime), 
	.address_RAM(address_RAM), 
	.count(count)
);

FIFO fifo(
	.aclr(reset),
	.clock(clk),
	.data(c_prime),
	.rdreq(FIFO_rdreq),
	.wrreq(FIFO_wrreq),
	.q(cout),
	.usedw(TEMP_usedw)
);

always @ (posedge clk)
begin
	FIFO_wrreq <= data_valid_FSM;
	data_valid <= data_valid_FSM;
	//buffer1 <= data_valid;
	//FIFO_wrreq <= buffer1;
end

endmodule 