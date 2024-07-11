extends AIMove


func check_transition(delta) -> Array:
	if character.global_position.distance_to(spawn_point) < 1:
		return [true, "idle"]
	return [false, ""]


func update(delta):
	var grounded_spawn_pos = spawn_point
	grounded_spawn_pos.y = character.global_position.y
	
	character.velocity = character.global_position.direction_to(grounded_spawn_pos) * character.return_speed
	character.look_at(grounded_spawn_pos)
	character.move_and_slide()


func on_enter():
	animator.speed_scale = character.return_speed / character.speed


func on_exit():
	animator.speed_scale = 1
