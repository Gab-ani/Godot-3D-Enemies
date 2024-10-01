extends OpponentBehaviour


func update(input : OpponentActionInput, delta : float):
	pass

func choose_action():
	pass

func formulate_input(delta : float) -> OpponentActionInput:
	print_debug("something tried to use base formulate input")
	return null


func is_open_to_reconsiderations() -> bool:
	return false

func on_enter_behaviour():
	pass

func on_exit_behaviour():
	pass

# 
func select_initial_action():
	enter_action("idle")
