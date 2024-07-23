extends HFSM


func check_transition(_delta) -> TransitionData:
	return TransitionData.new(false, "as we are top layer single state, we never transition")


func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "idle")
