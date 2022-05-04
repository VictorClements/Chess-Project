module button_controller (
  input logic reset,
  input logic UP, DOWN,
  input logic LEFT, RIGHT,

  output logic [6:0] segments1,
  output logic [6:0] segments2
  );

 //Current state of ROW
  logic [2:0] current_state = 3'b0;

  //Current state of COLUMN
  logic [2:0] current_state2 = 3'b0;

  //Temporary outputs for each Up or Down module,
  //that later feeds into current_state
  //(used for segments1)
  logic [2:0] current_state_1;
  logic [2:0] current_state_2;


  //Temporary outputs for each Up or Down module,
  //that later feeds into current_state
  //(used for segments2)
  logic [2:0] current_state_3;
  logic [2:0] current_state_4;

  //when button logic is asserted current state outputs to
  //current_state_1 for UP button, UP button Logic (For segment1)
  up_left_button one(UP, reset, current_state, current_state_1 );

  //DOWN button Logic (For segment1)
  down_right_button two(DOWN, reset, current_state, current_state_2);


  /*
  current bug is in this part, we need to update the current state
  with the last current_state_1 or current_state_2
  */
   always_comb
	begin
	current_state = current_state_1 | current_state_2;
   end

	//LEFT button Logic (For segment2)
   up_left_button three(LEFT, reset, next_state2, current_state_3 );


   //RIGHT button Logic (For segment2)
   down_right_button four(RIGHT, reset, next_state2, current_state_4);


  /*
  current bug is in this part, we need to update the current state
  with the last current_state_3 or current_state_4
  */
   always_comb
	begin
	current_state2 = current_state_3 | current_state_4;
   end


  //SENDS 3-bit data to seven segment,
  //that will be sent to VGA controller
  sevenseg display(current_state , segments1);
  sevenseg display2(current_state2, segments2);


endmodule
