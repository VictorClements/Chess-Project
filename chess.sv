/* possible replacement for the inital for array very long but not sure if inital block will actually work
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

*/

module chess(input  logic	clk, reset,	//clk and reset for system 
	     input  logic 	rowChange, columnChange, //inputs from board from key buttons
	     input  logic	UP,				//input from board from lever
	     input  logic	select,				//input from board from key button to select a position
	     input  logic	place,				//input from board from key button to place piece in position
	     output logic [6:0]	rowDisplay, columnDisplay,	//output cursor position onto hex sevensegs
	     output logic	vgaclk,				//vga output clk
	     output logic	hsync, vsync,			//vga output horiz and vert sync
	     output logic	sync_b, blank_b,		//vga outupt ?
	     output logic [7:0]	r, g, b);			//vga pixel color

// boardPos is a 2-D array with 8 rows and 8 columns, and each element of the array is a 5 bit value
// bit 0 represents if the space is empty (no piece on the space) space is occuped = 1 and space is empty = 0
// bit 1 represents the color of the piece on the space, no piece = 0 (default),  white = 0, black = 1
// bits 4:2 represents piece type 001 Pawn, 010 knight, 011 bishop, 100 rook, 101 queen, 110 king, 000 No piece	
  logic	      match;
  logic [2:0] originalRow, originalColumn
  logic [4:0] selectedPiece;
  logic [2:0] rowNum, columnNum;
  logic [4:0] boardPos [7:0][7:0];
  logic [23:0] moves;
  initial $readmemb("start.txt", boardPos);	// initialize boardPos array to starting chess piece placements
	
  positionCounter myPos(rowChange, columnChange, reset, UP, rowNum, columnNum, rowDisplay, columnDisplay);	// input for cursor
  vga myvga(clk, reset, boardPos, vgaclk, hsync, vsync, sync_b, blank_b, r, g, b);  				//output for vga display
	always_ff @(posedge select) 	begin	//when the select button is pressed
		selectedPiece <= boardPos[rowNum][columnNum][4:0];	//assign selectedPiece the current position info
		originalRow <= rowNum;					//record this original row
		originalColumn <= columnNum;				//record this original column
		allowedMoves pieceMoves(selectedPiece, rowNum, columnNum, boardPos, moves);	//instantiate allowedMoves to see what moves are allowed for this piece
	end
	
	always_ff @(posedge place)	begin	//when the place button is pressed
		matchAllowedMoves matches(selectedPiece, moves, originalRow, originalColumn, rowNum, columnNum, match);		//instantiate matchAllowedMoves module to see if attempted move matches allowed moves
		if(match) begin							//if match is true
			boardPos[rowNum][columnNum][4:0] = selectedPiece;	//move piece to new position
			boardPos[originalRow][origininalColumn][4:0] = 5'b0;	//reset original position to no picee
		end
		else	selectedPiece = 5'b0;		//otherwise reset to selected piece to 5'b0	//remove the else case?
		selectedPiece = 5'b0;
	end
	
endmodule

