module led_wrapper(	 input logic [0:0] SW,
		   input logic [4:0] KEY,	// instead of "[4:0] KEY", shouldn't it be "[3:0] KEY" since we are only using four KEYS: 0, 1, 2 and 3?
											 
							 output logic [6:0] HEX1,
                      output logic [6:0] HEX0);
							 
led test ( SW[0], KEY[3], KEY[2], KEY[1], KEY[0],  HEX1[6:0], HEX0[6:0] );

endmodule
