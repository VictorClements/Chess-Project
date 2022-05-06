// vga.sv

module vga(input  logic clk, reset,
	   input  logic [4:0] boardPos [7:0][7:0],
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
  videoGen videoGen(x, y, boardPos, r, g, b); 
  
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
		input  logic [2:0] boardPos [7:0][7:0],
		output logic [7:0] r, g, b); 

  logic pixel; 
  logic [11:0] positionInfo;
  // given y position, choose a character to display 
  // then look up the pixel value from the character ROM 
  // and display it in red or blue. Also draw a green rectangle. 
    rectgen rectgen(x, y, boardPos, positionInfo); 
  
  always_comb	begin
	  casez({positionInfo[11:10], positionInfo[6]})
	3'b00?:		begin
		{r, g, b} = 24'hEEEED2;
		pieceGen(x, y, positionInfo, pixel);
		{r, g, b} = (pixel) ? {24{~positionInfo[6]}} : 24'hEEEED2;
	end
	3'b01?:		begin
		{r, g, b} = 24'h448844;
		pieceGen(x, y, positionInfo, pixel);
		{r, g, b} = (pixel) ? {24{~positionInfo[6]}} : 24'h448844;
	end
	3'b1??:		{r, g, b} = 24'h000000;
	default:	{r, g, b} = 24'h000000;
	endcase
  end
  

  
  //assign {r, b, g} = (positionInfo[2] == 0) ? 24'hEEEED2 : 24'h769656;

  //assign g      = inrect    ? 8'hFF : 8'h00;  

endmodule


module pieceGen(input  logic [9:0]	x, y,
		input  logic [11:0] 	positionInfo,	//[11:10] square color 00 white, 01 black, other = not on board. [9:7] piece type, [6] color, [5:0] row and column
		output logic		pixel);	
	
  logic [49:0] piece[310:0];	// to hold piece sprites (file only actually has 300 lines)
  logic [49:0] line;		// hold a line of sprite
  initial $readmemb("pieces.txt", piece);
	
	always_comb	begin
		case(positionInfo[9:7])
			3'b001:		begin
				line = piece[y%50];
				pixel = line[x%50];
			end
			3'b010:		begin	
				line = piece[y%50 + 50];
				pixel = line[x%50];
			end
			3'b011:		begin	
				line = piece[y%50 + 100];
				pixel = line[x%50];
			end
			3'b100:		begin	
				line = piece[y%50 + 150];
				pixel = line[x%50];
			end
			3'b101:		begin	
				line = piece[y%50 + 200];
				pixel = line[x%50];
			end
			3'b110:		begin	
				line = piece[y%50 + 250];
				pixel = line[x%50];
			end
			default:	pixel = 1'b0;
		endcase
	end
	
endmodule

  //chargenrom chargenromb(y[8:3]+8'd65, x[2:0], y[2:0], pixel); 
  //assign {r, b} = (y[3]==0) ? {{8{pixel}},8'h00} : {8'h00, {8{pixel}}}; 
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

