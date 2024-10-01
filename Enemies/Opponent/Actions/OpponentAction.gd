extends Node
class_name OpponentAction


@export var action_name : String
@export var animation : String
@export var backend_animation : String
@export var tracking_angular_speed : float = 20
@export var stamina_cost : float = 0

# in our player's controller priority was the main mechanism to fuel transitions.
# here it's a secondary tool to rule out conflicts during synchronous forced transitions,
# you can have this set only on actions that are being forced: death, staggers, parry-grabs etc.
@export_group("priority")
@export var priority : int = 2

var beliefs : OpponentBeliefs
var character : CharacterBody3D
var action_data_repo : OpponentActionsData
var resources : OpponentResources

var right_hand_weapon : Weapon
var left_wrist : BoneAttachment3D

var work_start : float
var duration : float

func update(input : OpponentActionInput, delta : float):
	pass


func _on_enter_action():
	resources.pay_resource_cost(self)
	mark_enter_state()
	on_enter_action()

func on_enter_action():
	pass

func on_exit_action():
	pass


func move_by_root_motion(delta : float):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	character.velocity = character.get_quaternion() * delta_pos / delta
	#if not character.is_on_floor():
		# transition to fall
	character.move_and_slide()


func track_player_if_possible(input : OpponentActionInput, delta : float):
	if tracks_player():
		var face_direction = character.basis.z
		var angle = face_direction.signed_angle_to(input.direction_input, Vector3.UP)
		character.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))


func mark_enter_state():
	work_start = Time.get_unix_time_from_system()

func get_progress() -> float:
	return Time.get_unix_time_from_system() - work_start

func works_less_than(time : float) -> bool:
	return get_progress() < time

func works_longer_than(time : float) -> bool:
	return get_progress() > time

func is_vulnerable() -> bool:
	return action_data_repo.get_vulnerable(backend_animation, get_progress())

func is_interruptable() -> bool:
	return action_data_repo.get_interruptable(backend_animation, get_progress())

func tracks_player() -> bool:
	return action_data_repo.get_tracking(backend_animation, get_progress())

func is_locked_in_animation() -> bool:
	return action_data_repo.locks_in_animation(backend_animation, get_progress())

func get_root_position_delta(delta) -> Vector3:
	return action_data_repo.get_root_delta_pos(backend_animation, get_progress(), delta)

func right_weapon_hurts() -> bool:
	return action_data_repo.right_weapon_hurts(backend_animation, get_progress())
