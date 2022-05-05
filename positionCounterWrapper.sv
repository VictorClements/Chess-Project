module positionCounterWrapper(input  logic [1:0] KEY,
							  input  logic [1:0] SW,
							  output logic [6:0] HEX0, HEX1);
					   
	positionCounter myPosition(KEY[1], KEY[0], SW[0], SW[1], HEX1[6:0], HEX0[6:0]);

endmodule