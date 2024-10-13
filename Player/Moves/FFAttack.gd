extends Move
class_name FFAttack


@export var RELEASES_PRIORITY : float
@export var hit_damage = 20 # will be a function of player stats in the future

var attack_target : Node3D

@export_group("gapclose")
@export var gapcloses : bool = false
@export var base_length : float
var gapclosing_coefficient : float

# this strange construction is here because our animation asset has a long tail transitioning to idle,
# think of it as of "custom perfect blending" to idle
# so after a certain point we want to release priority, but to anything except idle
func default_lifecycle(input : InputPackage) -> String:
	var best_input = best_input_that_can_be_paid(input)
	if works_longer_than(RELEASES_PRIORITY):
		if works_longer_than(DURATION) or best_input != "idle":
			return best_input
	return "okay"


func update(_input : InputPackage, delta):
	turn_player(delta)
	move_player(delta)
	humanoid.model.active_weapon.is_attacking = right_weapon_hurts()


func turn_player(delta):
	if free_flow.has_target:
		var target_dir = humanoid.global_position.direction_to(attack_target.global_position)
		var face_direction = humanoid.basis.z
		var angle = face_direction.signed_angle_to(target_dir, Vector3.UP)
		humanoid.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))



func move_player(delta : float):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	humanoid.velocity = humanoid.get_quaternion() * delta_pos / delta
	
	if gapcloses and get_gapcloses():
		humanoid.velocity *= gapclosing_coefficient
	
	if not humanoid.is_on_floor():
		humanoid.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		has_forced_move = true
		forced_move = "midair"
	humanoid.move_and_slide()


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = is_parryable()
	hit.weapon = humanoid.model.active_weapon
	return hit


func on_enter_state():
	attack_target = free_flow.target
	
	if gapcloses and free_flow.has_target:
		gapclosing_coefficient = humanoid.global_position.distance_to(attack_target.global_position) / base_length

func on_exit_state():
	humanoid.model.active_weapon.hitbox_ignore_list.clear()
	humanoid.model.active_weapon.is_attacking = false


func get_gapcloses() -> bool:
	return moves_data_repo.ff_gapcloses(backend_animation, get_progress())








#
#func time_til_priority_release() -> float:
	#return RELEASES_PRIORITY - get_progress()
