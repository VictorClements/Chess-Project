module positionCounter(input  logic 	  clk1, clk2,
					   input  logic 	  reset,
					   input  logic 	  UP,
					   output logic	[3:0] rowNum, columnNum,
					   output logic [6:0] rowDisplay, columnDisplay);

	Counter4    row(clk1, reset, UP, rowNum, rowDisplay);
	Counter4 column(clk2, reset, UP, columnNum, columnDisplay);
	
endmodule
