/*
Encoding:
color: black = 1, white = 0
position (0,0) is in top left of board
position (7,7) is in bottom right of board
pawn allowable moves: 
pawnAllow[2] = forward; 
pawnAllow[1] = diagLeft;
pawnAllow[0] = diagRight;
*/

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 3 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bit 2 represets if the space has a king on it, not a king = 0, king = 1 
module pawn(input  logic [2:0] row,
						input  logic [2:0] column,
						input  logic 	   	 color,
						input  logic [2:0] boardPos [7:0][7:0],
						output logic [2:0] pawnAllow);

	always_comb
		case(color)			//determines if possible movements are allowed based on position and other pieces
			1'b0:	begin		//white pieces
				if((row == 3'b0))																																						pawnAllow[2] = 1'b0;	// if in top row cannot move forward
				else if(boardPos[row-1][column][0] == 1'b1)																									pawnAllow[2] = 1'b0;	// if there is a piece in row above of pawn, cannot move forward
				else																																												pawnAllow[2] = 1'b1;	// can move forward
				
				if((row == 3'b0) | (column == 3'b0))																												pawnAllow[1] = 1'b0;	// if in top row, or in leftmost column cannot move diagonally left
				else if((boardPos[row-1][column-1][0] == 1'b0) | (boardPos[row-1][column-1][1:0] == 2'b01))	pawnAllow[1] = 1'b0;	// if there is no piece diagonally to the left, or if there is a white piece diagonally to the left, cannot move diagonally left
				else																																												pawnAllow[1] = 1'b1;	// can move diagleft
				
				if((row == 3'b0) | (column == 3'b111))																											pawnAllow[0] = 1'b0;	// if in top row, or in rightmost column cannot move diagonally right
				else if((boardPos[row-1][column+1][0] == 1'b0) | (boardPos[row-1][column+1][1:0] == 2'b01))	pawnAllow[0] = 1'b0;	// if there is no piece diagonally to the right, or if there is a white piece diagonally to the right, cannot move diagonally right
				else																																												pawnAllow[0] = 1'b1;	// can move diagright
			end
			//black pieces
			1'b1:	begin
				//determines if possible movements are allowed based on position and other pieces
				if(row == 3'b111)																																						pawnAllow[2] = 1'b0;	// if in bottom row cannot move forward
				else if(boardPos[row+1][column][0] == 1'b1)																									pawnAllow[2] = 1'b0;	// if there is a piece in row below of pawn, cannot move forward
				else																																												pawnAllow[2] = 1'b1;	// can move forward
				
				if((row == 3'b111) | (column == 3'b0))																											pawnAllow[1] = 1'b0;	// if in bottom row, or in leftmost column cannot move diagonally left
				else if((boardPos[row+1][column-1][0] == 1'b0) | (boardPos[row+1][column-1][1:0] == 2'b11))	pawnAllow[1] = 1'b0;	// if there is no piece diagonally to the left, or if there is a black piece diagonally to the left, cannot move diagonally left
				else																																												pawnAllow[1] = 1'b1;	// can move diagleft
				
				if((row == 3'b111) | (column == 3'b111))																										pawnAllow[0] = 1'b0;	// if in bottom row, or in rightmost column cannot move diagonally right
				else if((boardPos[row+1][column+1][0] == 1'b0) | (boardPos[row+1][column+1][1:0] == 2'b11))	pawnAllow[0] = 1'b0; 	// if there is no piece diagonally to the right, or if there is a black piece diagonally to the right, cannot move diagonally right
				else																																												pawnAllow[0] = 1'b1;	// can move diagright
			end
		endcase
	
endmodule
