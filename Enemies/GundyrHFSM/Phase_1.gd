extends HFSM


@export var phase_switch_hp_treshold = 0.5        # % of maximum


func check_transition(_delta) -> TransitionData:
	if resources.health < resources.max_health * phase_switch_hp_treshold:
		return TransitionData.new(true, "phase_switch")
	return TransitionData.new(false, "")


func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "chill_1")
