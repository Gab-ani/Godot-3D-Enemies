extends HFSM


@export var pursuit_radius : float = 8
@export var scare_off_radius : float = 1.5

func check_transition(_delta):
	return TransitionData.new(false, "")


func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "slash_4")
