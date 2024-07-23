extends Move


@export var movement_multiplier : float = 2

func update(_input : InputPackage, delta : float):
	humanoid.look_at(humanoid.global_position + area_awareness.last_pushback_vector)
	
	var delta_pos = get_root_position_delta(delta) 
	delta_pos.y = 0
	humanoid.velocity = (humanoid.get_quaternion() * delta_pos / delta) * movement_multiplier
	if not humanoid.is_on_floor():
		humanoid.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	humanoid.move_and_slide()
