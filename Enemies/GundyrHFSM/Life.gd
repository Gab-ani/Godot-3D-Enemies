extends HFSM


func check_transition(_delta) -> TransitionData:
	if resources.health < 1:
		return TransitionData.new(true, "death")
	return TransitionData.new(false, "")


func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "phase_1")
