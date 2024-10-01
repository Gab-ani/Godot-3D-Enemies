extends OpponentBehaviour


func formulate_input(delta ) -> OpponentActionInput:
	var next_input = OpponentActionInput.new()
	next_input.direction_input = beliefs.player_to_us_direction()
	return next_input

func is_open_to_reconsiderations():
	return true

func select_initial_action():
	enter_action("run")
