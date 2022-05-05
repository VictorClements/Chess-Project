module chessWrapper(input  logic	CLOCK_50,       // FPGA 50MHz Clock for VGA
		    input  logic [0:0]	SW,             // for reset
                    input  logic [3:0]	KEY,            // for up/down/left/right
                    output logic [6:0]	HEX1, HEX0,     // display of current cursor position with sevenseg display
                    output logic	VGA_CLK,        // clock for VGA to run on
                    output logic	VGA_HS,         // horizontal sync
		    output logic	VGA_VS,         // vertical sync
                    output logic	VGA_SYNC_N,     // ?
		    output logic	VGA_BLANK_N,    // ?
                    output logic [7:0]	VGA_R,          // red pixel outputs
                    output logic [7:0]	VGA_G,          // green pixel outputs
                    output logic [7:0]	VGA_B);         // blue pixel outputs
        
chess chess(CLOCK_50, SW[0], KEY[3:0], HEX1, HEX0, VGA_CLK, VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N, VGA_R, VGA_G, VGA_B);

endmodule
