extends Node
class_name FreeFlowCombat


@export var max_radius : float = 7
var humanoid : CharacterBody3D

var target : Node3D
var has_target : bool = false

func change_target(input : InputPackage):
	var aim_direction = get_aim_direction(input)
	
	var possible_targets = get_tree().get_nodes_in_group("free_flow_target")
	possible_targets = possible_targets.filter(distance_filter)
	if possible_targets.is_empty():
		has_target = false
		return
	
	var best_angle = 999999
	var best_target = possible_targets[0]
	for candidate in possible_targets:
		var dir = humanoid.global_position.direction_to(candidate.global_position)
		var angle = aim_direction.angle_to(dir)
		if angle < best_angle:
			best_angle = angle
			best_target = candidate
	
	target = best_target
	has_target = true

func distance_filter(possible_target : Node3D):
	return possible_target.global_position.distance_to(humanoid.global_position) < max_radius


func get_aim_direction(input : InputPackage) -> Vector3:
	if input.input_direction:
		return (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	else:
		return humanoid.basis.z
