module chess(input  logic	clk, reset, 
			 output logic	something);

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 5 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bits 4:2 represents piece type 001 Pawn, 010 knight, 011 bishop, 100 rook, 101 queen, 110 king, 000 N/A

	logic [4:0] boardPos [7:0][7:0];
	
always_ff @(posedge reset)	begin
	  boardPos[0][0][4:0] <= 5'b10011;	//Black rook
	  boardPos[0][1][4:0] <= 5'b01011;	//Black knight
	  boardPos[0][2][4:0] <= 5'b01111;	//Black bishop
	  boardPos[0][3][4:0] <= 5'b10111;	//Black Queen
	  boardPos[0][4][4:0] <= 5'b11011;	//Black King
	  boardPos[0][5][4:0] <= 5'b01111;	//Black bishop
	  boardPos[0][6][4:0] <= 5'b01011;	//Black knight
	  boardPos[0][7][4:0] <= 5'b10011;	//Black rook
	  boardPos[1][0][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][1][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][2][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][3][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][4][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][5][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][6][4:0] <= 5'b00111;	//black pawn
	  boardPos[1][7][4:0] <= 5'b00111;	//black pawn
	  boardPos[2][0][4:0] <= 5'b00000;	//empty
	  boardPos[2][1][4:0] <= 5'b00000;	//empty
	  boardPos[2][2][4:0] <= 5'b00000;	//empty
	  boardPos[2][3][4:0] <= 5'b00000;	//empty
	  boardPos[2][4][4:0] <= 5'b00000;	//empty
	  boardPos[2][5][4:0] <= 5'b00000;	//empty
	  boardPos[2][6][4:0] <= 5'b00000;	//empty
	  boardPos[2][7][4:0] <= 5'b00000;	//empty
	  boardPos[3][0][4:0] <= 5'b00000;	//empty
	  boardPos[3][1][4:0] <= 5'b00000;	//empty
	  boardPos[3][2][4:0] <= 5'b00000;	//empty
	  boardPos[3][3][4:0] <= 5'b00000;	//empty
	  boardPos[3][4][4:0] <= 5'b00000;	//empty
	  boardPos[3][5][4:0] <= 5'b00000;	//empty
	  boardPos[3][6][4:0] <= 5'b00000;	//empty
	  boardPos[3][7][4:0] <= 5'b00000;	//empty
	  boardPos[4][0][4:0] <= 5'b00000;	//empty
	  boardPos[4][1][4:0] <= 5'b00000;	//empty
	  boardPos[4][2][4:0] <= 5'b00000;	//empty
	  boardPos[4][3][4:0] <= 5'b00000;	//empty
	  boardPos[4][4][4:0] <= 5'b00000;	//empty
	  boardPos[4][5][4:0] <= 5'b00000;	//empty
	  boardPos[4][6][4:0] <= 5'b00000;	//empty
	  boardPos[4][7][4:0] <= 5'b00000;	//empty
	  boardPos[5][0][4:0] <= 5'b00000;	//empty
	  boardPos[5][1][4:0] <= 5'b00000;	//empty
	  boardPos[5][2][4:0] <= 5'b00000;	//empty
	  boardPos[5][3][4:0] <= 5'b00000;	//empty
	  boardPos[5][4][4:0] <= 5'b00000;	//empty
	  boardPos[5][5][4:0] <= 5'b00000;	//empty
	  boardPos[5][6][4:0] <= 5'b00000;	//empty
	  boardPos[5][7][4:0] <= 5'b00000;	//empty
	  boardPos[6][0][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][1][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][2][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][3][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][4][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][5][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][6][4:0] <= 5'b00101;	//White pawn
	  boardPos[6][7][4:0] <= 5'b00101;	//White pawn
	  boardPos[7][0][4:0] <= 5'b10001;	//White Rook
	  boardPos[7][1][4:0] <= 5'b01001;	//White Knight
	  boardPos[7][2][4:0] <= 5'b01101;	//White Bishop
	  boardPos[7][3][4:0] <= 5'b10101;	//White Queen
	  boardPos[7][4][4:0] <= 5'b11001;	//White King
	  boardPos[7][5][4:0] <= 5'b01101;	//White Bishop
	  boardPos[7][6][4:0] <= 5'b01001;	//White Knight
	  boardPos[7][7][4:0] <= 5'b10001;	//White rook
	end

endmodule

module FindBlacksMoves(input  logic [4:0] boardPos [7:0][7:0]
					   output logic )