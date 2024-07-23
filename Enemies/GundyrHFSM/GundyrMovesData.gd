extends Node
class_name GundyrMovesData

@onready var move_database = $MoveDatabase

func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos

func get_parryable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_parryable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

func is_attacking(weapon: String, animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:" + weapon + "_hurts", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

#func get_halberd_hurts(animation : String, timecode : float) -> bool:
	#var data = move_database.get_animation(animation)
	#var track = data.find_track("MoveDatabase:halberd_hurts", Animation.TYPE_VALUE)
	#return move_database.get_boolean_value(animation, track, timecode)
#
#func get_shoulder_hurts(animation : String, timecode : float) -> bool:
	#var data = move_database.get_animation(animation)
	#var track = data.find_track("MoveDatabase:shoulder_hurts", Animation.TYPE_VALUE)
	#return move_database.get_boolean_value(animation, track, timecode)
#
#func get_kick_hurts(animation : String, timecode : float) -> bool:
	#var data = move_database.get_animation(animation)
	#var track = data.find_track("MoveDatabase:kick_hurts", Animation.TYPE_VALUE)
	#return move_database.get_boolean_value(animation, track, timecode)
#
#func get_aura_hurts(animation : String, timecode : float) -> bool:
	#var data = move_database.get_animation(animation)
	#var track = data.find_track("MoveDatabase:aura_hurts", Animation.TYPE_VALUE)
	#return move_database.get_boolean_value(animation, track, timecode)
