extends HFSM


@export var hit_damage : float = 30
@export var next_attacks : Array[HFSM]
@export var pushes_back : bool = false
@export_group("bad assets adjustment")
@export var angle_adjustment : float = 0  # radians
@export var tracking_angular_speed : float = 1


func check_transition(_delta) -> TransitionData:
	if player_too_far():
		var gapclosing_method = ["gapclose", "pursuit"].pick_random()
		return TransitionData.new(true, gapclosing_method)
	if player_too_close():
		return TransitionData.new(true, "kick")
	if works_longer_than(get_animation_length()):
		return TransitionData.new(true, next_attacks.pick_random().move_name)
	return TransitionData.new(false, "")

func player_too_far() -> bool:
	return works_longer_than(get_animation_length()) and distance_to_player() > get_parent().pursuit_radius 

func player_too_close() -> bool:
	return works_longer_than(get_animation_length()) and distance_to_player() < get_parent().scare_off_radius and move_name != "kick"


func update(delta):
	rotate_character(delta)
	move_character(delta)
	manage_weapons()


func rotate_character(delta):
	var adjusted_direction = direction_to_player().rotated(Vector3.UP, angle_adjustment)
	var face_direction = character.basis.z
	var angle = face_direction.signed_angle_to(adjusted_direction, Vector3.UP)
	character.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))
	# lazier way, looks more tripy: character.look_at(character.global_position + adjusted_direction, Vector3.UP, true)

func move_character(delta):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	character.velocity = character.get_quaternion() * delta_pos / delta
	if not character.is_on_floor():
		character.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	character.move_and_slide()


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	#hit.is_parryable = is_parryable()
	if pushes_back:
		hit.effects["pushback"] = true
		hit.effects["pushback_direction"] = projected_direction_to_player()
	hit.weapon = weapon
	return hit


func on_exit():
	deactivate_weapons()

