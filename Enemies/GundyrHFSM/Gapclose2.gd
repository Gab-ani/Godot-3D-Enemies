extends HFSM


var default_range : float = 2.2
var gapclosing_coefficient : float 
@export var hit_damage : float = 30
@export_group("bad assets adjustment")
@export var angle_adjustment : float = 0  # radians
@export var tracking_angular_speed : float = 1


func check_transition(_delta) -> TransitionData:
	if works_longer_than(get_animation_length()):
		return TransitionData.new(true, ["kick", "elbow"].pick_random())
	return TransitionData.new(false, "")


func update(delta):
	rotate_character(delta)
	move_character(delta)
	manage_weapons()

func rotate_character(delta):
	var adjusted_direction = direction_to_player().rotated(Vector3.UP, angle_adjustment)
	
	var face_direction = character.basis.z
	var angle = face_direction.signed_angle_to(adjusted_direction, Vector3.UP)
	character.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))


func move_character(delta):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	character.velocity = ( character.get_quaternion() * delta_pos / delta ) * gapclosing_coefficient
	if not character.is_on_floor():
		character.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	character.move_and_slide()


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	#hit.is_parryable = is_parryable()
	hit.weapon = weapon
	return hit


func on_enter():
	gapclosing_coefficient = distance_to_player() / default_range

func on_exit():
	deactivate_weapons()
