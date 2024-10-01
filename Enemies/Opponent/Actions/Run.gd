extends OpponentAction

@export var run_speed : float = 3
@export var angular_speed : float
@export var turn_speed : float = 1

func update(input : OpponentActionInput, delta : float):
	#character.look_at(character.global_position + input.direction_input, Vector3.UP, true)
	#character.velocity = character.basis.z * run_speed
	#character.move_and_slide()

	var face_direction = character.basis.z
	var angle = face_direction.signed_angle_to(input.direction_input, Vector3.UP)
	if abs(angle) >= angular_speed * delta:
		character.velocity = face_direction.rotated(Vector3.UP, sign(angle) * angular_speed * delta) * turn_speed
		character.rotate_y(sign(angle) * angular_speed * delta)
	else:
		character.velocity = face_direction.rotated(Vector3.UP, angle) * run_speed
		character.rotate_y(angle)
		character.move_and_slide()
