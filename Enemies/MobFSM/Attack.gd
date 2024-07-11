extends AIMove


@export var animation_length : float


func check_transition(delta) -> Array:
	if works_longer_than(animation_length):
		if player.global_position.distance_to(character.global_position) < character.attack_radius:
			return [true, "attack"]
		if player.global_position.distance_to(spawn_point) > character.deaggro_radius:
			return [true, "return"]
		return [true, "pursuit"]
	return [false, ""]


# wanna be a tracking window
# for better approach (smooth and easili editable turns) you can watch my MM3 video about tracking
# and controller series ep.4 for backend animations framework
func update(delta):
	if works_less_than(0.2):
		var grounded_player_pos = player.global_position
		grounded_player_pos.y = character.global_position.y
		character.look_at(grounded_player_pos)
