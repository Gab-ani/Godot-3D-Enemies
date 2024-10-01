extends OpponentBehaviour


func formulate_input(delta ) -> OpponentActionInput:
	var next_input = OpponentActionInput.new()
	next_input.direction_input = beliefs.character_direction_to_player()
	return next_input


func is_open_to_reconsiderations():
	return current_action.works_longer_than(current_action.duration)

func on_enter_behaviour():
	pass

func on_exit_behaviour():
	pass

# 
func select_initial_action():
	enter_action("cheese_throw")

