/*
Encoding:
color: black = 1, white = 0
position (0,0) is in top left of board
position (7,7) is in bottom right of board
queen allowable moves: 
queenAllowUpLeft[2:0]
queenAllowUpRight[2:0]
queenAllowDownRight[2:0]
queenAllowDownLeft[2:0]
*/

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 3 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bit 2 represets if the space has a king on it, not a king = 0, king = 1 
module bishop(input  logic [2:0] row,
						  input  logic [2:0] column,
						  input  logic 	     color,
						  input  logic [2:0] boardPos [7:0][7:0],
					  	output logic [2:0] bishopAllowUpLeft, bishopAllowUpRight, bishopAllowDownRight, bishopAllowDownLeft);
	
always_comb	begin
	// determines if possible movements are allowed based on position and other pieces
	// not sure if row will be counted as signed or unsigned number, perhaps change comparisons to account for that
	// also unsure if bishopAllow = i - 1 will work properly, since the number of bits of i - 1 is not specified and we are storing it into a 3 bit logic variable
	
	// rookAllowUp
	for(int i = 1; i < 9; i++)	begin																						// iterates i from 1 to 8 and executes if conditional each time
		if((row < i) | (boardPos[row - i][column][1:0] == {color, 1'b1}))	begin 	// checks if row is less than i, or if boardPos "i" units above rook has a piece and is the same color as the rook
			rookAllowUp = i - 1;																										// set allowed distance of rook moving up to be i - 1
			break;																																	// break from for loop
		end
	end
	
	// rookAllowRight
	for(int i = 1; i < 9; i++)	begin																									// iterates i from 1 to 8 and executes if conditional each time
		if((column > 7 - i) | (boardPos[row][column + i][1:0] == {color, 1'b1}))	begin // checks if column is greater than 7 - i, or if boardPos "i" units right of rook has a piece and is the same color as the rook
			rookAllowRight = i - 1;																												// set allowed distance of rook moving right to be i - 1
			break;																																				// break from for loop
		end
	end
	
	// rookAllowDown
	for(int i = 1; i < 9; i++)	begin																								// iterates i from 1 to 8 and executes if conditional each time
		if((row > 7 - i) | (boardPos[row + i][column][1:0] == {color, 1'b1}))	begin 	// checks if row is greater than 7 - i, or if boardPos "i" units below rook has a piece and is the same color as the rook
			rookAllowDown = i - 1;																											// set allowed distance of rook moving down to be i - 1
			break;																																			// break from for loop
		end
	end
	
	// rookAllowLeft
	for(int i = 1; i < 9; i++)	begin																								// iterates i from 1 to 8 and executes if conditional each time
		if((column < i) | (boardPos[row][column - i][1:0] == {color, 1'b1}))	begin 	// checks if column is less than i, or if boardPos "i" units left of rook has a piece and is the same color as the rook
			rookAllowLeft = i - 1;																											// set allowed distance of rook moving left to be i - 1
			break;																																			// break from for loop
		end
	end
		
	
	// bishopAllowUpLeft
	for(int i = 1; i < 9; i++)	begin																						                    // iterates i from 1 to 8 and executes if conditional each time
    if((row < i) | (column < i) | (boardPos[row - i][column - i][1:0] == {color, 1'b1}))	begin 	// checks if row is less than i, if column is less than i, or if boardPos "i" units above and left of bishop has a piece and is the same color as the bishop
			bishopAllowUpLeft = i - 1;																								            		  // set allowed distance of bishop moving upLeft to be i - 1
			break;																																	                    // break from for loop
		end
	end
	
	// bishopAllowUpRight
	for(int i = 1; i < 9; i++)	begin																									                  // iterates i from 1 to 8 and executes if conditional each time
    if((column > 7 - i) | (row < i) | (boardPos[row - i][column + i][1:0] == {color, 1'b1}))	begin   // checks if column is greater than 7 - i, if row is less than i, or if boardPos "i" units above and right of bishop has a piece and is the same color as the bishop
			bishopAllowUpRight = i - 1;																												              // set allowed distance of bishop moving upRight to be i - 1
			break;																																				                  // break from for loop
		end
	end
	
	// bishopAllowDownRight
	for(int i = 1; i < 9; i++)	begin																								                        // iterates i from 1 to 8 and executes if conditional each time
    if((row > 7 - i) | (column > 7 - i) | (boardPos[row + i][column + i][1:0] == {color, 1'b1}))	begin 	// checks if row is greater than 7 - i, checks if column is greater than 7 - i, or if boardPos "i" units below and right bishop has a piece and is the same color as the bishop
			bishopAllowDownRight = i - 1;																											                  // set allowed distance of bishop moving downRight to be i - 1
			break;																																			                        // break from for loop
		end
	end
	
	// bishopAllowDownLeft
	for(int i = 1; i < 9; i++)	begin																								                    // iterates i from 1 to 8 and executes if conditional each time
    if((column < i) | (row > 7 - i) | (boardPos[row + i][column - i][1:0] == {color, 1'b1}))	begin 	// checks if column is less than i, checks if row is greater than 7 - i, or if boardPos "i" units below and left of bishop has a piece and is the same color as the bishop
			bishopAllowDownLeft = i - 1;																											              // set allowed distance of bishop moving downLeft to be i - 1
			break;																																			                    // break from for loop
		end
	end
	
end
	
endmodule
