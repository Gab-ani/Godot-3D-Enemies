@tool
extends EditorScript

var library = preload("res://Assets/Ready Animations/controller_lib.res") as AnimationLibrary
var skeleton_donor_scene = preload("res://Player/HumanoidModel/HumanoidModel.tscn")

func _run():
	var scene = skeleton_donor_scene.instantiate()
	var skeleton = scene.get_node("GeneralSkeleton") as MixamoSkeleton
	var new_legs_library : AnimationLibrary = AnimationLibrary.new()
	var new_torso_library : AnimationLibrary = AnimationLibrary.new()
	for animation_name in library.get_animation_list():
		var animation = library.get_animation(animation_name) as Animation
		var torso_and_legs = split_animation(skeleton, animation) # 0: torso, 1: legs
		new_torso_library.add_animation(animation_name + "_torso", torso_and_legs[0])
		new_legs_library.add_animation(animation_name + "_legs", torso_and_legs[1])
	print(new_legs_library.get_animation_list())
	print(new_torso_library.get_animation_list())
	ResourceSaver.save(new_torso_library, "res://Assets/Ready Animations/mixamo_torso_animations/torso_controller_lib.res")
	ResourceSaver.save(new_legs_library, "res://Assets/Ready Animations/mixamo_legs_animations/legs_controller_lib.res")
	
	scene.queue_free()

func split_animation(skeleton : Skeleton3D, animation : Animation) -> Array[Animation]:
	var new_torso_animation : Animation = Animation.new()
	var new_legs_animation : Animation = Animation.new()
	new_torso_animation.length = animation.length
	new_legs_animation.length = animation.length
	var torso_indeces = get_torso_bones_indeces(skeleton)
	var legs_indeces = get_legs_bones_indeces(skeleton)
	for track in animation.get_track_count():
		#print(animation.track_get_path(track))
		var track_path  : String = animation.track_get_path(track)
		var bone_name = track_path.replace("%GeneralSkeleton:", "")
		var bone_index = skeleton.find_bone(bone_name)
		if torso_indeces.has(bone_index):
			animation.copy_track(track, new_torso_animation)
		if legs_indeces.has(bone_index):
			animation.copy_track(track, new_legs_animation)
	return [new_torso_animation, new_legs_animation]

func get_torso_bones_indeces(skeleton : Skeleton3D) -> Array:
	return get_hierarchy_indexes(skeleton, 1)


func get_legs_bones_indeces(skeleton : Skeleton3D) -> Array:
	var right_leg_indeces = get_hierarchy_indexes(skeleton, skeleton.find_bone("RightUpperLeg"))
	var left_leg_indeces = get_hierarchy_indexes(skeleton, skeleton.find_bone("LeftUpperLeg"))
	var result = [0] # Hips
	result.append_array(right_leg_indeces)
	result.append_array(left_leg_indeces)
	return result


func get_hierarchy_indexes(skeleton : Skeleton3D, root_idx : int) -> Array:
	var indeces = []
	for child_bone in skeleton.get_bone_children(root_idx):
		indeces.append_array(get_hierarchy_indexes(skeleton, child_bone)) 
	indeces.append(root_idx)
	indeces.sort()
	return indeces
