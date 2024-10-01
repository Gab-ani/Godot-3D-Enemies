extends OpponentBehaviour


func is_open_to_reconsiderations():
	return current_action.works_longer_than(current_action.duration)


# lazy bullshit TODO enchance to incorporate geometry for different heights
# instarotation as in case with player
func on_enter_behaviour():
	character.look_at(character.global_position + beliefs.character_direction_to_player())


func select_initial_action():
	enter_action("roll")