module pawnMatch(input  logic [2:0] moves,
		 input  logic	    color,
		 input  logic [2:0] originalRow, originalColumn,
		 input  logic [2:0] placedRow, placedColumn,
		 output logic	    match);
	
	always_comb	begin
		case(color)	begin
			1'b0:	begin
				if( moves[0] & ((placedRow + 1) == originalRow) & (placedColumn == (originalColumn + 1)) ) 	match = 1;
				else if( moves[1] & ((placedRow + 1) == originalRow) & (placedColumn == originalColumn) )	match = 1;
				else if( moves[2] & ((placedRow + 1) == originalRow) & ((placedColumn + 1) == originalColumn)	match = 1;
				else												match = 0;
			end
			1'b1:	begin
				if( moves[0] & (placedRow == (originalRow + 1)) & (placedColumn == (originalColumn + 1)) ) 	match = 1;
				else if( moves[1] & (placedRow == (originalRow + 1)) & (placedColumn == originalColumn) )	match = 1;
				else if( moves[2] & (placedRow == (originalRow + 1)) & ((placedColumn + 1) == originalColumn) )	match = 1;
				else												match = 0;
			end
			default:	match = 1'b0;
		endcase
	end
	
endmodule
					
module knightMatch(input  logic [7:0] moves,
		   input  logic	      color,
		   input  logic [2:0] originalRow, originalColumn,
		   input  logic [2:0] placedRow, placedColumn,
		   output logic	      match);
	
	always_comb	begin
		
	end
	
endmodule

module bishopMatch(input  logic [7:0] moves,
		   input  logic	      color,
		   input  logic [2:0] originalRow, originalColumn,
		   input  logic [2:0] placedRow, placedColumn,
		   output logic	      match);
	
	always_comb	begin
		
	end
	
endmodule

module rookMatch(input  logic [7:0] moves,
		 input  logic	    color,
		 input  logic [2:0] originalRow, originalColumn,
		 input  logic [2:0] placedRow, placedColumn,
		 output logic	    match);
	
	always_comb	begin
		
	end
	
endmodule
					
module queenMatch(input  logic [7:0] moves,
		  input  logic	     color,
		  input  logic [2:0] originalRow, originalColumn,
		  input  logic [2:0] placedRow, placedColumn,
		  output logic	     match);
	
	always_comb	begin
		
	end
	
endmodule
					
module kingMatch(input  logic [7:0] moves,
		 input  logic	    color,
		 input  logic [2:0] originalRow, originalColumn,
		 input  logic [2:0] placedRow, placedColumn,
		 output logic	    match);
	
	always_comb	begin
		
	end
	
endmodule
					
module matchAllowedMoves(input  logic [4:0]	selectedPiece,	//finish cases for if it matches or not
			 input  logic [23:0]	moves,
			 input	logic [2:0]	originalRow, originalColumn, placedRow, placedColumn,
			 output logic		match);

	always_comb	begin
		casez(selectedPiece)	begin
			5'b????0:	match = 0;
			5'b000??:	match = 0;
			5'b001?1:	pawnMatch pawnM(moves[2:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			5'b010?1:	knightMatch knightM(moves[7:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			5'b011?1:	bishopMatch bishopM(moves[11:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			5'b100?1:	rookMatch rookM(moves[11:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			5'b101?1:	queenMatch queenM(moves[23:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			5'b110?1:	kingMatch kingM(moves[7:0], selectedPiece[1], originalRow, originalColumn, placedRow, placedColumn, match);
			default:	match = 0;
		endcase	
	end	
endmodule

module allowedMoves(input  logic [4:0]  selectedPiece,
		    input logic  [2:0]	rowNum, columnNum,
		    input  logic [4:0]  boardPos[7:0][7:0],
		    output logic [23:0] moves);
	
	always_comb	begin
		casez(selectedPiece)	begin
			5'b????0:	moves = 24'b0;
			5'b000??:	moves = 24'b0;
			5'b001?1:	begin
				pawn(rowNum, columnNum, selectedPiece[1], boardPos, moves[2:0]);
				moves[23:3] = 21'b0;
			end
			5'b010?1:	begin
				knight(rowNum, columnNum, selectedPiece[1], boardPos, moves[7:0]);
				moves[23:8] = 16'b0;
			end
			5'b011?1:	begin
				bishop(rowNum, columnNum, selectedPiece[1], boardPos, moves[11:9], moves[8:6], moves[5:3], moves[2:0]);
				moves[23:12] = 12'b0;
			end
			5'b100?1:	begin
				rook(rowNum, columnNum, selectedPiece[1], boardPos, moves[11:9], moves[8:6], moves[5:3], moves[2:0]);
				moves[23:12] = 12'b0;
			end
			5'b101?1:	begin
				queen(rowNum, columnNum, selectedPiece[1], boardPos, moves[23:21], moves[20:18], moves[17:15], moves[14:12], moves[11:9], moves[8:6], moves[5:3], moves[2:0]);
			end
			5'b110?1:	begin
				king(rowNum, columnNum, selectedPiece[1], boardPos, moves[7:0]);
				moves[23:8] = 16'b0
			end
			default:	moves = 24'b0;
		endcase
	end
			
	
endmodule


	//pawn(i, j, boardPos[i][j][1], boardPos, )

	//maybe replace with: for(logic [3:0] i = 4'b0; i < 4'd8; i + 1'b1) and for(logic [3:0] j = 4'b0; j < 4'd8; j + 1'b1)
/*	
  always_comb	begin
    for(int i = 0; i < 8; i++)	begin			
      for(int j = 0; j < 8; j++)	begin
	casez(boardPos[i][j][4:0])	begin
	  5'b????0:	// Empty
	  5'b001?1:	// Pawn
	  5'b100?1:	// Rook
	  5'b010?1:	// Knight
	  5'b011?1:	// Bishop
	  5'b101?1:	// Queen
	  default:
	endcase
      end
    end
  end
*/



//my current solution is to do something that seems like it would be a huge waste of space:
/*
module playerAllowedMoves(input  logic [4:0]    boardPos [7:0][7:0],
			  output logic [1535:0] moves);
			  
  always_comb	begin
	  for(int i = 0; i < 8; i++)	begin			
      for(int j = 0; j < 8; j++)	begin
	casez(boardPos[i][j][4:0])	begin
	  5'b????0:	// Empty
	  5'b001?1:	pawn	p(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 2 ):( (j + 8*i)*24 )]	// Pawn
	  5'b100?1:	rook	r(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 11 ):( (j + 8*i)*24 )]	// Rook
	  5'b010?1:	knight	n(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 7 ):( (j + 8*i)*24 )]	// Knight
	  5'b011?1:	bishop	b(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 11 ):( (j + 8*i)*24 )]	// Bishop
	  5'b101?1:	queen	q(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 23 ):( (j + 8*i)*24 )]	// Queen
	  5'b110?1:	king	k(i, j, boardPos[i][j][1], boardPos, moves[( (j + 8*i)*24 + 7 ):( (j + 8*i)*24 )]	// King
	  default:
	endcase
      end
    end
  end
endmodule
*/
