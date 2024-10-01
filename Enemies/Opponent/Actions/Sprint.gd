extends OpponentAction


@export var sprint_speed : float = 5
@export var angular_speed : float
@export var turn_speed : float = 1
@export var stamina_per_second : float = 20

func update(input : OpponentActionInput, delta : float):
	resources.lose_stamina(stamina_per_second * delta)
	
	var face_direction = character.basis.z
	var angle = face_direction.signed_angle_to(input.direction_input, Vector3.UP)
	if abs(angle) >= angular_speed * delta:
		character.velocity = face_direction.rotated(Vector3.UP, sign(angle) * angular_speed * delta) * turn_speed
		character.rotate_y(sign(angle) * angular_speed * delta)
	else:
		character.velocity = face_direction.rotated(Vector3.UP, angle) * sprint_speed
		character.rotate_y(angle)
	
		character.move_and_slide()
