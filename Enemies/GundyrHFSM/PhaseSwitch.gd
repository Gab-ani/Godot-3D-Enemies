extends HFSM


func check_transition(_delta) -> TransitionData:
	if works_longer_than(get_animation_length()):
		return TransitionData.new(true, "phase_2")
	return TransitionData.new(false, "")

