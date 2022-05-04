module up_button(input logic up,
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

// current_state flip-flop
always_ff@(posedge up, posedge reset) begin
if(reset) current_state<=0;
 else current_state <= next_state;
end

// FSM transitions
always_ff@* begin
 case (current_state)
 0 : next_state <= 7;
 1 : next_state <= 0;
 2 : next_state <= 1;
 3 : next_state <= 2;
 4 : next_state <= 3;
 5 : next_state <= 4;
 6 : next_state <= 5;
 7 : next_state <= 6;
   default : next_state <= 0;
 endcase
end


endmodule
