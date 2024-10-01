extends CharacterBody3D


@onready var input_gatherer = $Input as InputGatherer
@onready var model = $Model as PlayerModel
@onready var visuals = $Visuals as PlayerVisuals
@onready var camera_mount = $CameraMount
@onready var collider = $Collider


func _ready():
	visuals.accept_model(model)
	#$CameraMount/PlayerCamera.current = false
	#print_tree_pretty()


func _physics_process(delta):
	var input = input_gatherer.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
	input.queue_free()


# the section below contains some getters utilised by enemies to
# analyze battle situation, currently it's used in Opponent project
# if you only read this file to look at player's controller code, skip freely
func hp_percentage() -> float:
	return model.resources.health / model.resources.max_health

func is_attacking() -> bool:
	return model.current_move is AttackMove

func current_attack_radius() -> float:
	if not is_attacking():
		return 0
	return model.current_move.attack_radius

func current_attack_locked_time_left() -> float:
	if not is_attacking():
		return 0
	return model.current_move.time_til_priority_release()

func current_move_initial_position() -> Vector3:
	return model.current_move.initial_position

func current_move_posttracking_radius() -> float:
	return model.current_move.posttracking_radius

func time_til_attack_connection() -> float:
	if not is_attacking():
		return 99999
	return model.current_move.extremum_timing - model.current_move.get_progress()

func is_rolling() -> bool:
	return model.current_move.move_name == "roll"

func roll_time_left() -> float:
	if is_rolling():
		return model.current_move.DURATION - model.current_move.get_progress()
	return 0

func get_roll_endpoint() -> Vector3:
	if is_rolling():
		return model.current_move.endpoint
	return Vector3(1000,1000,1000)

func get_current_move_position_after(time : float) -> Vector3:
	var moves_data = model.current_move.moves_data_repo as MovesDataRepository
	var data_track = model.current_move.backend_animation
	var future = model.current_move.get_progress() + time
	# you can check out the original method usage, it is used to "go back in time"
	# but technically nothing stops us from predicting future with it as well
	var predicted_delta_pos = moves_data.get_root_delta_pos(data_track, future, time)
	return global_position + get_quaternion() * predicted_delta_pos

func is_locked_in_animation() -> bool:
	return not model.current_move.tracks_input_vector()

func time_til_next_last_locked_frame() -> float:
	if not is_locked_in_animation():
		return 0
	return model.current_move.time_til_unlocking()

# pandora's box potentialy, better return immutable snapshot copy or use getters for fields,
# otherwise some out-of-palyer functional can mess with controller's flow
# but who cares
func get_current_move() -> Move:
	return model.current_move




# works but stuns the game, need some other approach(
#func get_guaranteed_positions_list() -> Array[Array]:
	#var positions_list = model.current_move.get_guaranteed_positions_list()
	#print(model.current_move.move_name + str(positions_list))
	#return positions_list
