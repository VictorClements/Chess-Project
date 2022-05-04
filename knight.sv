/*
Encoding:
color: black = 1, white = 0
position (0,0) is in top left of board
position (7,7) is in bottom right of board
knight allowable moves: 
knightAllow[0] = up    2  left  1
knightAllow[1] = up    2  right 1
knightAllow[2] = right 2  up    1
knightAllow[3] = right 2  down  1
knightAllow[4] = down  2  right 1
knightAllow[5] = down  2  left  1
knightAllow[6] = left  2  down  1
knightAllow[7] = left  2  up    1
*/

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 5 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bits 4:2 represents piece type 001 Pawn, 010 knight, 011 bishop, 100 rook, 101 queen, 110 king, 000 N/A
module knight(input  logic [2:0] row,
			  input  logic [2:0] column,
			  input  logic 	     color,
			  input  logic [2:0] boardPos [7:0][7:0],
			  output logic [2:0] pawnAllow);

//start
always_comb		begin
	//determines if possible movements are allowed based on position and other pieces
	if((row[2:1] == 2'b00) | (column == 3'b000))	knightAllow[0] = 1'b0;	// if in top two rows or leftmost column then cannot go up 2 left 1
	else if(boardPos[row-2][column-1][1] == color)	knightAllow[0] = 1'b0;	// else if same color piece at up 2 left 1 then cannot go up 2 left 1
	else					knightAllow[0] = 1'b1;	// else can go up 2 left 1
	if((row[2:1] == 2'b00) | (column == 3'b111))	knightAllow[1] = 1'b0;	// if in top two rows or rightmost column then cannot go up 2 right 1
	else if(boardPos[row-2][column+1][1] == color)	knightAllow[1] = 1'b0;	// else if same color piece at up 2 right 1 then cannot go up 2 right 1
	else					knightAllow[1] = 1'b1;	// else can go up 2 right 1
	if((row == 3'b000) | (column[2:1] == 2'b11))	knightAllow[2] = 1'b0;	// if in top row or two rightmost columns then cannot go right 2 up 1
	else if(boardPos[row-1][column+2][1] == color)	knightAllow[2] = 1'b0;	// else if same color piece at right 2 up 1 then cannot go right 2 up 1
	else					knightAllow[2] = 1'b1;	// else can go right 2 up 1
	if((row == 3'b111) | (column[2:1] == 2'b11))	knightAllow[3] = 1'b0;	// if in bottom row or two rightmost columns then cannot go right 2 down 1
	else if(boardPos[row+1][column+2][1] == color)	knightAllow[3] = 1'b0;	// else if same color piece at right 2 down 1 then cannot go right 2 down 1
	else					knightAllow[3] = 1'b1;	// else can go right 2 down 1
	if((row[2:1] == 2'b11) | (column == 3'b111))	knightAllow[4] = 1'b0;	// if in bottom two rows or rightmost column then cannot go down 2 right 1
	else if(boardPos[row+2][column+1][1] == color)	knightAllow[4] = 1'b0;	// else if same color piece at down 2 right 1 then cannot go down 2 right 1
	else					knightAllow[4] = 1'b1;	// else can go down 2 right 1
	if((row[2:1] == 2'b11) | (column == 3'b000))	knightAllow[5] = 1'b0;	// if in bottom two rows or leftmost column then cannot go down 2 left 1
	else if(boardPos[row+2][column-1][1] == color)	knightAllow[5] = 1'b0;	// else if same color piece at down 2 left 1 then cannot go down 2 left 1
	else					knightAllow[5] = 1'b1;	// else can go down 2 left 1
	if((row == 3'b111) | (column[2:1] == 2'b00))	knightAllow[6] = 1'b0;	// if in bottom row or two leftmost columns then cannot go left 2 down 1
	else if(boardPos[row+1][column-2][1] == color)	knightAllow[6] = 1'b0;	// else if same color piece at left 2 down 1 then cannot go left 2 down 1
	else					knightAllow[6] = 1'b1;	// else can go left 2 down 1
	if((row == 3'b000) | (column[2:1] == 2'b00))	knightAllow[7] = 1'b0;	// if in top row or two leftmost columns then cannot go left 2 up 1
	else if(boardPos[row+1][column-2][1] == color)	knightAllow[7] = 1'b0;	// else if same color piece at left 2 up 1 then cannot go left 2 up 1
	else					knightAllow[7] = 1'b1;	// else can go left 2 up 1
