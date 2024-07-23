@tool
extends EditorScript


func _run():
	#DEV_nail_z_coordinate("gapclose_2", -0.085)
	DEV_extract_root_position_track("scare_off")
	pass


func DEV_extract_root_position_track(from : String):
	var animation = load("res://Assets/Ready Animations/Gundyr/moving/" + from + ".res") as Animation
	var backend_animation = load("res://Assets/Ready Animations/Gundyr/backend/" + from + "_backend.res") as Animation
	var hips_track = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
	var root_pos_track = backend_animation.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	for i : int in animation.track_get_key_count(hips_track):
		var position = animation.track_get_key_value(hips_track, i)
		var time = animation.track_get_key_time(hips_track, i)
		backend_animation.track_insert_key(root_pos_track, time, position)


func DEV_nail_z_coordinate(name : String, value : float):
	var animation = load("res://Assets/Ready Animations/Gundyr/moving/" + name + ".res") as Animation
	var rooted_version = animation.duplicate(true)
	var hips_track = rooted_version.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
	print(rooted_version.track_get_key_count(hips_track))
	for i : int in rooted_version.track_get_key_count(hips_track):
		var position = rooted_version.track_get_key_value(hips_track, i)
		var time = rooted_version.track_get_key_time(hips_track, i)
		print(str(position) + " at " + str(time))
		var position_without_z = position
		position_without_z.z = value
		rooted_version.track_set_key_value(hips_track, i, position_without_z)
	ResourceSaver.save(rooted_version, "res://Assets/Ready Animations/Gundyr/rooted/" + name + "_Z_PROJECTED.res")
