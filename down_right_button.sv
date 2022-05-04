module down_button(input logic button,
                   input logic reset,
                   input logic [2:0] current_state_in,
                   output [2:0] next_state_out
                  );

logic [2:0] current_state;
logic [2:0] next_state;

always_comb begin
//current_state=current_state_in;
next_state_out=current_state;
end


// current_state ff
always_ff@(posedge button, posedge reset) begin
if(reset) current_state<=0;
 else current_state <= next_state;
end


// FSM
always_ff@* begin
 case (current_state)
 0 : next_state <= 1;
 1 : next_state <= 2;
 2 : next_state <= 3;
 3 : next_state <= 4;
 4 : next_state <= 5;
 5 : next_state <= 6;
 6 : next_state <= 7;
 7 : next_state <= 0;
   default : next_state <= 0;
 endcase
end

endmodule
