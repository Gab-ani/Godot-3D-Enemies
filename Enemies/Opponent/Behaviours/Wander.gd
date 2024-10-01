extends OpponentBehaviour


var max_radius : float = 4
var min_radius : float = 2

var run_speed = 3

var trajectories : Array[PackedVector3Array]
var current_trajectory : PackedVector3Array
var current_direction_index : int
var current_direction_distance : float

func _ready():
	accept_trajectories()
	#break_into_deltas(trajectory)
	#print(left_trajectory)


func formulate_input(delta : float) -> OpponentActionInput:
	#if beliefs.distance_to_player() > max_radius or beliefs.distance_to_player() < min_radius:
		##print(beliefs.distance_to_player())
		#return radius_input(delta)
	#else:
		#
	return trajectory_input(delta)

#
#func radius_input(delta : float):
	#var ideal_position = beliefs.player_position() + beliefs.player_to_us_direction() * (max_radius + min_radius) / 2
	#var next_input = OpponentActionInput.new()
	#next_input.direction_input = beliefs.character_direction_to(ideal_position)
	#return next_input


func trajectory_input(delta : float):
	var current_delta : Vector3 = current_trajectory[current_direction_index + 1] - current_trajectory[current_direction_index]
	var d_cen : Vector3 = current_delta.project(current_trajectory[current_direction_index])
	var d_orb : Vector3 = current_delta - d_cen
	var direction_to_player = beliefs.character_direction_to_player() * -1 * sign(current_trajectory[current_direction_index].dot(d_cen))
	var relative_cen = direction_to_player * d_cen.length()
	var relative_orb = d_orb.rotated(Vector3.UP, d_cen.signed_angle_to(relative_cen, Vector3.UP))
	var next_input = OpponentActionInput.new()
	next_input.direction_input = relative_cen + relative_orb
	return next_input


func update(input : OpponentActionInput, delta : float):
	current_action.update(input, delta)
	current_direction_distance += run_speed * delta
	var current_delta : Vector3 = current_trajectory[current_direction_index + 1] - current_trajectory[current_direction_index]
	if current_direction_distance >= current_delta.length():
		current_direction_index += 1
		current_direction_distance = 0

# we always are free to change, but we also force changes when the trajectory is ran through
func is_open_to_reconsiderations() -> bool:
	if current_direction_index == current_trajectory.size() - 1:
		forced_to_reconsider = true
	return true


func on_enter_behaviour():
	current_trajectory = trajectories.pick_random()
	current_direction_index = 0
	current_direction_distance = 0
	#print("_______________________________________________________________________________")


func select_initial_action():
	enter_action("run")


func accept_trajectories():
	for child in get_children():
		if child is Path3D:
			trajectories.append(child.curve.tessellate())
	#print(trajectories.size())



