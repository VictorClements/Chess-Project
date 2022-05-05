module sevenseg(input  logic [3:0] data, 
                output logic [6:0] segments);
				
	always_comb
		case (data)
			//					   
			0:		  segments = 7'h40;
			1:		  segments = 7'h79;
			2:		  segments = 7'h24;
			3:		  segments = 7'h30;
			4:		  segments = 7'h19;
			5:		  segments = 7'h12;
			6:		  segments = 7'h02;
			7:		  segments = 7'h78;
			8:		  segments = 7'h00;
			9:		  segments = 7'h18;
			10:		  segments = 7'h08;
			11:		  segments = 7'h03;
			12:		  segments = 7'h27;
			13:		  segments = 7'h21;
			14:		  segments = 7'h06;
			15:		  segments = 7'h0e;
			default:  segments = 7'h7f;
		endcase
endmodule