module chessFSM(input  logic  	   clk, reset,
				input  logic  	   WM, WC, BM, BC, SM	// WhiteMove, WhiteCheckMate, BlackMove, BlackCheckMate
				output logic [1:0] Win); 				// Win[0] = black wins, Win[1] = white wins
	// SReset, SWhiteTurn, SBlackTurn, SWhiteMate, SBlackMate, SStaleMate
	typedef enum logic [2:0] {SR, SWT, SBT, SWM, SBM, SSM} statetype;			
	statetype state, nextstate;			
	
	// state register
	always_ff @(posedge clk, posedge reset)
		if (reset)	state <= SR;
		else		state <= nextstate;
	
	// next state logic
	always_comb
		case(state)
			SR:					nextstate = SWT;
			SWT:	begin
				if (SM)			nextstate = SSM;
				else if (~WM)	nextstate = SWT;
				else if (~WC)	nextstate = SBT;
				else			nextstate = SWM;
			end
			SBT:	begin
				if (SM)			nextstate = SSM;
				else if (~BM)	nextstate = SBT;
				else if (~BC)	nextstate = SWT;
				else			nextstate = SBM;				
			end
			SWM:				nextstate = SWM;
			SBM:				nextstate = SBM;
			SSM:				nextstate = SSM;
			default:			nextstate = SR;
		endcase
		
	// output logic
	assign Win = {(state == SWM) | (state == SSM) , (state == SBM) | (state == SSM)}

endmodule