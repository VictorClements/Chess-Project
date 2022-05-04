/*
Encoding:
color: black = 1, white = 0
position (0,0) is in top left of board
position (7,7) is in bottom right of board
queen allowable moves: 
queenAllowUp[2:0]
queenAllowRight[2:0]
queenAllowDown[2:0]
queenAllowLeft[2:0]
queenAllowUpLeft[2:0]
queenAllowUpRight[2:0]
queenAllowDownRight[2:0]
queenAllowDownLeft[2:0]

*/

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 5 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bits 4:2 represents piece type 001 Pawn, 010 knight, 011 bishop, 100 rook, 101 queen, 110 king, 000 N/A
module queen(input  logic [2:0] row,
						 input  logic [2:0] column,
						 input  logic 	    color,
						 input  logic [2:0] boardPos [7:0][7:0],
					   output logic [2:0] queenAllowUpLeft, queenAllowUpRight, queenAllowDownRight, queenAllowDownLeft, queenAllowUp, queenAllowRight, queenAllowDown, queenAllowLeft);
	
always_comb	begin
	// determines if possible movements are allowed based on position and other pieces
	// not sure if row will be counted as signed or unsigned number, perhaps change comparisons to account for that
	// also unsure if queenAllow = i - 1 will work properly, since the number of bits of i - 1 is not specified and we are storing it into a 3 bit logic variable. maybe do "queenAllow = 3'd(i - 1)" ? 
	
	// queenAllowUp
	for(int i = 1; i < 9; i++)	begin																						// iterates i from 1 to 8 and executes if conditional each time
		if((row < i) | (boardPos[row - i][column][1:0] == {color, 1'b1}))	begin 	// checks if row is less than i, or if boardPos "i" units above queen has a piece and is the same color as the queen
			queenAllowUp = i - 1;																										// set allowed distance of queen moving up to be i - 1
			break;																																	// break from for loop
		end
	end
	
	// queenAllowRight
	for(int i = 1; i < 9; i++)	begin																									// iterates i from 1 to 8 and executes if conditional each time
		if((column > 7 - i) | (boardPos[row][column + i][1:0] == {color, 1'b1}))	begin // checks if column is greater than 7 - i, or if boardPos "i" units right of queen has a piece and is the same color as the queen
			queenAllowRight = i - 1;																											// set allowed distance of queen moving right to be i - 1
			break;																																				// break from for loop
		end
	end
	
	// queenAllowDown
	for(int i = 1; i < 9; i++)	begin																								// iterates i from 1 to 8 and executes if conditional each time
		if((row > 7 - i) | (boardPos[row + i][column][1:0] == {color, 1'b1}))	begin 	// checks if row is greater than 7 - i, or if boardPos "i" units below queen has a piece and is the same color as the queen
			queenAllowDown = i - 1;																											// set allowed distance of queen moving down to be i - 1
			break;																																			// break from for loop
		end
	end
	
	// queenAllowLeft
	for(int i = 1; i < 9; i++)	begin																								// iterates i from 1 to 8 and executes if conditional each time
		if((column < i) | (boardPos[row][column - i][1:0] == {color, 1'b1}))	begin 	// checks if column is less than i, or if boardPos "i" units left of queen has a piece and is the same color as the queen
			queenAllowLeft = i - 1;																											// set allowed distance of queen moving left to be i - 1
			break;																																			// break from for loop
		end
	end
		
	
	// queenAllowUpLeft
	for(int i = 1; i < 9; i++)	begin																						                    // iterates i from 1 to 8 and executes if conditional each time
    if((row < i) | (column < i) | (boardPos[row - i][column - i][1:0] == {color, 1'b1}))	begin 	// checks if row is less than i, if column is less than i, or if boardPos "i" units above and left of queen has a piece and is the same color as the queen
			queenAllowUpLeft = i - 1;																								            		  	// set allowed distance of queen moving upLeft to be i - 1
			break;																																	                    // break from for loop
		end
	end
	
	// queenAllowUpRight
	for(int i = 1; i < 9; i++)	begin																									                  // iterates i from 1 to 8 and executes if conditional each time
    if((column > 7 - i) | (row < i) | (boardPos[row - i][column + i][1:0] == {color, 1'b1}))	begin   // checks if column is greater than 7 - i, if row is less than i, or if boardPos "i" units above and right of queen has a piece and is the same color as the queen
			queenAllowUpRight = i - 1;																												              // set allowed distance of queen moving upRight to be i - 1
			break;																																				                  // break from for loop
		end
	end
	
	// queenAllowDownRight
	for(int i = 1; i < 9; i++)	begin																								                        // iterates i from 1 to 8 and executes if conditional each time
    if((row > 7 - i) | (column > 7 - i) | (boardPos[row + i][column + i][1:0] == {color, 1'b1}))	begin 	// checks if row is greater than 7 - i, checks if column is greater than 7 - i, or if boardPos "i" units below and right queen has a piece and is the same color as the queen
			queenAllowDownRight = i - 1;																											                  // set allowed distance of queen moving downRight to be i - 1
			break;																																			                        // break from for loop
		end
	end
	
	// queenAllowDownLeft
	for(int i = 1; i < 9; i++)	begin																								                    // iterates i from 1 to 8 and executes if conditional each time
    if((column < i) | (row > 7 - i) | (boardPos[row + i][column - i][1:0] == {color, 1'b1}))	begin 	// checks if column is less than i, checks if row is greater than 7 - i, or if boardPos "i" units below and left of queen has a piece and is the same color as the queen
			queenAllowDownLeft = i - 1;																											              	// set allowed distance of queen moving downLeft to be i - 1
			break;																																			                    // break from for loop
		end
	end
	
end
	
endmodule
