always_comb	begin
	// determines if possible movements are allowed based on position and other pieces
	// not sure if row will be counted as signed or unsigned number, perhaps change comparisons to account for that
	// also unsure if bishopAllow = i - 1 will work properly, since the number of bits of i - 1 is not specified and we are storing it into a 3 bit logic variable
	
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
