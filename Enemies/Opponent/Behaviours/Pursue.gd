extends OpponentBehaviour


func formulate_input(delta ) -> OpponentActionInput:
	return input_towards_player()


func is_open_to_reconsiderations():
	return true


func select_initial_action():
	enter_action("run")

