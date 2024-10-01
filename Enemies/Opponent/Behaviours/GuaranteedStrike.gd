extends OpponentBehaviour

@export var outspace_read_chance : float
var will_counter_outspace : bool = false

func formulate_input(delta : float) -> OpponentActionInput:
	if attack_will_miss():
		return input_away_from_player()
	return input_towards_player()


func attack_will_miss() -> bool:
	# an analog of beliefs.player_is_missing_attack()
	# ugly and doesn't scale, TODO if current_action is AttackAction or smth
	if current_action.action_name == "longsword_1" and will_counter_outspace:
		var closest_point = beliefs.player_position() + beliefs.player_to_us_direction() * beliefs.our_collision_radius
		return closest_point.distance_to(current_action.initial_position) > beliefs.character_attack_radius()
	return false

func is_open_to_reconsiderations() -> bool:
	var animation_ended = current_action.works_longer_than(current_action.duration)
	if animation_ended:
		forced_to_reconsider = true
		return true
	# ugly and doesn't scale, TODO if current_action is AttackAction or smth
	if current_action.action_name == "longsword_1" and current_action.works_longer_than(current_action.releases_priority):
		return true
	return false


func on_enter_behaviour():
	will_counter_outspace = randf() < outspace_read_chance


func select_initial_action():
	enter_action("longsword_1")
