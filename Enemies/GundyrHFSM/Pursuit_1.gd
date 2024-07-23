extends HFSM


@export var speed : float = 1.5
@export var tracking_angular_speed : float = 2

func check_transition(_delta):
	return TransitionData.new(false, "")


func update(delta : float):
	
	var face_direction = character.basis.z
	var angle = face_direction.signed_angle_to(projected_direction_to_player(), Vector3.UP)
	if abs(angle) >= tracking_angular_speed * delta:
		character.velocity = face_direction.rotated(Vector3.UP, sign(angle) * tracking_angular_speed * delta) * speed
		character.rotate_y(sign(angle) * tracking_angular_speed * delta)
	else:
		character.velocity = face_direction.rotated(Vector3.UP, angle) * speed
		character.rotate_y(angle)
	
	#character.look_at(get_projected_player_pos(), Vector3.UP, true)
	#character.velocity = character.basis.z * speed
	character.move_and_slide()
