extends HFSM

@export var pursuit_radius : float = 8
@export var max_chill_time : float
@export var min_chill_time : float
var will_chill_for : float

func choose_internal_move() -> TransitionData:
	if distance_to_player() > pursuit_radius:
		return TransitionData.new(true, "pursuit_1")
	return TransitionData.new(true, "orbiting")


func check_transition(_delta) -> TransitionData:
	if current_move.works_longer_than(will_chill_for) or caught_up_with_player():
		return TransitionData.new(true, "combat_1")
	return TransitionData.new(false, "")


func caught_up_with_player() -> bool:
	return current_move.move_name == "pursuit_1" and distance_to_player() < pursuit_radius


func on_enter():
	will_chill_for = randf_range(min_chill_time, max_chill_time)
