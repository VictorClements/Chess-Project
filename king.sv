/*
Encoding:
color: black = 1, white = 0
position (0,0) is in top left of board
position (7,7) is in bottom right of board
king allowable moves: 
kingAllow[7] = up; 
kingAllow[6] = upRight;
kingAllow[5] = right;
kingAllow[4] = rightDown; 
kingAllow[3] = down;
kingAllow[2] = downLeft;
kingAllow[1] = left; 
kingAllow[0] = upLeft;
*/

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 5 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bits 4:2 represents piece type 001 Pawn, 010 knight, 011 bishop, 100 rook, 101 queen, 110 king, 000 N/A
module king(input  logic [2:0] row,
						input  logic [2:0] column,
						input  logic 	   	 color,
						input  logic [2:0] boardPos [7:0][7:0],
            output logic [7:0] kingAllow);

	always_comb begin	//determines if possible movements are allowed based on position and other pieces (not finished yet)
    
		//up
		if(row == 3'b0)																																							kingAllow[7] = 1'b0;	// if in top row cannot move up
		else if(boardPos[row-1][column][1:0] == {color, 1'b1})																			kingAllow[7] = 1'b0;	// if there is a same colored piece in row above of king, cannot move up
		else																																												kingAllow[7] = 1'b1;	// can move up
		
		//upRight
		if((row == 3'b0) | (column == 3'b111))																											kingAllow[6] = 1'b0;	// if in top row, or in rightmost column cannot move upRight
		else if(boardPos[row-1][column+1][1:0] == {color, 1'b1})																		kingAllow[6] = 1'b0;	// if there is a same colored piece up and right, cannot move upRight
		else																																												kingAllow[6] = 1'b1;	// can move upRight
		
		//right
		if(column == 3'b111)																																				kingAllow[5] = 1'b0;	// if in rightmost column cannot move right
		else if(boardPos[row][column+1][0] == {color, 1'b1})																				kingAllow[5] = 1'b0;	// if there is a same colored piece in column right of king, cannot move right
		else																																												kingAllow[5] = 1'b1;	// can move right
		
		//downRight
		if((row == 3'b111) | (column == 3'b111))																										kingAllow[4] = 1'b0;	// if in bottom row, or in rightmost column cannot move downRight
		else if(boardPos[row+1][column+1][1:0] == {color, 1'b1})																		kingAllow[4] = 1'b0;	// if there is a same colored piece down and right of king, cannot move downRight
		else																																												kingAllow[4] = 1'b1;	// can move downRight

		//down
		if(row == 3'b111)																																						kingAllow[3] = 1'b0;	// if in bottom row cannot move down
		else if(boardPos[row+1][column][1:0] == {color, 1'b1})																			kingAllow[3] = 1'b0;	// if there is a same colored piece in row below of king, cannot move down
		else																																												kingAllow[3] = 1'b1;	// can move down
		
		//downLeft
		if((row == 3'b111) | (column == 3'b0))																											kingAllow[2] = 1'b0;	// if in bottom row, or in leftmost column cannot move downLeft
		else if(boardPos[row+1][column-1][1:0] == {color, 1'b1})																		kingAllow[2] = 1'b0;	// if there is a same colored piece down and left, cannot move downLeft
		else																																												kingAllow[2] = 1'b1;	// can move downLeft
		
		//left
		if(column == 3'b0)																																					kingAllow[1] = 1'b0;	// if in leftmost column cannot move left
		else if(boardPos[row][column-1][0] == {color, 1'b1})																				kingAllow[1] = 1'b0;	// if there is a same colored piece in column left of king, cannot move left
		else																																												kingAllow[1] = 1'b1;	// can move left
		
		//upLeft
		if((row == 3'b0) | (column == 3'b0))																												kingAllow[0] = 1'b0;	// if in top row, or in leftmost column cannot move upLeft
		else if(boardPos[row-1][column-1][1:0] == {color, 1'b1})																		kingAllow[0] = 1'b0;	// if there is a same colored piece down and left of king, cannot move downLeft
		else																																												kingAllow[0] = 1'b1;	// can move downLeft
  end
endmodule
