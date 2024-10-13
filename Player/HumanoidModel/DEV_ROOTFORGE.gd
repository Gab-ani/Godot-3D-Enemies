extends Node

@onready var animator = $"../SplitBodyAnimator/Legs"
@onready var move_database = $"../States/MovesData/MoveDatabase"
@onready var model = $".."

@onready var general_skeleton = %GeneralSkeleton
@onready var animation_player = $"../CringeJailForBadInterfaces/AnimationPlayer"


func _ready():
	DEV_split_animation("greatsword_light_1_hackwork_Z_PROJECTED")
	DEV_split_animation("greatsword_light_2_hackwork_Z_PROJECTED")
	DEV_split_animation("greatsword_light_3_hackwork_Z_PROJECTED")
	DEV_split_animation("greatsword_light_4_hackwork_Z_PROJECTED")
	DEV_split_animation("greatsword_heavy_2_hackwork_Z_PROJECTED")
	DEV_split_animation("greatsword_heavy_1_hackwork_Z_PROJECTED")
	
	#DEV_nail_z_coordinate("roll_legs", "roll_params", -0.062)
	#DEV_nail_z_coordinate("pushback", "pushback_params", -0.062)
	pass

#DEVELOPMENT LEAYER FUNCTIONAL, IT DOES MODIFY ASSETS, UNCOMMENT IF YOU KNOW WHAT YOU ARE DOING
#AND DID BACKUPS
#func DEV_nail_z_coordinate(animation_name : String, into_backend_animation : String, value : float):
	#if not model.is_enemy:
		#var animation = animator.get_animation(animation_name) as Animation
		#var backend_animation = move_database.get_animation(into_backend_animation) as Animation
		#var backend_track = backend_animation.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
		#var hips_track = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
		#print(animation.track_get_key_count(hips_track))
		#for i : int in animation.track_get_key_count(hips_track):
			#var position = animation.track_get_key_value(hips_track, i)
			#var time = animation.track_get_key_time(hips_track, i)
			#backend_animation.track_insert_key(backend_track, time, position)
			#print(str(position) + " at " + str(time))
			#var position_without_z = position
			#position_without_z.z = value
			#animation.track_set_key_value(hips_track, i, position_without_z)
		#ResourceSaver.save(animation, "res://Assets/Ready Animations/" + animation_name + "_Z_PROJECTED.res")
		#ResourceSaver.save(backend_animation, "res://Player/Moves/BackendAnimations/" + into_backend_animation + "_WITH_ROOT.res")


func DEV_split_animation(animation : String):
	var split = split_animation(general_skeleton, animation_player.get_animation(animation))
	ResourceSaver.save(split[0], "res://Assets/Ready Animations/mixamo_torso_animations/" + animation + "_torso.res")
	ResourceSaver.save(split[1], "res://Assets/Ready Animations/mixamo_legs_animations/" + animation + "_legs.res")
	






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










































