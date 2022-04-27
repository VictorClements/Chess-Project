// pawn module testbench
module testbenchPawn();
  logic         clk, reset;
  logic [5:0] 	pos;
  logic			colorPawn;
  logic [2:0]	allow, allowExpected;
  logic [31:0]  vectornum, errors;
  logic [9:0]   testvectors[10000:0];

  // instantiate device under test
  pawn dut(pos, colorPawn, allow);

  // generate clock
  always 
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("pawntestvector.txt", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #27; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {pos, colorPawn, allowExpected} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  always @(negedge clk)
    if (~reset) begin // skip during reset
      if (allow !== allowExpected) begin  // check result
        $display("Error: inputs = %b", {pos, colorPawn});
        $display("  outputs = %b (%b expected)",allow, allowExpected);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 10'bx) begin 
        $display("%d tests completed with %d errors", 
	           vectornum, errors);
        $finish;
      end
    end
endmodule
