module positionCounterWrapper(input  logic [1:0] KEY,
							  input  logic [17:0] SW, //[17,0]
							  output logic [7:0] LEDR,
							  output logic [6:0] HEX0, HEX1);
					   
	positionCounter myPosition(	KEY[1], KEY[0], SW[17], SW[0],
								LEDR[7:4], LEDR[3:0], HEX1[6:0], HEX0[6:0]);

endmodule