module rectgen(input  logic [9:0] x, y, 
	       input  logic [4:0] boardPos [7:0][7:0],
	       output logic [11:0] positionInfo);	//first two bits say square color, next 4 bits are piece type and piece color, last 6 bits are row and column
			   
 always_comb	begin
		//first row
		if( (x >= 80) & (x < 140) & (y >= 0) & (y < 60) )
			positionInfo = {2'b00, boardPos[0][0][4:1], 3'd0, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 0) & (y < 60) )
			positionInfo = {2'b01, boardPos[0][1][4:1], 3'd0, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 0) & (y < 60) )
			positionInfo = {2'b00, boardPos[0][2][4:1], 3'd0, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 0) & (y < 60) )
			positionInfo = {2'b01, boardPos[0][3][4:1], 3'd0, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 0) & (y < 60) )
			positionInfo = {2'b00, boardPos[0][4][4:1], 3'd0, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 0) & (y < 60) )
			positionInfo = {2'b01, boardPos[0][5][4:1], 3'd0, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 0) & (y < 60) )
			positionInfo = {2'b00, boardPos[0][6][4:1], 3'd0, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 0) & (y < 60) )
			positionInfo = {2'b01, boardPos[0][7][4:1], 3'd0, 3'd7};
		//second row
		else if( (x >= 80) & (x < 140) & (y >= 60) & (y < 120) )
			positionInfo = {2'b01, boardPos[1][0][4:1], 3'd1, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 60) & (y < 120) )
			positionInfo = {2'b00, boardPos[1][1][4:1], 3'd1, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 60) & (y < 120) )
			positionInfo = {2'b01, boardPos[1][2][4:1], 3'd1, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 60) & (y < 120) )
			positionInfo = {2'b00, boardPos[1][3][4:1], 3'd1, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 60) & (y < 120) )
			positionInfo = {2'b01, boardPos[1][4][4:1], 3'd1, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 60) & (y < 120) )
			positionInfo = {2'b00, boardPos[1][5][4:1], 3'd1, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 60) & (y < 120) )
			positionInfo = {2'b01, boardPos[1][6][4:1], 3'd1, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 60) & (y < 120) )
			positionInfo = {2'b00, boardPos[1][7][4:1], 3'd1, 3'd7};
		//third row
		else if( (x >= 80) & (x < 140) & (y >= 120) & (y < 180) )
			positionInfo = {2'b00, boardPos[2][0][4:1], 3'd2, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 120) & (y < 180) )
			positionInfo = {2'b01, boardPos[2][1][4:1], 3'd2, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 120) & (y < 180) )
			positionInfo = {2'b00, boardPos[2][2][4:1], 3'd2, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 120) & (y < 180) )
			positionInfo = {2'b01, boardPos[2][3][4:1], 3'd2, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 120) & (y < 180) )
			positionInfo = {2'b00, boardPos[2][4][4:1], 3'd2, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 120) & (y < 180) )
			positionInfo = {2'b01, boardPos[2][5][4:1], 3'd2, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 120) & (y < 180) )
			positionInfo = {2'b00, boardPos[2][6][4:1], 3'd2, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 120) & (y < 180) )
			positionInfo = {2'b01, boardPos[2][7][4:1], 3'd2, 3'd7};
		//fouth row
		else if( (x >= 80) & (x < 140) & (y >= 180) & (y < 240) )
			positionInfo = {2'b01, boardPos[3][0][4:1], 3'd3, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 180) & (y < 240) )
			positionInfo = {2'b00, boardPos[3][1][4:1], 3'd3, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 180) & (y < 240) )
			positionInfo = {2'b01, boardPos[3][2][4:1], 3'd3, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 180) & (y < 240) )
			positionInfo = {2'b00, boardPos[3][3][4:1], 3'd3, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 180) & (y < 240) )
			positionInfo = {2'b01, boardPos[3][4][4:1], 3'd3, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 180) & (y < 240) )
			positionInfo = {2'b00, boardPos[3][5][4:1], 3'd3, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 180) & (y < 240) )
			positionInfo = {2'b01, boardPos[3][6][4:1], 3'd3, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 180) & (y < 240) )
			positionInfo = {2'b00, boardPos[3][7][4:1], 3'd3, 3'd7};
		//fifth row
		else if( (x >= 80) & (x < 140) & (y >= 240) & (y < 300) )
			positionInfo = {2'b00, boardPos[4][0][4:1], 3'd4, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 240) & (y < 300) )
			positionInfo = {2'b01, boardPos[4][1][4:1], 3'd4, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 240) & (y < 300) )
			positionInfo = {2'b00, boardPos[4][2][4:1], 3'd4, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 240) & (y < 300) )
			positionInfo = {2'b01, boardPos[4][3][4:1], 3'd4, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 240) & (y < 300) )
			positionInfo = {2'b00, boardPos[4][4][4:1], 3'd4, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 240) & (y < 300) )
			positionInfo = {2'b01, boardPos[4][5][4:1], 3'd4, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 240) & (y < 300) )
			positionInfo = {2'b00, boardPos[4][6][4:1], 3'd4, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 240) & (y < 300) )
			positionInfo = {2'b01, boardPos[4][7][4:1], 3'd4, 3'd7};
		//sixth row
		else if( (x >= 80) & (x < 140) & (y >= 300) & (y < 360) )
			positionInfo = {2'b01, boardPos[5][0][4:1], 3'd5, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 300) & (y < 360) )
			positionInfo = {2'b00, boardPos[5][1][4:1], 3'd5, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 300) & (y < 360) )
			positionInfo = {2'b01, boardPos[5][2][4:1], 3'd5, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 300) & (y < 360) )
			positionInfo = {2'b00, boardPos[5][3][4:1], 3'd5, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 300) & (y < 360) )
			positionInfo = {2'b01, boardPos[5][4][4:1], 3'd5, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 300) & (y < 360) )
			positionInfo = {2'b00, boardPos[5][5][4:1], 3'd5, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 300) & (y < 360) )
			positionInfo = {2'b01, boardPos[5][6][4:1], 3'd5, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 300) & (y < 360) )
			positionInfo = {2'b00, boardPos[5][7][4:1], 3'd5, 3'd7};
		//seventh row
		else if( (x >= 80) & (x < 140) & (y >= 360) & (y < 420) )
			positionInfo = {2'b00, boardPos[6][0][4:1], 3'd6, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 360) & (y < 420) )
			positionInfo = {2'b01, boardPos[6][1][4:1], 3'd6, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 360) & (y < 420) )
			positionInfo = {2'b00, boardPos[6][2][4:1], 3'd6, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 360) & (y < 420) )
			positionInfo = {2'b01, boardPos[6][3][4:1], 3'd6, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 360) & (y < 420) )
			positionInfo = {2'b00, boardPos[6][4][4:1], 3'd6, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 360) & (y < 420) )
			positionInfo = {2'b01, boardPos[6][5][4:1], 3'd6, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 360) & (y < 420) )
			positionInfo = {2'b00, boardPos[6][6][4:1], 3'd6, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 360) & (y < 420) )
			positionInfo = {2'b01, boardPos[6][7][4:1], 3'd6, 3'd7};
		//eighth row4
		else if( (x >= 80) & (x < 140) & (y >= 420) & (y < 480) )
			positionInfo = {2'b01, boardPos[7][0][4:1], 3'd7, 3'd0};
		else if( (x >= 140) & (x < 200) & (y >= 420) & (y < 480) )
			positionInfo = {2'b00, boardPos[7][1][4:1], 3'd7, 3'd1};
		else if( (x >= 200) & (x < 260) & (y >= 420) & (y < 480) )
			positionInfo = {2'b01, boardPos[7][2][4:1], 3'd7, 3'd2};
		else if( (x >= 260) & (x < 320) & (y >= 420) & (y < 480) )
			positionInfo = {2'b00, boardPos[7][3][4:1], 3'd7, 3'd3};
		else if( (x >= 320) & (x < 380) & (y >= 420) & (y < 480) )
			positionInfo = {2'b01, boardPos[7][4][4:1], 3'd7, 3'd4};
		else if( (x >= 380) & (x < 440) & (y >= 420) & (y < 480) )
			positionInfo = {2'b00, boardPos[7][5][4:1], 3'd7, 3'd5};
		else if( (x >= 440) & (x < 500) & (y >= 420) & (y < 480) )
			positionInfo = {2'b01, boardPos[7][6][4:1], 3'd7, 3'd6};
		else if( (x >= 500) & (x < 560) & (y >= 420) & (y < 480) )
			positionInfo = {2'b00, boardPos[7][7][4:1], 3'd7, 3'd7};
		//when out of x and y bounds
		else
			positionInfo = 5'b11000;
	end
	
endmodule
