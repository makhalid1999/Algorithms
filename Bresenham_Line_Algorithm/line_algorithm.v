module line_algorithm(x0, y0, x1, y1, x, y, Clk, RESET, Enable);
//Input/Output Declaration
	input [7:0] x0, x1;
	input [6:0] y0, y1;
	input Enable;
	reg [7:0] x_0, x_1;
	reg [6:0] y_0, y_1;
	output reg [7:0] x;
	output reg [6:0] y;
	reg [2:0] w;	/*Input for the FSM*/
	reg signed [8:0] dx, dy;
	reg sx, sy;
	reg signed [8:0] error;
	reg signed [9:0] e2;
	reg [1:0] Q;
	input Clk, RESET;
//Parameters and States
	parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10;
	reg [1:0] p_state, n_state;
	always @(*)
	begin
		w[0] = ((x == x_1)&(y == y_1))|(!RESET);
		w[1] = e2 > -dy;
		w[2] = e2 < dx;
	end
//Mealy FSM
	always @(posedge Clk, negedge RESET)
	begin
		if(!RESET)
			p_state = A;
		else
			p_state = n_state;
	end
	always @(*)
	begin
		case(p_state)
			A:	begin
				if(w[0] == 0)
				begin
				n_state = B;
				Q <= 2'b00;
				end
				else
				begin
				n_state = A;
				Q <= 2'b11;
				end
				end
			B:	begin
				n_state = C;
				if(w[1])
				Q <= 2'b01;
				else
				Q <= 2'b11;
				end
			C:	begin
				n_state = A;
				if(w[2])
				Q <= 2'b10;
				else
				Q <= 2'b11;
				end
		endcase
	end
//Using the output of the state machine in order to further our algorithm 
	always @(posedge Clk, negedge RESET)
	begin
		if(!RESET)
		begin
			x = (x0 < 160)?x0:159;
			y = (y0 < 120)?y0:119;
			x_0 = (x0 < 160)?x0:159;
			x_1 = (x1 < 160)?x1:159;
			y_0 = (y0 < 120)?y0:119;
			y_1 = (y1 < 120)?y1:119;
			e2 = 0;
			if(x_0 > x_1)
				dx = x_0 - x_1;
			else
				dx = x_1 - x_0;
			if(y_0 > y_1)
				dy = y_0 - y_1;
			else
				dy = y_1 - y_0;
			error = dx - dy;
		end
		else
		if(Enable)
		begin
			case(Q)
			2'b00: begin
				e2[9] <= error[8];
				e2[8] <= error[7];
				e2[7] <= error[6];
				e2[6] <= error[5];
				e2[5] <= error[4];
				e2[4] <= error[3];
				e2[3] <= error[2];
				e2[2] <= error[1];
				e2[1] <= error[0];
				e2[0] <= 0;
			end
			2'b01: begin
				error <= error - dy;
				if(x_0 < x_1)
					x <= x + 8'b00000001;
				else
					x <= x - 8'b00000001;
			end
			2'b10: begin
				error <= error + dx;
				if(y_0 < y_1)
					y <= y + 7'b0000001;
				else
					y <= y - 7'b0000001;
			end
			default: begin
				x <= x;
				y <= y;
			end
			endcase
		end
	end
endmodule