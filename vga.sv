// vga.sv

module vga(input  logic clk, reset,
           output logic vgaclk,          // 25.175 MHz VGA clock 
           output logic hsync, vsync, 
           output logic sync_b, blank_b, // to monitor & DAC 
           output logic [7:0] r, g, b);  // to video DAC 

  logic [9:0] x, y; 

  // Use a clock divider to create the 25 MHz VGA pixel clock 
  // 25 MHz clk period = 40 ns 
  // Screen is 800 clocks wide by 525 tall, but only 640 x 480 used for display 
  // HSync = 1/(40 ns * 800) = 31.25 kHz 
  // Vsync = 31.25 KHz / 525 = 59.52 Hz (~60 Hz refresh rate) 
  
  // divide 50 MHz input clock by 2 to get 25 MHz clock
  always_ff @(posedge clk, posedge reset)
    if (reset)
	   vgaclk = 1'b0;
    else
	   vgaclk = ~vgaclk;
		
  // generate monitor timing signals 
  vgaController vgaCont(vgaclk, reset, hsync, vsync, sync_b, blank_b, x, y); 

  // user-defined module to determine pixel color 
  videoGen videoGen(x, y, r, g, b); 
  
endmodule 


module vgaController #(parameter HBP     = 10'd48,   // horizontal back porch
                                 HACTIVE = 10'd640,  // number of pixels per line
                                 HFP     = 10'd16,   // horizontal front porch
                                 HSYN    = 10'd96,   // horizontal sync pulse = 60 to move electron gun back to left
                                 HMAX    = HBP + HACTIVE + HFP + HSYN, //48+640+16+96=800: number of horizontal pixels (i.e., clock cycles)
                                 VBP     = 10'd32,   // vertical back porch
                                 VACTIVE = 10'd480,  // number of lines
                                 VFP     = 10'd11,   // vertical front porch
                                 VSYN    = 10'd2,    // vertical sync pulse = 2 to move electron gun back to top
                                 VMAX    = VBP + VACTIVE + VFP  + VSYN) //32+480+11+2=525: number of vertical pixels (i.e., clock cycles)                      

     (input  logic vgaclk, reset,
      output logic hsync, vsync, sync_b, blank_b, 
      output logic [9:0] hcnt, vcnt); 

      // counters for horizontal and vertical positions 
      always @(posedge vgaclk, posedge reset) begin 
        if (reset) begin
          hcnt <= 0;
          vcnt <= 0;
        end
        else  begin
          hcnt++; 
      	   if (hcnt == HMAX) begin 
            hcnt <= 0; 
  	        vcnt++; 
  	        if (vcnt == VMAX) 
  	          vcnt <= 0; 
          end 
        end
      end 
	  

      // compute sync signals (active low) 
      assign hsync  = ~( (hcnt >= (HACTIVE + HFP)) & (hcnt < (HACTIVE + HFP + HSYN)) ); 
      assign vsync  = ~( (vcnt >= (VACTIVE + VFP)) & (vcnt < (VACTIVE + VFP + VSYN)) ); 
      // assign sync_b = hsync & vsync; 
      assign sync_b = 1'b0;  // this should be 0 for newer monitors

      // force outputs to black when not writing pixels
      // The following also works: assign blank_b = hsync & vsync; 
      assign blank_b = (hcnt < HACTIVE) & (vcnt < VACTIVE); 
endmodule 


module videoGen(input  logic [9:0] x, y,
		//input  logic [2:0] boardPos [7:0][7:0],
		output logic [7:0] r, g, b); 

  logic pixel, whiteSqr, blackSqr;
  
  // given y position, choose a character to display 
  // then look up the pixel value from the character ROM 
  // and display it in red or blue. Also draw a green rectangle. 
	//chargenrom chargenromb(y[8:3]+8'd65, x[2:0], y[2:0], pixel); 		//change
	

	rectgen boardgen(x, y, 10'd80, 10'd0, 10'd560, 10'd480, whiteSqr, blackSqr); 	//change
  
	always_comb	begin
		case({whiteSqr, blackSqr})
			2'b01:		{r, b, g} = 24'h769656;	//dark green color for black squares
			2'b10:		{r, b, g} = 24'hEEEED2;	//light tan color for white squares
			default:	{r, b, g} = 24'h000000;	//all other pixels will be black
		endcase
	end

	//assign {r, b} = (y[3]==0) ? {{8{pixel}},8'h00} : {8'h00, {8{pixel}}}; 	//change
  	//assign g      = inrect    ? 8'hFF : 8'h00;  				//change

endmodule

/*
module chargenrom(input  logic [7:0] ch, 
                  input  logic [2:0] xoff, yoff,  
                  output logic       pixel); 

  logic [5:0] charrom[2047:0]; // character generator ROM 
  logic [7:0] line;            // a line read from the ROM 

  // initialize ROM with characters from text file 
  initial $readmemb("charrom.txt", charrom); 

  // index into ROM to find line of character 
  assign line = charrom[yoff+{ch-65, 3'b000}];  // subtract 65 because A 
                                                // is entry 0 
  // reverse order of bits 
  assign pixel = line[3'd7-xoff]; 
  
endmodule 
*/
module boardgen(input  logic [9:0] x, y, left, top, right, bot, 
                output logic 	   white, black);

	logic exit;
	
	always_comb	begin
		for(int i = 0; i < 8; i++)	begin
			for(int j = 0; j < 8; j++)	begin
				if ( (x >= (left + (j * 10'd60))) & (x < (left + ((j + 1) * 10'd60))) & (y >= (top + (i * 10'd60))) & (y < (top + ((i+1) * 10'd60))) ) begin
					if( ((i + j) % 2) == 0)		begin	
						white = 1'b1;
						black = 1'b0;
						exit = 1'b1;
						break;
					end
					else if( ((i+j) % 2) == 1)	begin
						white = 1'b0;
						black = 1'b1;
						exit = 1'b1;
						break;
					end
				end
			end
			if(exit == 1'b1)	break;
		end
		if(exit == 1'b0)	begin
			white = 1'b0;
			black = 1'b0;
		end
	end
endmodule 
