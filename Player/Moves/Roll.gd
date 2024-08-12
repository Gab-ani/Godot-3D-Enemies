extends Move



func update(_input : InputPackage, delta):
	move_player(delta)


func move_player(delta : float):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	humanoid.velocity = humanoid.get_quaternion() * delta_pos / delta
	humanoid.move_and_slide()


func on_enter_state():
	var input = area_awareness.last_input_package
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	if input_direction:
		humanoid.look_at(humanoid.global_position + input_direction, Vector3.UP, true)
