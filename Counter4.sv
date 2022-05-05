module Counter4(input  logic 		clk,
				input  logic 		reset,
				input  logic 		UP,
				output logic [3:0]	q,
				output logic [6:0]	mySegs);
					
	always_ff @(posedge clk, posedge reset/*, posedge something*/) begin
		if (reset)   q <= 0;          // when reset is high, set signal to 1
		else if(UP) begin             // when UP is high, enter the else if
			case(q)                   // case depending on value of q
			4'd7 :    q <= 0;         // if q = 6, then set q back down to 1
			default : q <= q + 1;     // otherwise, increment q
			endcase
		end
		else        begin		      // when reset = 0, and UP = 0
			case(q)                   // case depend on value of q
			4'd0:     q <= 7;         // if q = 1, set q to 6
			default:  q <= q - 1;     // otherwise, decrement q
			endcase
		end
	end
	
	sevenseg display(q, mySegs);
	
endmodule