end
//end

endmodule

//can replace start to end with the following after the black case is finished and the boardpos check is moved into an else if
/*
	always_comb
		case(color)
			//white pieces
			1'b0:	begin
				//determines if possible movements are allowed based on position and other pieces
				//may need to change boardpos check into an extra else if statement to prevent things like boardPos[-2][-1][1]
				if((row[2:1] == 2'b00) | (column == 3'b000) | (boardPos[row-2][column-1][1] == 1'b0))	knightAllow[0] = 1'b0;
				else																					knightAllow[0] = 1'b1;
				if((row[2:1] == 2'b00) | (column == 3'b111) | (boardPos[row-2][column+1][1] == 1'b0))	knightAllow[1] = 1'b0;
				else																					knightAllow[1] = 1'b1;
				if((row == 3'b000) | (column[2:1] == 2'b11) | (boardPos[row-1][column+2][1] == 1'b0))	knightAllow[2] = 1'b0;
				else																					knightAllow[2] = 1'b1;
				if((row == 3'b111) | (column[2:1] == 2'b11) | (boardPos[row+1][column+2][1] == 1'b0))	knightAllow[3] = 1'b0;
				else																					knightAllow[3] = 1'b1;
				if((row[2:1] == 2'b11) | (column == 3'b111) | (boardPos[row+2][column+1][1] == 1'b0))	knightAllow[4] = 1'b0;
				else																					knightAllow[4] = 1'b1;
				if((row[2:1] == 2'b11) | (column == 3'b000) | (boardPos[row+2][column-1][1] == 1'b0))	knightAllow[5] = 1'b0;
				else																					knightAllow[5] = 1'b1;
				if((row == 3'b111) | (column[2:1] == 2'b00) | (boardPos[row-2][column-1][1] == 1'b0))	knightAllow[6] = 1'b0;
				else																					knightAllow[6] = 1'b1;
				if((row == 3'b000) | (column[2:1] == 2'b00) | (boardPos[row-2][column-1][1] == 1'b0))	knightAllow[7] = 1'b0;
				else																					knightAllow[7] = 1'b1;																					knightAllow[2] = 1'b1;				
			end
			//black pieces
			1'b1:	begin
				//determines if possible movements are allowed based on position and other pieces
				if((row == 3'b111) | (boardPos[row+1][column][0] == 1'b1))																		pawnAllow[2] = 1'b0;	// if in bottom row, or there is a piece in row below of pawn, cannot move forward
				else																															pawnAllow[2] = 1'b1;	// can move forward
				if((row == 3'b111) | (column == 3'b0) | (boardPos[row+1][column-1][0] == 1'b0) | (boardPos[row+1][column-1][1:0] == 2'b11))		pawnAllow[1] = 1'b0;	// if in bottom row, or in leftmost column, or if there is no piece diagonally to the left, or if there is a black piece diagonally to the left, cannot move diagonally left
				else																															pawnAllow[1] = 1'b1;	// can move diagleft
				if((row == 3'b111) | (column == 3'b111) | (boardPos[row+1][column+1][0] == 1'b0) | (boardPos[row+1][column+1][1:0] == 2'b11))	pawnAllow[0] = 1'b0;	// if in bottom row, or in rightmost column, or if there is no piece diagonally to the right, or if there is a black piece diagonally to the right, cannot move diagonally right
				else																															pawnAllow[0] = 1'b1;	// can move diagright
			end
		endcase
*/
