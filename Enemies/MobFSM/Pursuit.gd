extends AIMove




func check_transition(delta) -> Array:
	if player.global_position.distance_to(character.global_position) < character.attack_radius:
		return [true, "attack"]
	if player.global_position.distance_to(spawn_point) > character.deaggro_radius:
		return [true, "return"]
	return [false, ""]


func update(delta):
	var grounded_player_pos = player.global_position
	grounded_player_pos.y = character.global_position.y
	
	character.velocity = character.global_position.direction_to(grounded_player_pos) * character.speed
	character.look_at(grounded_player_pos)
	character.move_and_slide()
