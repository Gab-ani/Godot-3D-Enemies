extends OpponentAction


func is_locked_in_animation() -> bool:
	return works_less_than(duration)


func update(input : OpponentActionInput, delta : float):
	if works_longer_than(duration):
		beliefs.character.force_reconsideration()

