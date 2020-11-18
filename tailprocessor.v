module tailprocessor(reset, clk, q01, q11, x1, z1, x2, z2, tailbits, d0, d1, d2);
	input reset, clk, x1, z1, x2, z2, q01, q11, tailbits;
	output reg d0, d1, d2;
	
	
	
	reg [2:0] state;
	
	parameter A=0, B=1, C=2, D=3, E=5;
	
	reg xK, zK, xK1, zK1, xK2, zK2;
	reg storedxK, storedzK, storedxK1, storedzK1, storedxK2, storedzK2;
	
	always @ (negedge clk)
		begin
			case(state)
				A:
					begin
					d0 = x1;
					d1 = z1;
					d2 = x2;
					
					storedxK = x2;
					storedzK = z2;
					storedxK1 = xK1;
					storedzK1 = zK1;
					storedxK2 = xK2;
					storedzK2 = zK2;
					end
				B:
					begin
					d0 = x1;
					d1 = z1;
					d2 = q11 ^ q01;
					
					storedxK = xK;
					storedzK = zK;
					storedxK1 = x2;
					storedzK1 = z2;
					storedxK2 = xK2;
					storedzK2 = zK2;
					
					end
				C:
					begin
					d0 = z1;
					d1 = q11 ^ q01;
					d2 = (q11 ^ q01) ^ (q11 ^ q01);
					
					storedxK = xK;
					storedzK = zK;
					storedxK1 = xK1;
					storedzK1 = zK1;
					storedxK2 = x2;
					storedzK2 = z2;
					end
				D:
					begin
					d0 = xK;
					d1 = zK;
					d2 = xK1;
					
					storedxK = xK;
					storedzK = zK;
					storedxK1 = xK1;
					storedzK1 = zK1;
					storedxK2 = xK2;
					storedzK2 = zK2;
					end
				E:
					begin
					d0 = zK1;
					d1 = xK2;
					d2 = zK2;
					
					storedxK = xK;
					storedzK = zK;
					storedxK1 = xK1;
					storedzK1 = zK1;
					storedxK2 = xK2;
					storedzK2 = zK2;
					end
			endcase
		end
	always @(posedge clk or posedge reset)
		begin
			xK = storedxK;
			zK = storedzK;
			xK1 = storedxK1;
			zK1 = storedzK1;
			xK2 = storedxK2;
			zK2 = storedzK2;
			if (reset)
				state = A;
			else
				case (state)
					A:
						if (tailbits)
							state = B;
						else
							state = A;
					B:
						state = C;
					C:
						state = D;
					D:
						state = E;
					E:
						state = A;
				endcase
		end
endmodule